// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "./safemath.sol";
import "./ProposalInterface.sol";

contract VotingMechanism {

    using SafeMath for uint;

    // array of voting periods ["coach", "draft", ...]
    // map of proposals for the voting period (owner address, proposal)

    // the key of the headCoachVote map
    struct OwnerAndVotes {
        address owner;
        uint numOfVotes;
    }

    struct CoachProposal {
        address ownerAddress;
        string proposalType; // coach
        string candidate; // coach's name
    }

    struct CoachVote {
        address ownerAddress;
        string proposalType; // coach
        string candidate; // coach's name
    }

    // a map of the head coach candidates being voted on, the number of votes, and the associated owner of the proposal
    mapping (string => OwnerAndVotes) public coachVoteCandidates;

    event CoachProposalReceived(address sender, ProposalInterface.Proposal proposal);

    function receiveCoachProposal(ProposalInterface.Proposal memory proposal) external payable {
        require(proposal.ownerAddress == msg.sender);
        coachVoteCandidates[proposal.candidate] = OwnerAndVotes(proposal.ownerAddress,0);

        emit CoachProposalReceived(msg.sender, proposal);
    }

    event CoachVoteReceived(address sender, CoachVote vote);

    function increaseCoachVote(CoachVote memory coachVote) private {
        require(coachVote.ownerAddress == msg.sender);
        OwnerAndVotes memory tempStruct = coachVoteCandidates[coachVote.candidate];
        tempStruct.numOfVotes = tempStruct.numOfVotes.add(1);

        emit CoachVoteReceived(msg.sender, coachVote);
    }
    
}