// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract PolygonDAO is Ownable {
    struct Member {
        address addr;
        bool approved;
    }

    struct Proposal {
        string description;
        uint yesVotes;
        uint noVotes;
        bool closed;
        address[] voters;
    }

    Member[] public members;
    Proposal[] public proposals;

    // Events
    event NewMember(address indexed member);
    event ProposalCreated(uint indexed proposalId);
    event Voted(uint indexed proposalId, address indexed voter, bool vote);
    event ProposalClosed(uint indexed proposalId, bool passed);

    // Apply to join the DAO
    function applyForMembership() external {
        members.push(Member(msg.sender, false));
        emit NewMember(msg.sender);
    }

    // Approve a member
    function approveMembership(address memberAddress) external onlyOwner {
        for (uint i = 0; i < members.length; i++) {
            if (members[i].addr == memberAddress) {
                members[i].approved = true;
                break;
            }
        }
    }

    // Create a proposal
    function createProposal(string calldata description) external {
        require(
            isMember(msg.sender),
            "You must be a member to create a proposal."
        );
        proposals.push(Proposal(description, 0, 0, false, new address[](0)));
        uint proposalId = proposals.length - 1;
        emit ProposalCreated(proposalId);
    }

    // Vote on a proposal
    function vote(uint proposalId, bool voteYes) external {
        require(isMember(msg.sender), "You must be a member to vote.");
        require(
            !proposals[proposalId].closed,
            "Voting is closed for this proposal."
        );
        for (uint i = 0; i < proposals[proposalId].voters.length; i++) {
            require(
                proposals[proposalId].voters[i] != msg.sender,
                "You have already voted."
            );
        }
        if (voteYes) {
            proposals[proposalId].yesVotes++;
        } else {
            proposals[proposalId].noVotes++;
        }
        proposals[proposalId].voters.push(msg.sender);
        emit Voted(proposalId, msg.sender, voteYes);
    }

    // Close a proposal and declare the result
    function closeProposal(uint proposalId) external onlyOwner {
        require(
            !proposals[proposalId].closed,
            "This proposal is already closed."
        );
        proposals[proposalId].closed = true;
        bool passed = proposals[proposalId].yesVotes >
            proposals[proposalId].noVotes;
        emit ProposalClosed(proposalId, passed);
    }

    // Check if an address is a member
    function isMember(address addr) public view returns (bool) {
        for (uint i = 0; i < members.length; i++) {
            if (members[i].addr == addr && members[i].approved) {
                return true;
            }
        }
        return false;
    }
}
