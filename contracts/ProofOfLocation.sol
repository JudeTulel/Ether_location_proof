// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProofOfLocation {
    address public sender;
    address public receiver;
    uint256 public startLat;
    uint256 public startLon;
    uint256 public endLat;
    uint256 public endLon;
    uint256 public maxDistance;

    bool public isDeliveryConfirmed;
    bool public isOrderVerified;

    // Event to be emitted after conditions are met
    event DeliveryConfirmedAndOrderVerified(
        address indexed sender,
        address indexed receiver,
        string message,
        bytes32 orderHash
    );

    constructor(address _receiver, uint256 _maxDistance) {
        sender = msg.sender;
        receiver = _receiver;
        maxDistance = _maxDistance;
        isDeliveryConfirmed = false;
        isOrderVerified = false;
    }

    function setStartLocation(uint256 _lat, uint256 _lon) external {
        require(msg.sender == sender, "Only the sender can set the start location");
        startLat = _lat;
        startLon = _lon;
    }

    function setEndLocation(uint256 _lat, uint256 _lon) external {
        require(msg.sender == receiver, "Only the receiver can set the end location");
        endLat = _lat;
        endLon = _lon;
    }

    function validateDelivery(uint256 _calculatedDistance) external {
        require(_calculatedDistance <= maxDistance, "Delivery location is out of acceptable range");
        isDeliveryConfirmed = true;
    }

    function verifyOrder() external {
        // Simulate order verification process
        isOrderVerified = true;
    }

    function releaseEvent(bytes32 orderHash) external {
        require(isDeliveryConfirmed, "Delivery not confirmed yet");
        require(isOrderVerified, "Order not verified yet");

        // Emit event instead of transferring payment
        emit DeliveryConfirmedAndOrderVerified(
            sender,
            receiver,
            "Delivery confirmed and order verified",
            orderHash
        );
    }
}
