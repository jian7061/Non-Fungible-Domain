// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

import 'hardhat/console.sol';

contract Domains {
    mapping(string=>address) public domains;
    mapping(string=>string) public records;

    constructor(){
        console.log('I am a contract');
    }

    function register(string calldata name) public {
        //check that the name is unregistered
        require(domains[name]==address(0));
        domains[name] =msg.sender;
        console.log('%s has registered a domain',msg.sender);
    }

    function getAddress(string calldata name) public view returns(address) {
        return domains[name];
    }

    function setRecord(string calldata name, string calldata record)public{
        //check that the owner is the transaction sender
        require(domains[name]==msg.sender);
        records[name] = record;
    }

    function getRecords(string calldata name)public view returns(string memory){
        return records[name];
    }
}