// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract VotingSystem {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public registeredVoters;
    address public electionAuthority;
    uint public candidateCount;

    constructor() {
        electionAuthority = msg.sender;
        candidateCount = 0;
    }

    modifier onlyElectionAuthority() {
        require(msg.sender == electionAuthority, "Only election authority can call this function");
        _;
    }

    function addCandidate(uint _id, string memory _name) external onlyElectionAuthority {
        candidateCount++;
        candidates[candidateCount] = Candidate(_id, _name, 0);
    }

    function registerVoter(address voterAddress) external onlyElectionAuthority {
        require(!registeredVoters[voterAddress], "Voter already registered");
        registeredVoters[voterAddress] = true;
    }

    function vote(uint _id) external {
        require(registeredVoters[msg.sender], "You are not registered");
        require(_id > 0 && _id <= candidateCount, "Invalid candidate ID");
        candidates[_id].voteCount++;
        registeredVoters[msg.sender] = false;
    }

    function getNumberOfCandidates() public view returns (uint) {
        return candidateCount;
    }

    function getResult() public view returns (uint[] memory) {
        uint[] memory results = new uint[](candidateCount);
        for (uint i = 1; i <= candidateCount; i++) {
            results[i - 1] = candidates[i].voteCount;
        }
        return results;
    }
}
