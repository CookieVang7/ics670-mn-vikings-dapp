// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

interface RepSystemInterface {
    function awardRepTokens(address _memberAddress, uint _tokens) external;
}