// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "./safemath.sol";
import "./VotingInterface.sol";

contract CoachVotingMechanism {

    address public VotingMechanismAddress;

    constructor(address _VotingMechanismAddress) {
        VotingMechanismAddress = _VotingMechanismAddress;
    }

    using SafeMath for uint;

    uint totalVotes;
    uint totalMVCs;

    // struct of proposals and corresponding votes
    struct ProposalAndVotes {
        VotingInterface.Proposal proposal;
        uint numOfVotes;
        address[] voterAddresses;
    }

    // an array of the ProposalAndVotes objects
    ProposalAndVotes[] public coachingCandidates;

    // an array of names making it easier to verify and show to voters - abstracting away owner and vote count, voter will just see the candidate names
    string[] public candidateNames;

    // events verifying that proposals and votes were received
    event CoachProposalReceived(address sender, VotingInterface.Proposal proposal, uint ethAmount);
    event CoachVoteReceived(address sender, VotingInterface.CoachVote vote);

    // gets coaching candidates for voters to see
    function getCoachingCandidates() external view returns (string[] memory) {
        return candidateNames;
    }

    // checking that address of sender is valid
    // adds proposal to array of coachingCandidates - initializes number of votes to 0
    // adds name of candidate to candidateNames
    // emitting event that proposal was received
    function receiveCoachProposal(VotingInterface.Proposal memory proposal, uint ethAmount) external payable {
        require(proposal.ownerAddress == msg.sender);

        address[] memory beginVoterAddresses;
        coachingCandidates.push(ProposalAndVotes(proposal,0,beginVoterAddresses));
        candidateNames.push(proposal.candidate);

        totalVotes = totalVotes.add(1);
        totalMVCs = totalMVCs.add(4);

        emit CoachProposalReceived(msg.sender, proposal, ethAmount);
    }

    // checking that address of sender is valid
    // checking that type of vote is 'coach'
    // check that the voter's choice is valid
    // incrementing the number of votes for the coach candidate
    // emitting event that vote was received
    function receiveCoachVote(VotingInterface.CoachVote memory coachVote) external payable {
        require(coachVote.ownerAddress == msg.sender);
        require(keccak256(abi.encodePacked(coachVote.proposalType)) == keccak256(abi.encodePacked('coach')));
        require(verifyVote(coachVote.candidate));

        string memory voteCandidate = coachVote.candidate; // name of the candidate person voted for

        for (uint i=0; i<coachingCandidates.length; i++){
            if (keccak256(abi.encodePacked(coachingCandidates[i].proposal.candidate)) == keccak256(abi.encodePacked(voteCandidate))){
                coachingCandidates[i].numOfVotes = coachingCandidates[i].numOfVotes.add(1);
                coachingCandidates[i].voterAddresses.push(coachVote.ownerAddress);
                break;
            }
        }

        totalVotes = totalVotes.add(1);

        emit CoachVoteReceived(msg.sender, coachVote);
    }

    // verify that the voter's choice exists in the candidateNames array
    function verifyVote(string memory _voterChoice) private view returns (bool) {
        bool choiceExists = false;

        for (uint i=0; i<candidateNames.length; i++){
            if (keccak256(abi.encodePacked(_voterChoice)) == keccak256(abi.encodePacked(candidateNames[i]))){
                choiceExists = true;
                break;
            }
        }

        return choiceExists;
    }

    // takes the coachingCandidate array and sorts it so that the candidates with the top 5 votes are returned ("The Podium")
    // returning array has proposal with most votes at the beginning and fifth most votes at the end
    function tallyCoachVotes() private returns (ProposalAndVotes[] memory) {

        uint len = coachingCandidates.length;

        for (uint i=0; i<len-1; i++){
            for (uint j=0; j<len-i-1; j++){
                if (coachingCandidates[j].numOfVotes < coachingCandidates[j+1].numOfVotes){
                    ProposalAndVotes memory temp = coachingCandidates[j];
                    coachingCandidates[j] = coachingCandidates[j+1];
                    coachingCandidates[j+1] = temp;
                }
            }
        }

        ProposalAndVotes[] memory topFive = new ProposalAndVotes[](5);

        for (uint i=0; i<5; i++){
            if (i < len){
                topFive[i] = coachingCandidates[i];
            }
        }

        return topFive;
    }

    // distributes the totalMVC in the order specified in the README
    // 1 MVC = 0.1 eth
    // function distributeMVCSafterVote(ProposalAndVotes[] memory topFive) private {
    //     for (uint i=0; i<topFive.length; i++){
    //         for (uint j=0; j<topFive[i].voterAddresses.length; j++){
    //             sendMVC(topFive[i].voterAddresses[j], VotingMechanismAddress, 0.1);
    //         }
    //     }
    // }

    function sendMVC(address payable _to, address _from, uint amount) public payable {
        require(msg.sender == _from, "Only the specified sender can call this function");
        require(address(this).balance >= amount, "Insufficient balance in the contract");

        _to.transfer(amount);
    }
    
}