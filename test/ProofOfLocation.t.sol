// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/ProofOfLocation.sol";

contract ProofOfLocationTest is Test {
    ProofOfLocation public proofOfLocation;

    address sender = address(0x123);
    address recipient = address(0x456);
    address deliveryGuy = address(0x789);

    uint256 packageId = 1;
    uint256 postage = 1 ether;
    uint8 minRating = 4;

    function setUp() public {
        // Deploy the contract before each test
        proofOfLocation = new ProofOfLocation();

        // Give sender, recipient, and deliveryGuy some Ether for testing
        vm.deal(sender, 10 ether);
        vm.deal(recipient, 10 ether);
        vm.deal(deliveryGuy, 10 ether);

        // Set the sender's address
        vm.prank(sender);
        proofOfLocation.createPackage(packageId, postage, minRating, recipient);
    }

    function testCreatePackage() public {
        // Check that the package is created successfully
        (uint256 id,,, address pkgSender, address pkgRecipient,,,,) = proofOfLocation.packages(packageId);
        assertEq(id, packageId);
        assertEq(pkgSender, sender);
        assertEq(pkgRecipient, recipient);
    }

    function testDepositFunds() public {
        // Deposit postage amount into the contract
        vm.prank(sender);
        proofOfLocation.depositFunds{value: postage}(packageId);

        // Check that funds were deposited
        uint256 deposit = proofOfLocation.senderDeposits(sender);
        assertEq(deposit, postage);
    }

    function testPickupPackage() public {
        // Deposit funds for the package
        vm.prank(sender);
        proofOfLocation.depositFunds{value: postage}(packageId);

        // Pick up the package by the delivery guy
        vm.prank(sender);
        proofOfLocation.pickupPackage(packageId, deliveryGuy);

        // Check that the delivery guy was assigned and timestamp is recorded
        (,,,,, address pkgDeliveryGuy, uint256 pickupTimestamp, bool isPickedUp,) = proofOfLocation.packages(packageId);
        assertEq(pkgDeliveryGuy, deliveryGuy);
        assertEq(isPickedUp, true);
        assertTrue(pickupTimestamp > 0);
    }

    function testDeliverPackage() public {
        // Deposit funds and pick up the package
        vm.prank(sender);
        proofOfLocation.depositFunds{value: postage}(packageId);

        vm.prank(sender);
        proofOfLocation.pickupPackage(packageId, deliveryGuy);

        // Deliver the package
        vm.prank(deliveryGuy);
        proofOfLocation.deliverPackage(packageId);

        // Check that the package is marked as delivered
        (,,,,,,, bool isDelivered,) = proofOfLocation.packages(packageId);
        assertEq(isDelivered, true);
    }

    function testVerifyAndCompleteDelivery() public {
        // Deposit funds, pick up, and deliver the package
        vm.prank(sender);
        proofOfLocation.depositFunds{value: postage}(packageId);

        vm.prank(sender);
        proofOfLocation.pickupPackage(packageId, deliveryGuy);

        vm.prank(deliveryGuy);
        proofOfLocation.deliverPackage(packageId);

        // Verify and complete delivery
        vm.prank(recipient);
        proofOfLocation.verifyAndCompleteDelivery(packageId, true, true);

        // Check that the delivery is verified and funds are transferred
        bool isVerified = proofOfLocation.packageVerified(packageId);
        assertEq(isVerified, true);

        uint256 deposit = proofOfLocation.senderDeposits(sender);
        assertEq(deposit, 0); // Ensure funds are deducted from sender

        uint256 deliveryGuyBalance = deliveryGuy.balance;
        assertEq(deliveryGuyBalance, 11 ether); // Delivery guy received postage
    }

    function testFailOnlySenderCanPickPackage() public {
        // This should fail because only the sender can pick up the package
        vm.prank(recipient);
        proofOfLocation.pickupPackage(packageId, deliveryGuy);
    }

    function testFailOnlyRecipientCanVerify() public {
        // Pick up and deliver the package
        vm.prank(sender);
        proofOfLocation.depositFunds{value: postage}(packageId);

        vm.prank(sender);
        proofOfLocation.pickupPackage(packageId, deliveryGuy);

        vm.prank(deliveryGuy);
        proofOfLocation.deliverPackage(packageId);

        // This should fail because only the recipient can verify the delivery
        vm.prank(sender);
        proofOfLocation.verifyAndCompleteDelivery(packageId, true, true);
    }

    function testFailInsufficientFunds() public {
        // Create a package without depositing funds
        vm.prank(sender);
        proofOfLocation.createPackage(2, postage, minRating, recipient);

        // Attempt to verify delivery without funds (should fail)
        vm.prank(recipient);
        proofOfLocation.verifyAndCompleteDelivery(2, true, true);
    }
}
