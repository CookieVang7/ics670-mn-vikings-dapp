// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.22;

interface ProposalInterface {
    struct Proposal {
        address ownerAddress;
        string proposalType;
        string candidate;
    }
}