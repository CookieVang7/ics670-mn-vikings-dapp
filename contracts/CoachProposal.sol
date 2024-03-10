// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "./CoachVotingMechanism.sol";
import "./VotingInterface.sol";

contract CoachProposal {

    address public VotingMechanismAddress;

    constructor(address _VotingMechanismAddress) {
        addAvailableCoach("Bill Belichick", false);
        addAvailableCoach("Frank Reich", false);
        addAvailableCoach("Josh McDaniels", false);
        addAvailableCoach("Brandon Staley", false);
        addAvailableCoach("Mike Vrabel", false);

        VotingMechanismAddress = _VotingMechanismAddress;
    }

    struct Coach {
        string name;
        bool hired;
    }

    // array of head coach candidates
    Coach[] public availableCoaches;

    function addAvailableCoach(string memory _name, bool _hired) private {
        availableCoaches.push(Coach(_name,_hired));
    }

    function removeCoach(string memory _name) private {
        uint index;
        for (uint i = 0; i < availableCoaches.length; i++) {
            if (keccak256(abi.encodePacked(availableCoaches[i].name)) == keccak256(abi.encodePacked(_name))) {
                index = i;
                break;
            }
        }
        
        require(index < availableCoaches.length, "Index out of bounds");

        availableCoaches[index] = availableCoaches[availableCoaches.length - 1];
        availableCoaches.pop();
    }

    // a user wanting to make a proposal would have to see who the available choices are
    function getAvailableCoaches() external view returns (Coach[] memory) {
        return availableCoaches;
    }

    VotingInterface.Proposal public proposal; // using shared proposal struct in interface so both contracts can see it
    uint proposalFee = 0.4 ether; // costs 4 MVCs to submit a proposal
    event CoachProposalSent(address sender, VotingInterface.Proposal proposal);

    // sends a CoachProposal to the VotingMechanism
    // costs 4 MVC coins to execute (0.4 ether)
    function sendCoachProposal(Coach memory candidate) external payable {
        require(isCoachAvailable(candidate.name), "Coach is not available to hire");
        require(msg.value == proposalFee);

        removeCoach(candidate.name);

        proposal.ownerAddress = msg.sender;
        proposal.proposalType = "coach";
        proposal.candidate = "Mike Vrabel";

        CoachVotingMechanism(VotingMechanismAddress).receiveCoachProposal{value:msg.value}(proposal, msg.value);

        emit CoachProposalSent(msg.sender, proposal);
    }

    function isCoachAvailable(string memory _name) private view returns (bool) {
        for (uint i = 0; i < availableCoaches.length; i++) {
            if (keccak256(abi.encodePacked(availableCoaches[i].name)) == keccak256(abi.encodePacked(_name))) {
                return true;
            }
        }
        return false;
    }
}