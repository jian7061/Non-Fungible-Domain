// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import { StringUtils } from "./libraries/StringUtils.sol";
import 'hardhat/console.sol';

contract Domains {
    string public tld;

    mapping(string=>address) public domains;
    mapping(string=>string) public records;

    constructor(string memory _tld)payable{
        tld=_tld;
        console.log('%s name service deployed', _tld);
    }

    //This function will give us the price of a domain based on length
    function price(string calldata name)public pure returns(uint) {
        uint len = StringUtils.strlen(name);
        require(len>0);
        //Shorter domain are more expensive
        if(len==3){
            return 5 * 10**16; //0.05 MATIC
        }else if(len==4){
            return 3 * 10**16; //0.03 MATIC
        }else{
            return 1 * 10**16; //0.01 MATIC
        }
    }

    function register(string calldata name) public payable{
        //check that the name is unregistered
        require(domains[name]==address(0));

        uint _price =price(name);

        //Check if enough Matic was paid in the transaction
        require(msg.value >= _price,"Not enough Matic paid");

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