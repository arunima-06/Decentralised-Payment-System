// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Decentralised Payment System
 * @dev Simple peer-to-peer payment system
 */
contract Project {
    
    // Owner of the contract
    address public owner;
    
    // Track user balances
    mapping(address => uint256) public balances;
    
    // Events
    event PaymentSent(address indexed from, address indexed to, uint256 amount);
    event PaymentReceived(address indexed user, uint256 amount);
    event Withdrawal(address indexed user, uint256 amount);
    
    constructor() {
        owner = msg.sender;
    }
    
    /**
     * @dev Function 1: Send payment to another user
     * @param _to Address of the recipient
     */
    function sendPayment(address _to) external payable {
        require(_to != address(0), "Invalid address");
        require(msg.value > 0, "Amount must be greater than 0");
        
        balances[_to] += msg.value;
        
        emit PaymentSent(msg.sender, _to, msg.value);
        emit PaymentReceived(_to, msg.value);
    }
    
    /**
     * @dev Function 2: Check balance of any user
     * @param _user Address to check balance
     * @return balance The balance of the user
     */
    function checkBalance(address _user) external view returns (uint256) {
        return balances[_user];
    }
    
    /**
     * @dev Function 3: Withdraw your balance
     */
    function withdraw() external {
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No balance to withdraw");
        
        balances[msg.sender] = 0;
        
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Withdrawal failed");
        
        emit Withdrawal(msg.sender, amount);
    }
    
    // Get contract balance
    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
