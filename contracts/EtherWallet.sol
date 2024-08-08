// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EtherWallet {
    address payable public immutable owner;
    event Log(string funName, address from, uint256 value, bytes data);

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }

    // 仅合约 owner 可以调用
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function withdraw1() external onlyOwner{
        // owner.transfer 相比 msg.sender 更消耗Gas
        // owner.transfer(address(this).balance);
        payable(msg.sender).transfer(100);
    }

    function withdraw2() external onlyOwner{
        bool success = payable(msg.sender).send(200);
        require(success, "Send Failed");
    }

    function withdraw3() external onlyOwner{
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Call Failed");
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}