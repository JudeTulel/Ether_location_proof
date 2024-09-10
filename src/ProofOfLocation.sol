// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PackageDelivery {
    struct Package {
        uint256 packageId;
        uint256 postage;
        uint8 minRating;
        address sender;
        address recipient;
        address deliveryGuy;
        uint256 pickupTimestamp;
        bool isPickedUp;
        bool isDelivered;
    }

    mapping(uint256 => Package) public packages;
    mapping(uint256 => bool) public packageVerified;

    // To keep track of funds deposited by senders
    mapping(address => uint256) public senderDeposits;

    event PackageCreated(uint256 packageId, address sender, address recipient);
    event PackagePickedUp(uint256 packageId, address deliveryGuy, uint256 timestamp);
    event PackageDelivered(uint256 packageId, address deliveryGuy, uint256 timestamp);
    event FundsDeposited(address sender, uint256 amount);
    event FundsTransferred(address to, uint256 amount);

    // Modifier to ensure only the sender can execute certain functions
    modifier onlySender(uint256 packageId) {
        require(msg.sender == packages[packageId].sender, "Only the sender can perform this action");
        _;
    }

    // Modifier to ensure only the delivery person can execute certain functions
    modifier onlyDeliveryGuy(uint256 packageId) {
        require(msg.sender == packages[packageId].deliveryGuy, "Only the delivery person can perform this action");
        _;
    }

    // Modifier to ensure the package exists
    modifier packageExists(uint256 packageId) {
        require(packages[packageId].sender != address(0), "Package does not exist");
        _;
    }

    // Deposit funds into the contract for a specific package
   function depositFunds(uint256 _packageId) external payable {
    Package storage package = packages[_packageId];
    require(msg.sender == package.sender, "Only the sender can perform this action");
    require(msg.value == package.postage, "Incorrect amount");
    senderDeposits[msg.sender] += msg.value;
}


    // Create a new package order
    function createPackage(uint256 packageId, uint256 postage, uint8 minRating, address recipient) external {
        require(packages[packageId].sender == address(0), "Package ID already exists");

        packages[packageId] = Package({
            packageId: packageId,
            postage: postage,
            minRating: minRating,
            sender: msg.sender,
            recipient: recipient,
            deliveryGuy: address(0),
            pickupTimestamp: 0,
            isPickedUp: false,
            isDelivered: false
        });

        emit PackageCreated(packageId, msg.sender, recipient);
    }

    // Delivery person picks up the package
    function pickupPackage(uint256 packageId, address deliveryGuy)
        external
        onlySender(packageId)
        packageExists(packageId)
    {
        require(!packages[packageId].isPickedUp, "Package already picked up");

        packages[packageId].deliveryGuy = deliveryGuy;
        packages[packageId].pickupTimestamp = block.timestamp;
        packages[packageId].isPickedUp = true;

        emit PackagePickedUp(packageId, deliveryGuy, block.timestamp);
    }

    // Delivery person finishes the transport and delivers the package
    function deliverPackage(uint256 packageId) external onlyDeliveryGuy(packageId) packageExists(packageId) {
        require(packages[packageId].isPickedUp, "Package not picked up yet");
        require(!packages[packageId].isDelivered, "Package already delivered");

        packages[packageId].isDelivered = true;

        emit PackageDelivered(packageId, msg.sender, block.timestamp);
    }

    // Verify package details and release funds
    function verifyAndCompleteDelivery(uint256 packageId, bool proximityCheck, bool verifyPackageId) external {
        require(packages[packageId].recipient == msg.sender, "Only recipient can verify");

        // Off-chain verification checks (e.g., proximity, package ID consistency) would be performed here
        require(proximityCheck, "Delivery person is not in proximity");
        require(verifyPackageId, "Package ID verification failed");

        // If all conditions are met, complete the transaction and release funds
        packageVerified[packageId] = true;

        uint256 postage = packages[packageId].postage;
        address deliveryGuy = packages[packageId].deliveryGuy;
        address sender = packages[packageId].sender;

        // Release funds to the delivery person
        require(senderDeposits[sender] >= postage, "Insufficient funds in contract");
        payable(deliveryGuy).transfer(postage);
        senderDeposits[sender] -= postage;

        emit FundsTransferred(deliveryGuy, postage);
    }

    receive() external payable {
        // Allow the contract to receive Ether
    }
}
