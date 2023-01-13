// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TrustfulOracle.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";


contract Source is AccessControlEnumerable {

    bytes32 public constant TRUSTED_SOURCE_ROLE = keccak256("TRUSTED_SOURCE_ROLE");
    TrustfulOracle public oracle;

    constructor(address _oracleAddress) {
        oracle = TrustfulOracle(_oracleAddress);
    }

    // function registrate(address _sourceAddress) public {
    //     _setupRole(TRUSTED_SOURCE_ROLE, _sourceAddress);
    // }

    function setPrice(uint _price) public {
        oracle.postPrice("DVNFT", _price);
    }
}    