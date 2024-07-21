--CrowdFunding Smart Contract

This project is a smart contract for a crowdfunding campaign written in Solidity. It allows contributors to fund a project by sending Ether. The manager can create spending requests that contributors can vote on. If the project does not reach its target amount by the deadline, contributors can get a refund.

 Features

- **Manager Controlled**: The contract is managed by the address that deploys it.
- **Contributions**: Contributors can send Ether to fund the project.
- **Requests and Voting**: The manager can create requests for spending funds, which contributors can vote on.
- **Refunds**: If the project does not reach its target amount by the deadline, contributors can get a refund.

## Prerequisites

- Solidity compiler version 0.8.2 or higher
- Ethereum wallet with some Ether to deploy and interact with the contract
- Development environment like Remix, Truffle, or Hardhat for compiling and deploying the contract

## Contract Details

### State Variables

- `mapping(address => uint) public contributors`: Stores the contribution amount of each address.
- `address manager`: The address of the contract manager (the one who deploys the contract).
- `uint minContribution`: The minimum amount of Ether required to become a contributor.
- `uint deadLine`: The timestamp after which contributions are no longer accepted.
- `uint targetAmount`: The target amount of Ether to be raised.
- `uint raisedAmount`: The total amount of Ether raised so far.
- `uint noOfContributors`: The total number of unique contributors.
- `mapping(uint => request) public requests`: Stores the spending requests.
- `uint noOfRequest`: The total number of requests created.

### Structs

- `struct request`: Represents a spending request.
  - `string discription`: The description of the request.
  - `address payable recipient`: The address to receive the funds if the request is approved.
  - `uint value`: The amount of Ether to be transferred.
  - `bool completed`: Whether the request has been completed.
  - `uint noOfVoters`: The number of contributors who have voted for the request.
  - `mapping(address => bool) voters`: Tracks which contributors have voted for the request.

### Modifiers

- `modifier onlyManager()`: Restricts access to certain functions to the manager only.

### Constructor

```solidity
constructor(uint _targetAmount, uint _deadLine, uint _minContribution) {
    manager = msg.sender;
    targetAmount = _targetAmount;
    deadLine = block.timestamp + _deadLine;
    minContribution = _minContribution;
}
```

Initializes the contract with the target amount, deadline, and minimum contribution, and sets the manager to the address that deploys the contract.

### Functions

#### `function sendEth() payable public`

Allows contributors to send Ether to the contract. Requires the contribution to be at least the minimum contribution and within the deadline.

```solidity
function sendEth() payable public {
    require(deadLine > block.timestamp, "Event deadline has passed");
    require(msg.value >= minContribution, "You cannot send less than the minimum contribution");
    if (contributors[msg.sender] == 0) {
        noOfContributors++;
    }
    contributors[msg.sender] += msg.value;
    raisedAmount += msg.value;
}
```

#### `function getBalance() public view returns (uint)`

Returns the current balance of the contract.

```solidity
function getBalance() public view returns (uint) {
    return address(this).balance;
}
```

#### `function refund() public`

Allows contributors to get a refund if the deadline has passed and the target amount was not raised.

```solidity
function refund() public {
    require(deadLine <= block.timestamp && raisedAmount < targetAmount, "Not eligible for refund");
    require(contributors[msg.sender] > 0, "Contribute first");
    address payable user = payable(msg.sender);
    user.transfer(contributors[msg.sender]);
    contributors[msg.sender] = 0;
}
```

#### `function createRequest(string memory _discription, address payable _recipient, uint _value) public onlyManager`

Allows the manager to create a spending request.

```solidity
function createRequest(string memory _discription, address payable _recipient, uint _value) public onlyManager {
    request storage newRequest = requests[noOfRequest];
    noOfRequest++;
    newRequest.discription = _discription;
    newRequest.recipient = _recipient;
    newRequest.value = _value;
    newRequest.completed = false;
    newRequest.noOfVoters = 0;
}
```

#### `function voteRequest(uint requestNo) public`

Allows contributors to vote on a spending request.

```solidity
function voteRequest(uint requestNo) public {
    require(contributors[msg.sender] > 0, "You are not a contributor, so you cannot vote");
    request storage thisRequest = requests[requestNo];
    require(thisRequest.voters[msg.sender] == false, "You have already voted");
    thisRequest.voters[msg.sender] = true;
    thisRequest.noOfVoters++;
}
```

#### `function makePayment(uint requestNo) public onlyManager`

Allows the manager to make a payment if the request is approved by more than half of the contributors.

```solidity
function makePayment(uint requestNo) public onlyManager {
    require(raisedAmount >= targetAmount, "Target amount not reached");
    request storage thisRequest = requests[requestNo];
    require(thisRequest.completed == false, "Request has already been completed");
    require(thisRequest.noOfVoters > noOfContributors / 2, "Not enough votes to approve the request");
    thisRequest.recipient.transfer(thisRequest.value);
    thisRequest.completed = true;
}
```

## Usage

1. **Deploy the Contract**: Deploy the contract to the Ethereum network using your preferred development environment.
2. **Contribute**: Contributors can send Ether to the contract to fund the project.
3. **Check Balance**: Anyone can check the balance of the contract by calling the `getBalance` function.
4. **Request Refund**: If the target amount is not reached by the deadline, contributors can request a refund.
5. **Create Spending Requests**: The manager can create requests to spend the raised funds.
6. **Vote on Requests**: Contributors can vote on the spending requests.
7. **Make Payments**: The manager can make payments for approved requests.

## Example

1. Deploy the contract with your Ethereum address. You become the manager.
2. Contributors send Ether to the contract to fund the project.
3. If the project reaches the target amount, the manager can create spending requests.
4. Contributors vote on the spending requests.
5. The manager can make payments for requests that receive more than half of the votes.
6. If the project does not reach the target amount by the deadline, contributors can request a refund.

## License

This project is licensed under the GPL-3.0 License.

---

Feel free to modify this README to better suit your project's needs or to provide additional details!