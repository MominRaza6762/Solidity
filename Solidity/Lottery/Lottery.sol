// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.8.2 <0.9.0;

contract lottery
{
    address public  manager;
    address payable[] participnts;
    constructor()
    {
        manager=msg.sender;       
    }
    receive() payable external
    {
        require(msg.value==1 ether);
        participnts.push(payable(msg.sender));
    }
    function get_Belence() view public returns(uint)
    {
        require(msg.sender==manager);
        return address(this).balance;
    }
    function random() public view  returns(uint) 
    {
        return uint(keccak256(abi.encode(block.difficulty,block.timestamp,participnts.length)));

    }
    function s_winner() public 
    {
        require(msg.sender==manager);
        require(participnts.length>=3);
        uint r=random();
        uint index= r%participnts.length;
        address payable winner=participnts[index];
        winner.transfer(get_Belence());
        participnts=new address payable[](0);

    }
    
}