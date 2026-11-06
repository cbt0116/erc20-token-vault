// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract TokenVault {
    IERC20 public immutable asset;
    mapping(address => uint256) public balances;
    uint256 private entered = 1;

    modifier nonReentrant() {
        require(entered == 1, "reentrant call");
        entered = 2;
        _;
        entered = 1;
    }

    event Deposited(address indexed account, uint256 amount);
    event Withdrawn(address indexed account, uint256 amount);

    error ZeroAmount();
    error TransferFailed();
    error InsufficientBalance();

    constructor(address asset_) {
        require(asset_ != address(0), "zero asset");
        asset = IERC20(asset_);
    }

    function deposit(uint256 amount) external nonReentrant {
        if (amount == 0) revert ZeroAmount();
        if (!asset.transferFrom(msg.sender, address(this), amount)) revert TransferFailed();
        balances[msg.sender] += amount;
        emit Deposited(msg.sender, amount);
    }

    function withdraw(uint256 amount) external nonReentrant {
        if (amount == 0) revert ZeroAmount();
        uint256 current = balances[msg.sender];
        if (current < amount) revert InsufficientBalance();
        balances[msg.sender] = current - amount;
        if (!asset.transfer(msg.sender, amount)) revert TransferFailed();
        emit Withdrawn(msg.sender, amount);
    }
}
