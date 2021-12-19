// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

/**
 * @title D21 voting system interface
 * @author smrza
 */
interface IVoteD21{
    
    // Subjects to be voted for
    struct Subject{
        string name;
        int votes;
    }
    
    // An eligible voter, 2 positive votes, 1 negative vote
    struct Voter {
        bool canVote; // Assigned by owner
        address votePositiveAddr; // Store address of first vote to ensure person does not vote twice for the same subject        
        address votePositiveAddr2; // Store address of second vote to ensure person does not vote twice for the same subject 
        uint8 voteCount; // Counter to determine how many times person voted
    }

    // Add a new subject into the voting system using the name.
    function addSubject(string memory name) external;
    
    // Add a new voter into the voting system.
    function addVoter(address addr) external;
    
    // Get addresses of all registered subjects.
    function getSubjects() external view returns(address[] memory);
    
    // Get the subject details.
    function getSubject(address addr) external view returns(Subject memory);
    
    // Vote positive for the subject.
    function votePositive(address addr) external;
    
    // Vote negative for the subject.
    function voteNegative(address addr) external;
    
    // Get remaining time to the voting end in seconds.
    function getRemainingTime() external view returns(uint);
}