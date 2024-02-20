// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

interface VotingInterface {
    struct Proposal {
        address ownerAddress; //proposer's address
        string proposalType;
        string candidate;
    }

    struct CoachVote {
        address ownerAddress; //voter's address
        string proposalType;
        string candidate;
    }
}