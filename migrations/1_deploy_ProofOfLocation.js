const ProofOfLocation = artifacts.require("ProofOfLocation");

module.exports = function(deployer) {
    const receiverAddress = '0x131FEE4aBC0def18A2810290268D05f3E9Bd5234'; // Replace with the actual receiver address
    const maxDistance = 5; // Replace with the desired max distance value (in meters)
    
    deployer.deploy(ProofOfLocation, receiverAddress, maxDistance);
};
