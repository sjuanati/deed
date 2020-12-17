// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract Deed {
    address public lawyer;
    address payable public beneficiary;
    uint public earliest;

    constructor(
        address _lawyer,
        address payable _beneficiary,
        uint fromNow
    ) payable public {
        lawyer = _lawyer;
        beneficiary = _beneficiary;
        earliest = block.timestamp + fromNow;
    }

    function withdraw() public {
        require(msg.sender == lawyer, 'lawyer only');
        require(block.timestamp > earliest, 'too early');
        beneficiary.transfer(address(this).balance);
    }
}
