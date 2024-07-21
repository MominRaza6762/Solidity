--Lottery Smart Contract

This project is a smart contract for a lottery system, written in Solidity. It allows participants to enter the lottery by sending 1 ether, and the manager can select a winner who receives the entire balance of the contract. This smart contract ensures fairness and transparency in selecting the lottery winner.

## Features

- **Lottery Entry**: Participants can enter the lottery by sending 1 ether.
- **Balance Check**: Only the manager can check the contract's balance.
- **Random Winner Selection**: The manager can select a random winner from the participants.
- **Ether Transfer**: The winner receives the entire balance of the contract.

## Prerequisites

- Solidity compiler version 0.8.2 or higher
- Ethereum wallet with some Ether to deploy and interact with the contract
- Development environment like Remix, Truffle, or Hardhat for compiling and deploying the contract

## Contract Details

### State Variables

- `address public manager`: The address of the lottery manager.
- `address payable[] public participants`: An array of participants' addresses.

### Constructor

The constructor sets the `manager` to the address that deploys the contract.

```solidity
constructor() {
    manager = msg.sender;
}
```

### Functions

#### `receive() external payable`

Allows participants to enter the lottery by sending 1 ether.

```solidity
receive() external payable {
    require(msg.value == 1 ether, "Entry fee is 1 ether");
    participants.push(payable(msg.sender));
}
```

#### `function getBalance() public view returns (uint)`

Allows the manager to view the contract's balance.

```solidity
function getBalance() public view returns (uint) {
    require(msg.sender == manager, "Only manager can check the balance");
    return address(this).balance;
}
```

#### `function random() public view returns (uint)`

Generates a pseudo-random number.

```solidity
function random() public view returns (uint) {
    return uint(keccak256(abi.encode(block.difficulty, block.timestamp, participants.length)));
}
```

#### `function selectWinner() public`

Allows the manager to select a winner and transfer the contract's balance to them. Resets the `participants` array afterward.

```solidity
function selectWinner() public {
    require(msg.sender == manager, "Only manager can select a winner");
    require(participants.length >= 3, "At least 3 participants required");

    uint r = random();
    uint index = r % participants.length;
    address payable winner = participants[index];
    winner.transfer(getBalance());
    participants = new address payable ;
}
```

## Usage

1. **Deploy the Contract**: Deploy the contract to the Ethereum network using your preferred development environment.
2. **Enter the Lottery**: Participants can enter the lottery by sending 1 ether to the contract address.
3. **Check Balance**: The manager can check the contract's balance by calling the `getBalance` function.
4. **Select Winner**: The manager can select a random winner by calling the `selectWinner` function. The winner receives the entire balance of the contract.

## Example

1. Deploy the contract with your Ethereum address. You become the manager.
2. Participants send 1 ether to the contract to enter the lottery.
3. Once there are at least 3 participants, the manager can call `selectWinner` to choose a winner.
4. The selected winner receives the entire contract balance.

## License

This project is licensed under the GPL-3.0 License.

---

Feel free to modify this README to better suit your project's needs or to provide additional details!