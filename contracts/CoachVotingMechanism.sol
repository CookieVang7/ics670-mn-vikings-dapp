// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "./safemath.sol";
import "./VotingInterface.sol";

contract CoachVotingMechanism {

    using SafeMath for uint;

    uint totalVotes;

    // the key of the headCoachVote map
    struct OwnerAndVotes {
        address owner;
        uint numOfVotes;
    }

    // a map of the head coach candidates being voted on, the number of votes, and the associated owner of the proposal
    // key: string of coach name
    // value: OwnerAndVotes struct
    mapping (string => OwnerAndVotes) public coachVoteCandidates;

    event CoachProposalReceived(address sender, VotingInterface.Proposal proposal);
    event CoachVoteReceived(address sender, VotingInterface.CoachVote vote);

    // checking that address of sender is valid
    // creates candidate in coach map like so
    // key = Bill Belichick, value = {owner = 123, numOfVotes = 0}
    // emitting event that vote was received
    function receiveCoachProposal(VotingInterface.Proposal memory proposal) external payable {
        require(proposal.ownerAddress == msg.sender);
        coachVoteCandidates[proposal.candidate] = OwnerAndVotes(proposal.ownerAddress,0);

        emit CoachProposalReceived(msg.sender, proposal);
    }

    // checking that address of sender is valid
    // checking that type of vote is 'coach'
    // incrementing the vote for the coach candidate
    // emitting event that vote was received
    function receiveCoachVote(VotingInterface.CoachVote memory coachVote) private {
        require(coachVote.ownerAddress == msg.sender);
        require(keccak256(abi.encodePacked(coachVote.proposalType)) == keccak256(abi.encodePacked('coach')));

        OwnerAndVotes memory tempStruct = coachVoteCandidates[coachVote.candidate];
        tempStruct.numOfVotes = tempStruct.numOfVotes.add(1);

        totalVotes = totalVotes.add(1);

        emit CoachVoteReceived(msg.sender, coachVote);
    }
    
}