// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

contract DeedMultiPayout {
    address public lawyer;
    address payable public beneficiary;
    uint public earliest;
    uint public amount;
    uint constant public PAYOUTS = 10;  // Number of payments
    uint constant public INTERVAL = 10; // Interval between the different payouts (10 seconds for testing)
    uint public paidPayouts;

    constructor(
        address _lawyer,
        address payable _beneficiary,
        uint fromNow
    ) payable public {
        lawyer = _lawyer;
        beneficiary = _beneficiary;
        earliest = block.timestamp + fromNow;
        amount = msg.value / PAYOUTS;
    }

    function withdraw() public {
        require(msg.sender == beneficiary, 'beneficiary only');
        require(block.timestamp > earliest, 'too early');
        require(paidPayouts < PAYOUTS, 'no payouts left');

        uint eligiblePayouts = (block.timestamp - earliest) / INTERVAL;
        uint duePayouts = eligiblePayouts - paidPayouts;
        // In case the amount is withdrawn beyond the total number of intervals
        duePayouts = (duePayouts + paidPayouts > PAYOUTS) ? PAYOUTS - paidPayouts : duePayouts;
        paidPayouts += duePayouts;
        beneficiary.transfer(duePayouts * amount);
    }
}
