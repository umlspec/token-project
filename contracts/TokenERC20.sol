pragma solidity ^0.4.16;

interface tokenRecipient {
    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData ) external;
}

contract TokenERC20 {
    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Burn(address indexed from, uint256 value);

    function TokenERC20(uint256 initialSupply, string tokenName, string tokenSymbol) public {
        totalSupply = initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        name = tokenName;
        symbol = tokenSymbol;
    }

    /**
    * internal tranfer, only can be called by this contract
     */
    function _transfer(address _from, address _to, uint _value) internal {
        require(_to != 0x0);
        require(balanceOf[_from] >= _value);
        require(balanceOf[_to] + _value >= balanceOf[_to]);

        uint previousBalances = balanceOf[_from] + balanceOf[_to];

        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(_from, _to, _value);
        assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
    }

    function tranfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }

/**
*  send '_value' tokens to '_to' on behalf of '_from'
*   i am not sending tokens from my account
*   i am sending tokens from one to te other
*   "allownance" setup how much tokens can be sent from "_from", 
* which is allowed by me
 */
    function tranferFrom(address _from, address _to, uint256 _value) 
        public returns (bool) {
        require(_value <= allowance[_from][msg.sender]);
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint _value) public returns (bool){
        allowance[msg.sender][_spender] = _value;
        return true;
    }

    //interface is not implemented
    // function signature is just declared

    function approveAndCall(address _spender, uint256 _value, bytes _extraData)
    public returns(bool) {
        tokenRecipient spender = tokenRecipient(_spender);
        if (approve(_spender, _value)){
            spender.receiveApproval(msg.sender, _value, this, _extraData);
            return true;
        }
    }

    function burn(uint256 _value) public returns(bool){
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        totalSupply -= _value;
        emit Burn(msg.sender, _value);
    }

    function burn(address _from, uint256 _value) public returns (bool){
        require(balanceOf[_from] >= _value);
        require(_value <= allowance[_from][msg.sender]);
        balanceOf[_from] -= _value;
        allowance[_from][msg.sender] -= _value;
        totalSupply -= _value;
        emit Burn(_from, _value);
        return true;
    }


}





