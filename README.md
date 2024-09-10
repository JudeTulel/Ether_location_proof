# GPS Based Proof of Location on Blockchain
## Overview

**Proof Of Location** is a decentralized system that verifies the location of participants in real-time using blockchain technology to ensure the accuracy and integrity of location-based services, such as delivery systems and public transportation, by securely logging and verifying the geolocation of users on the blockchain.I also allows for location based activation of smart contracts
## Key Features

**Decentralized Location Verification**: Leverages blockchain for immutable and transparent location verification. Off-Chain Distance Calculation: Efficiently handles complex geolocation calculations off-chain and submits verified results to the blockchain. Automated Smart Contracts: Facilitates automatic contract execution and payment release based on verified location data. Secure and Transparent: Ensures data integrity and transparency, minimizing fraud and disputes.
How It Works

**Start Location**: The sender initiates the process by setting their starting location. DeliveryMedium: the delivery person or vehicle
**End Location**: The receiver sets the delivery or endpoint location after the transaction is completed. Off-Chain Calculation: A backend service calculates the distance between the deliveryMedium and endLocation. Oracle Integration: The calculated distance is sent to the smart contract using an oracle. Validation: The smart contract verifies whether the distance is within the acceptable range. Payment Release: If the distance is validated, the payment is automatically released to the relevant parties.

## Example Use Case

### Delivery Apps In the logistics and delivery sector
- Ensuring that goods are delivered to the correct location is paramount. This Proof of Location system can be integrated into delivery apps to:

- Verify Deliveries: Ensure that packages are delivered to the correct address by validating the proximity of the delivery personnel to the recipient. Automate Payments: Release payments to delivery personnel only when the delivery is confirmed through verified geolocation data. Enhance Trust: Provide transparency to customers and businesses by recording delivery events on the blockchain.
# Setup on your computer

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
