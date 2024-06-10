// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract ClassRepresentativeVoting {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        bool registered;
        bool voted;
        uint vote;
    }

    address public admin;
    uint public candidateCount = 0;
    uint public voterCount = 0;

    mapping(uint => Candidate) public candidates;
    mapping(address => Voter) public voters;

    event CandidateRegistered(uint id, string name);
    event VoteCast(address voter, uint candidateId);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function registerCandidate(string memory name) public onlyAdmin {
        candidateCount++;
        candidates[candidateCount] = Candidate(candidateCount, name, 0);
        emit CandidateRegistered(candidateCount, name);
    }

    function registerVoter(address voter) public onlyAdmin {
        require(!voters[voter].registered, "Voter is already registered");
        voters[voter] = Voter(true, false, 0);
        voterCount++;
    }

    function vote(uint candidateId) public {
        require(voters[msg.sender].registered, "Not a registered voter");
        require(!voters[msg.sender].voted, "Already voted");
        require(candidates[candidateId].id == candidateId, "Candidate not found");

        voters[msg.sender].voted = true;
        voters[msg.sender].vote = candidateId;
        candidates[candidateId].voteCount++;

        emit VoteCast(msg.sender, candidateId);
    }

    function getCandidate(uint id) public view returns (Candidate memory) {
        return candidates[id];
    }

    function getVoter(address voter) public view returns (Voter memory) {
        return voters[voter];
    }

    function getResults() public view returns (Candidate[] memory) {
        Candidate[] memory results = new Candidate[](candidateCount);
        for (uint i = 1; i <= candidateCount; i++) {
            results[i-1] = candidates[i];
        }
        return results;
    }
}
