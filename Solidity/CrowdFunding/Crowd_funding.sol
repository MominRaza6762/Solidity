// SPDX-License-Identifier: GPL-3.0
pragma solidity >= 0.8.2 <0.9.0;
contract CrowdFunding
{
    mapping(address=>uint) public  contributors;
    address manager;
    uint minContribution;
    uint deadLine;
    uint targetAmount;
    uint raisedAmount;
    uint noOfContributors;

    struct request{
        string discription;
        address payable  recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping (address=>bool) voters;
    }
    mapping (uint=>request) public requests;
    uint noOfRequest;
    modifier onlyManager()
    {
        require(msg.sender==manager);
        _;
    }

    constructor(uint _targetAmount,uint _deadLine,uint _minContribution)
    {
        manager=msg.sender;
        targetAmount=_targetAmount;
        deadLine=block.timestamp+_deadLine;
        minContribution=_minContribution;

    }

    function sendEth() payable public 
    {
        require(deadLine>block.timestamp,"event deadline is passed");
        require(msg.value>=minContribution,"you cant send less than minimum contribution");
        if(contributors[msg.sender]==0)
        {
            noOfContributors++;
        }

        contributors[msg.sender]+=msg.value;
        raisedAmount+=msg.value;
         
            }

        function getBalance() public view  returns (uint)
        {
            return address(this).balance;
        }
        function refund() public
        {
            require(deadLine<=block.timestamp && raisedAmount<targetAmount,"not eligable for refund");
            require(contributors[msg.sender]>0,"contribute first");
            address payable user=payable (msg.sender);
            user.transfer(contributors[msg.sender]);
            contributors[msg.sender]=0;

        } 

        function createRequest(string memory _discription,address payable  _recipient,uint _value) public onlyManager
        {
            request storage newRequest=requests[noOfRequest];
            noOfRequest++;
            newRequest.discription=_discription;
            newRequest.recipient=_recipient;
            newRequest.value=_value;
            newRequest.completed=false;
            newRequest.noOfVoters=0;
        }

        function voteRequest(uint requestNo) public 
        {
            require(contributors[msg.sender]>0,"you are not a contributor so you cant vote");
            request storage thisRequest= requests[requestNo];
            require(thisRequest.voters[msg.sender]==false,"you already voted");
            thisRequest.voters[msg.sender]=true;
            thisRequest.noOfVoters++;
        }
        function makePayment(uint requestNo)  public onlyManager
        {
            require(raisedAmount>=targetAmount);
            request storage thisRequest=requests[requestNo];
            require(thisRequest.completed==false,"request has already completed");
            require(thisRequest.noOfVoters > noOfContributors/2);
            thisRequest.recipient.transfer(thisRequest.value);
            thisRequest.completed=true;

        }





}