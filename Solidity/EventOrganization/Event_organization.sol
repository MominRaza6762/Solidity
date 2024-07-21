// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract EventOrganization {
    struct Event {
        address organizer;
        string name;
        uint date;
        uint price;
        uint totalTickets;
        uint remainTickets;
    }

    mapping(uint => Event) public events;
    mapping(address => mapping(uint => uint)) public tickets;
    uint public nextId;

    function createEvent(string memory name, uint date, uint price, uint totalTickets) external {
        require(date > block.timestamp, "Create event for a future date");
        require(totalTickets >= 2, "Create event for more than 2 people");
        
        events[nextId] = Event(msg.sender, name, date, price, totalTickets, totalTickets);
        nextId++;
    }

    function buyTickets(uint id, uint quantity) external payable {
        require(events[id].date != 0, "Event does not exist");
        require(events[id].date > block.timestamp, "Event already occurred");
        require(msg.value == events[id].price * quantity, "Ether is not enough");
        require(events[id].remainTickets >= quantity, "Not enough remaining tickets");

        events[id].remainTickets -= quantity;
        tickets[msg.sender][id] += quantity;
    }

    function transferTicket(uint id, uint quantity, address to) external {
        require(events[id].date != 0, "Event does not exist");
        require(events[id].date > block.timestamp, "Event already occurred");
        require(tickets[msg.sender][id] >= quantity, "Not enough tickets");

        tickets[msg.sender][id] -= quantity;
        tickets[to][id] += quantity;
    }
}
