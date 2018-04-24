pragma solidity ^0.4.20;

contract MyToken {
    mapping (address => uint256) public balanceOf;

    function MyToken(uint256 initialSupply) public {
        balanceOf[msg.sender] = initialSupply;
    }

    function transfer(address _to, uint256 _value) public {
        require(balanceOf[msg.sender] >= _value);
        //check for overflow,
        require(balanceOf[_to] + _value >= balanceOf[_to]);
        balanceOf[msg.sender] -= _value;
        
        uint256 temp = balanceOf[_to]; 
        balanceOf[_to] += _value;
        assert(balanceOf[_to] == (temp + _value));
        
    }
}