// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

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
}