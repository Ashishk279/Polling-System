// SPDX-License-Identifier: MIT
pragma solidity >=0.8.13 <=0.8.21;

contract PollingSystem {
    address public owner;
    address public chairperson;
    uint256 public startTime;
    uint256 public endTime;
    bytes32[] public options;
    mapping (address => bool) public voters;
    mapping (bytes32 => uint256) public votesRecieved;
    

    constructor(address _owner, address _chairperson,  bytes32[] memory _options){
        owner = _owner;
        chairperson = _chairperson;
        startTime = block.timestamp;
        endTime = startTime +  15 minutes;
        options = _options;

    }

    function startVoting() public {
        require(msg.sender == chairperson);
        require(block.timestamp >= startTime);
        startTime = block.timestamp;
    }

    function endVoting() public {
        require(msg.sender == chairperson);
        require(block.timestamp <= endTime);
        endTime = block.timestamp;

        for (uint256 i = 0; i < options.length; i++){
            votesRecieved[options[i]] = 0;
        }

    }

    // block.timestamp >= start + daysAfter * 1 days
    // ["0x424a506500000000000000000000000000000000000000000000000000000000", "0x626c756500000000000000000000000000000000000000000000000000000000"]
    function vote(bytes32 option) public {
        require(block.timestamp <= endTime);
        require(voters[msg.sender] == true);
        votesRecieved[option] += 1;
    }

    function isVotingOpen() public view returns (bool) {
        return block.timestamp >= startTime && block.timestamp <= endTime;
    }

    function isVoter(address voter) public returns(bool) {
        return voters[voter] = true;
    }

    function getVoterFor(bytes32 option) public view returns(uint256) {
        return votesRecieved[option];
    }
    
    function getWinner() public view returns(bytes32) {
        uint256 maxVotes = 0;
        bytes32 winner;

        for (uint256 i = 0; i < options.length; i++) {
            if(votesRecieved[options[i]] > maxVotes) {
                maxVotes = votesRecieved[options[i]];
                winner = options[i];
            }
        }
        return winner;

    }

    function setChairperson(address  _chairperson) public {
        require(msg.sender == owner);
        chairperson = _chairperson;
    }

    function addVoter(address voter) public {
        require(msg.sender == chairperson);
        voters[voter] = true;
    }

    function removeVoter(address voter) public {
        require(msg.sender == chairperson);
        voters[voter] = false;
    }
}