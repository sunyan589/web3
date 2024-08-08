// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Bank {
    // 状态变量
    address public immutable owner;
    // 事件
    event Deposit(address _ads, uint256 amount);
    event Withdraw(uint256 amount);
    // receive
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
    // 构造函数
    constructor() payable {
        owner = msg.sender;
    }

    // 仅合约 owner 可以调用
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    // 方法
    function withdraw() external {
        require(msg.sender == owner, "Not Owner");
        emit Withdraw(address(this).balance);
        selfdestruct(payable(msg.sender));
    }

    // 提取 ERC20 代币
    function withdrawERC20(address tokenAddress, uint256 amount) external onlyOwner {
        IERC20(tokenAddress).transfer(owner, amount);
    }

    // 提取 ERC721 代币
    function withdrawERC721(address tokenAddress, uint256 amount) external onlyOwner{
        IERC721(tokenAddress).transfer(owner, amount);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}