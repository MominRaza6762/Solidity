--EventOrganization Smart Contract

This project is a smart contract for organizing events, written in Solidity. It allows organizers to create events and users to buy and transfer tickets. This smart contract is designed to ensure a decentralized and secure way of handling event ticketing.

## Features

- **Event Creation**: Organizers can create events with specific details.
- **Ticket Purchase**: Users can purchase tickets for events.
- **Ticket Transfer**: Users can transfer their tickets to other users before the event occurs.

## Prerequisites

- Solidity compiler version 0.8.2 or higher
- Ethereum wallet with some Ether to deploy and interact with the contract
- Development environment like Remix, Truffle, or Hardhat for compiling and deploying the contract

## Contract Details

### State Variables

- `struct Event`: Represents an event.
  - `address organizer`: The address of the event organizer.
  - `string name`: The name of the event.
  - `uint date`: The date of the event (timestamp).
  - `uint price`: The price of one ticket (in Wei).
  - `uint totalTickets`: The total number of tickets for the event.
  - `uint remainTickets`: The number of remaining tickets for the event.
- `mapping(uint => Event) public events`: Stores the events by their ID.
- `mapping(address => mapping(uint => uint)) public tickets`: Stores the number of tickets each address has for each event.
- `uint public nextId`: The ID for the next event to be created.

### Functions

#### `function createEvent(string memory name, uint date, uint price, uint totalTickets) external`

Allows the organizer to create a new event.

```solidity
function createEvent(string memory name, uint date, uint price, uint totalTickets) external {
    require(date > block.timestamp, "Create event for a future date");
    require(totalTickets >= 2, "Create event for more than 2 people");
    
    events[nextId] = Event(msg.sender, name, date, price, totalTickets, totalTickets);
    nextId++;
}
```

#### `function buyTickets(uint id, uint quantity) external payable`

Allows users to buy tickets for an event.

```solidity
function buyTickets(uint id, uint quantity) external payable {
    require(events[id].date != 0, "Event does not exist");
    require(events[id].date > block.timestamp, "Event already occurred");
    require(msg.value == events[id].price * quantity, "Ether is not enough");
    require(events[id].remainTickets >= quantity, "Not enough remaining tickets");

    events[id].remainTickets -= quantity;
    tickets[msg.sender][id] += quantity;
}
```

#### `function transferTicket(uint id, uint quantity, address to) external`

Allows users to transfer their tickets to another address before the event occurs.

```solidity
function transferTicket(uint id, uint quantity, address to) external {
    require(events[id].date != 0, "Event does not exist");
    require(events[id].date > block.timestamp, "Event already occurred");
    require(tickets[msg.sender][id] >= quantity, "Not enough tickets");

    tickets[msg.sender][id] -= quantity;
    tickets[to][id] += quantity;
}
```

## Usage

1. **Deploy the Contract**: Deploy the contract to the Ethereum network using your preferred development environment.
2. **Create Event**: Organizers can create events by specifying the event name, date, ticket price, and total number of tickets.
3. **Buy Tickets**: Users can buy tickets for events by specifying the event ID and the number of tickets, and sending the correct amount of Ether.
4. **Transfer Tickets**: Users can transfer their tickets to another address before the event occurs.

## Example

1. Deploy the contract with your Ethereum address. You become the manager.
2. Create an event by calling the `createEvent` function with appropriate details.
3. Buy tickets for the event by calling the `buyTickets` function and sending the correct amount of Ether.
4. Transfer tickets to another user by calling the `transferTicket` function.

## License

This project is licensed under the GPL-3.0 License.

---

Feel free to modify this README to better suit your project's needs or to provide additional details!