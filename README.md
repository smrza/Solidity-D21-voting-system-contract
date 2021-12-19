# Solidity-D21-voting-system-contract
Blockchain seminar semestral task

## Assignment:

### Tutorial objectives
Create a basic skeleton for the final exercise, which is the voting system smart contract with rules of "Janečkova metoda
D21".

### Tutorial pre-requisites
- Solidity enabled IDE of your choice.
  - Remix - All in one, easy to use (https://github.com/ethereum/remix-desktop/releases)
  - VSCode - Advanced (https://code.visualstudio.com/)
    - Solidity Extension (https://marketplace.visualstudio.com/items?itemName=JuanBlanco.solidity)
    - Truffle (https://www.trufflesuite.com/truffle)
    - Ganache (https://www.trufflesuite.com/ganache)
- Solidity fundamentals

### D21 Briefing
"Janečkova metoda D21" is a modern voting system, which allows more accurate voting. You can learn more about it here:
https://www.ih21.org/o-metode. In our exercise, we want to achieve following use cases:
- UC1 - Everyone can register a subject (e.g. political party)
- UC2 - Everyone can list registered subjects
- UC3 - Everyone can see subject’s results
- UC4 - Only owner can add eligible voters
- UC5 - Every voter has 2 positive and 1 negative vote
- UC6 - Both positive votes can’t be given to the same subject
- UC7 - Negative vote can be used only after 2 positive votes
- UC8 - Voting ends after 7 days from the contract deployment

### Interface
This interface will help you with the contract implementation. It is necessary to strictly follow this interface and naming for
sucessful evaluation of the final exercise

```
// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;
interface IVoteD21{
}
```

### Subject structure
Define the structure inside the interface. Subject of voting can be for example a political party.

```
struct Subject{
 string name;
 int votes;
}
```

### Interface functions
Add a new subject into the voting system using the name.
```
function addSubject(string memory name) external;
```
Add a new voter into the voting system.
```
function addVoter(address addr) external;
```
Get addresses of all registered subjects.
```
function getSubjects() external view returns(address[] memory);
```
Get the subject details.
```
function getSubject(address addr) external view returns(Subject memory);
```
Vote positive for the subject.
```
function votePositive(address addr) external;
```
Vote negative for the subject.
```
function voteNegative(address addr) external;
```
Get remaining time to the voting end in seconds.
```
function getRemainingTime() external view returns(uint);
```

### Create the contract
Now we create the contract, which implements defined interface.

```
pragma solidity 0.8.9;
import "./IVoteD21.sol";
contract D21 is IVoteD21 {
}
```

### Implement the logic
Implementation of the smart contract completely depends on you. There are many of possible ways how to achieve it. The
only important thing is, to follow the IVoteD21 interface. If you have any blocker or questions, don’t hesitate to ask.
