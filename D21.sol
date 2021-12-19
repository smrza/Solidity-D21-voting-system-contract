// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;
import "./IVoteD21.sol";

/**
 * @title D21 voting system contract
 * @author smrza
 * @notice More about D21 voting system: https://www.ih21.org/en/d21-janecekmethod
 */
contract D21 is IVoteD21 {

    address immutable public owner; // Chairperson or someone important
    uint private timeout; // Time of creation + 1 week, used for 1 week timeout    
    mapping(address => Subject) private subjects; // Each created subject
    mapping(address => Voter) private voters; // Each eligible voter
    mapping(address => bool) private subjectCreated; // Map whoever created a subject
    address[] private subjectsAddr; // Save addresses of subjects
  
    constructor() {
        owner = msg.sender;
        timeout = block.timestamp + 1 weeks;
    }

    // Ensures the elections are still active
    modifier electionsActive {
        require(timeout > block.timestamp, "Elections have ended.");
        _;
    }

    // Ensures voter has the right to vote
    modifier voterActive {
        require(voters[msg.sender].canVote, "You cannot vote.");
        _;
    }

    // Ensures subject exists
    modifier subjectActive(address addr) {
        require(subjectCreated[addr], "This subject does not exist.");
        _;
    }

    /** 
      * @notice Adds a subject to the polls
      * @dev Elections must be active
      * @param name Name of the subject
      */
    function addSubject(string memory name) external electionsActive {
        require(!subjectCreated[msg.sender], "You have already created a subject.");
        subjects[msg.sender] = Subject(name, 0);
        subjectsAddr.push(msg.sender);
        subjectCreated[msg.sender] = true;
    }
    
    /** 
      * @notice Adds an eligible voter to the polls
      * @dev Elections must be active
      * @param addr Voter's address
      */
    function addVoter(address addr) external electionsActive {
        require(msg.sender == owner, "Only owner can give right to vote.");
        require(!voters[addr].canVote, "This person already has the right to vote.");
        voters[addr] = Voter(true, address(0x0), address(0x0), 0);
    }
  
    /** 
      * @notice Gets all subjects' addresses
      * @return The addresses of subjects
      */
    function getSubjects() external view returns(address[] memory) {
        return subjectsAddr;
    }
    
    /** 
      * @notice Gets a single subject by address and its name and vote count
      * @param addr Address of the subject
      * @return The subject structure with name and vote count
      */
    function getSubject(address addr) external view returns(Subject memory) {
        return subjects[addr];
    }
    
    /** 
      * @notice A voter votes positive for a subject
      * @dev Elections, voter and subject must be active
      * @param addr Address of subject to vote for
      */
    function votePositive(address addr) external electionsActive voterActive subjectActive(addr) {
        Voter storage vot = voters[msg.sender];
        require(vot.voteCount < 2, "You have already voted positive twice.");
        require(vot.votePositiveAddr != addr, "You have already voted for this subject.");
        ++vot.voteCount;
        ++subjects[addr].votes;
        if(vot.voteCount == 1)
            vot.votePositiveAddr = addr;
        else
            vot.votePositiveAddr2 = addr;
     }

    /** 
      * @notice A voter votes negative for a subject
      * @dev Elections, voter and subject must be active
      * @param addr Address of subject to vote for
      */ 
    function voteNegative(address addr) external electionsActive voterActive subjectActive(addr) {        
        Voter storage vot = voters[msg.sender];
        require(vot.voteCount > 1, "First, you must vote positive twice.");
        require(vot.voteCount < 3, "You have already voted negative.");
        require(vot.votePositiveAddr != addr && vot.votePositiveAddr2 != addr, "You already voted positive for this subject");
        ++vot.voteCount;
        --subjects[addr].votes;
    }
    
    /** 
      * @notice Returns how much time is left until the elections are over
      * @dev Elections must be active
      * @return The remaining time in seconds
      */
    function getRemainingTime() external electionsActive view returns(uint) {
        return timeout - block.timestamp;
    }
}