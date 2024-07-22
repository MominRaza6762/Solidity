--VotingSystem Smart Contract

This project is a decentralized voting system built on the Ethereum blockchain using Solidity. The smart contract allows for the registration of candidates and voters, voting, and tallying of votes in a transparent and secure manner.

## Features

- **Candidate Registration**: Only the election authority can register candidates.
- **Voter Registration**: Only the election authority can register voters.
- **Voting**: Registered voters can vote for their preferred candidates.
- **Result Tallying**: Anyone can view the voting results to see the vote count for each candidate.

## Prerequisites

- Solidity compiler version 0.8.2 or higher
- Ethereum wallet with some Ether to deploy and interact with the contract
- Development environment like Remix, Truffle, or Hardhat for compiling and deploying the contract

## Contract Details

### State Variables

- `address public electionAuthority`: The address of the election authority.
- `mapping(uint => Candidate) public candidates`: A mapping of candidate IDs to candidate details.
- `mapping(address => bool) public registeredVoters`: A mapping to track registered voters.
- `uint public candidateCount`: The total number of registered candidates.

### Structs

#### `Candidate`
- `uint id`: The ID of the candidate.
- `string name`: The name of the candidate.
- `uint voteCount`: The number of votes the candidate has received.

### Constructor

The constructor sets the `electionAuthority` to the address that deploys the contract and initializes the `candidateCount`.

```solidity
constructor() {
    electionAuthority = msg.sender;
    candidateCount = 0;
}
```

### Modifiers

#### `onlyElectionAuthority`
Ensures that only the election authority can call certain functions.

```solidity
modifier onlyElectionAuthority() {
    require(msg.sender == electionAuthority, "Only election authority can call this function");
    _;
}
```

### Functions

#### `addCandidate`
Allows the election authority to add a new candidate.

```solidity
function addCandidate(uint _id, string memory _name) external onlyElectionAuthority {
    candidateCount++;
    candidates[candidateCount] = Candidate(_id, _name, 0);
}
```

#### `registerVoter`
Allows the election authority to register a voter.

```solidity
function registerVoter(address voterAddress) external onlyElectionAuthority {
    require(!registeredVoters[voterAddress], "Voter already registered");
    registeredVoters[voterAddress] = true;
}
```

#### `vote`
Allows registered voters to vote for a candidate. After voting, the voter is marked as having voted to prevent double voting.

```solidity
function vote(uint _id) external {
    require(registeredVoters[msg.sender], "You are not registered");
    require(_id > 0 && _id <= candidateCount, "Invalid candidate ID");
    candidates[_id].voteCount++;
    registeredVoters[msg.sender] = false;
}
```

#### `getNumberOfCandidates`
Returns the total number of candidates.

```solidity
function getNumberOfCandidates() public view returns (uint) {
    return candidateCount;
}
```

#### `getResult`
Returns an array of vote counts for all candidates.

```solidity
function getResult() public view returns (uint[] memory) {
    uint[] memory results = new uint[](candidateCount);
    for (uint i = 1; i <= candidateCount; i++) {
        results[i - 1] = candidates[i].voteCount;
    }
    return results;
}
```

## Usage

1. **Deploy the Contract**: Deploy the contract to the Ethereum network using your preferred development environment.
2. **Add Candidates**: The election authority can add candidates by calling the `addCandidate` function.
3. **Register Voters**: The election authority can register voters by calling the `registerVoter` function.
4. **Vote**: Registered voters can vote for their preferred candidates by calling the `vote` function.
5. **View Results**: Anyone can view the voting results by calling the `getResult` function.

## Example

1. Deploy the contract with your Ethereum address. You become the election authority.
2. Add candidates using the `addCandidate` function.
3. Register voters using the `registerVoter` function.
4. Voters vote for candidates using the `vote` function.
5. View the results using the `getResult` function.

## License

This project is licensed under the GPL-3.0 License.

---
