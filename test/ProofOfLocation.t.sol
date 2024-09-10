// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/ProofOfLocation.sol";

contract PackageDeliveryTest is Test {
    PackageDelivery public packageDelivery;

    address sender = address(0x123);
    address recipient = address(0x456);
    address deliveryGuy = address(0x789);

    uint256 packageId = 1;
    uint256 postage = 1 ether;
    uint8 minRating = 4;

    function setUp() public {
        packageDelivery = new PackageDelivery();

        // Fund the contract with initial ether for deposit operations
        payable(address(packageDelivery)).transfer(2 ether);
    }

    function testCreatePackage() public {
        vm.prank(sender);
        packageDelivery.createPackage(packageId, postage, minRating, recipient);

        (
            uint256 id,
            uint256 post,
            uint8 rating,
            address senderAddr,
            address recipientAddr,
            address deliveryGuyAddr,
            uint256 pickupTimestamp,
            bool isPickedUp,
            bool isDelivered
        ) = packageDelivery.packages(packageId);

        assertEq(id, packageId);
        assertEq(post, postage);
        assertEq(rating, minRating);
        assertEq(senderAddr, sender);
        assertEq(recipientAddr, recipient);
        assertEq(deliveryGuyAddr, address(0)); // No delivery person assigned yet
        assertEq(pickupTimestamp, 0); // Package not picked up yet
        assertEq(isPickedUp, false);
        assertEq(isDelivered, false);
    }

    function testPickupPackage() public {
        // Create a package
        vm.prank(sender);
        packageDelivery.createPackage(packageId, postage, minRating, recipient);

        // Pickup the package as sender
        vm.prank(sender);
        packageDelivery.pickupPackage(packageId, deliveryGuy);

        (,,,,, address deliveryPerson, uint256 timestamp, bool isPickedUp,) = packageDelivery.packages(packageId);

        assertEq(deliveryPerson, deliveryGuy);
        assertEq(isPickedUp, true);
        assertGt(timestamp, 0); // Ensure the timestamp was recorded
    }

    function testDeliverPackage() public {
        // Create and pickup the package
        vm.prank(sender);
        packageDelivery.createPackage(packageId, postage, minRating, recipient);
        vm.prank(sender);
        packageDelivery.pickupPackage(packageId, deliveryGuy);

        // Deliver the package as the delivery person
        vm.prank(deliveryGuy);
        packageDelivery.deliverPackage(packageId);

        (,,,,,,,, bool isDelivered) = packageDelivery.packages(packageId);

        assertEq(isDelivered, true);
    }

    function testDepositFunds() public {
        // Create a package with the correct sender
        vm.prank(sender);
        packageDelivery.createPackage(packageId, postage, minRating, recipient);

        // Ensure sender has enough funds
        vm.deal(sender, 2 ether);

        // Deposit funds from the sender for the created package
        vm.prank(sender);
        packageDelivery.depositFunds{value: 1 ether}(packageId);

        // Check deposit
        assertEq(packageDelivery.senderDeposits(sender), 1 ether);
    }

    function testVerifyAndCompleteDelivery() public {
        // Ensure sender and contract have enough ether
        vm.deal(sender, 2 ether); // Ensure sender has enough funds
        vm.prank(sender);
        packageDelivery.createPackage(packageId, postage, minRating, recipient);
        vm.prank(sender);
        packageDelivery.pickupPackage(packageId, deliveryGuy);

        // Deposit funds as sender
        vm.prank(sender);
        packageDelivery.depositFunds{value: 1 ether}(packageId);

        // Deliver the package
        vm.prank(deliveryGuy);
        packageDelivery.deliverPackage(packageId);

        // Verify and complete delivery by the recipient
        vm.prank(recipient);
        packageDelivery.verifyAndCompleteDelivery(packageId, true, true);

        // Check if the package has been verified
        assertEq(packageDelivery.packageVerified(packageId), true);
    }
}
