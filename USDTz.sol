// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract USDTz {
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowance;
    uint public totalSupply;
    string public name = "USDT.z";
    string public symbol = "USDT.z";
    uint8 public decimals = 18;

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);

    constructor() {
        totalSupply = 15000000 * 10 ** uint(decimals); // 15 Million tokens
        balances[msg.sender] = totalSupply;
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function balanceOf(address owner) public view returns (uint) {
        return balances[owner];
    }

    function transfer(address to, uint value) public returns (bool) {
        require(balanceOf(msg.sender) >= value, "balance too low");

        balances[msg.sender] -= value;
        if (to == address(this)) {
            // Auto-burn logic: tokens sent to contract are burned
            totalSupply -= value;
            emit Transfer(msg.sender, address(0), value);
        } else {
            balances[to] += value;
            emit Transfer(msg.sender, to, value);
        }
        return true;
    }

    function transferFrom(address from, address to, uint value) public returns (bool) {
        require(balanceOf(from) >= value, "balance too low");
        require(allowance[from][msg.sender] >= value, "allowance too low");

        balances[from] -= value;
        allowance[from][msg.sender] -= value;

        if (to == address(this)) {
            // Auto-burn logic
            totalSupply -= value;
            emit Transfer(from, address(0), value);
        } else {
            balances[to] += value;
            emit Transfer(from, to, value);
        }
        return true;
    }

    function approve(address spender, uint value) public returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
}
