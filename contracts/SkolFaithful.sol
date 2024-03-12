// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "./RepSystemInterface.sol";

contract SkolFaithful {
    struct Member {
        address owner;
        uint mvcs;
        uint repTokens;
    }

    Member[] public skolFaithful;

    function getMembers() external view returns (Member[] memory){
        return skolFaithful;
    }

    event MemberAdded(address sender, Member member);
    function addMember(address _owner) private {
        Member memory fan = Member(_owner,4,0);
        skolFaithful.push(fan);
        emit MemberAdded(_owner,fan);
    }

    function getMemberAtIndex(uint _index) external view returns (Member memory) {
        require(_index < skolFaithful.length, "Index out of bounds");
        return skolFaithful[_index];
    }

    event RepTokensAwarded(address indexed memberAddress, uint tokens);

    function updateRepTokens(uint _index, uint _additionalTokens) external {
        require(_index < skolFaithful.length, "Index out of bounds");
        skolFaithful[_index].repTokens += _additionalTokens; // Add the additional tokens to the existing repTokens
    }

    function triggerAwardRepTokens(address _repSystemCallAddress, address _memberAddress, uint _repTokenAmount) external {
        RepSystemInterface(_repSystemCallAddress).awardRepTokens(_memberAddress, _repTokenAmount);
    }
}