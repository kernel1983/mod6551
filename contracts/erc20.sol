/*
Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
.*/


pragma solidity 0.8.19;

import "./ierc20.sol";
import "./IERC721.sol";


contract ERC20 is IERC20 {

    uint256 constant private MAX_UINT256 = 2**256 - 1;
    mapping (address => mapping (uint256 => uint256)) public balances;
    mapping (address => mapping (uint256 => mapping (address => mapping (uint256 => uint256)))) public allowed;
    /*
    NOTE:
    The following variables are OPTIONAL vanities. One does not have to include them.
    They allow one to customise the token contract & in no way influences the core functionality.
    Some wallets/interfaces might not even bother to look at this information.
    */
    string public name;                   //fancy name: eg Simon Bucks
    uint8 public decimals;                //How many decimals to show.
    string public symbol;                 //An identifier: eg SBX
    uint256 public totalSupply;

    function init(
        uint256 _initialAmount,
        string memory _tokenName,
        uint8 _decimalUnits,
        string memory _tokenSymbol
    ) public {
        balances[msg.sender][0] = _initialAmount;               // Give the creator all initial tokens
        totalSupply = _initialAmount;                        // Update total supply
        name = _tokenName;                                   // Set the name for display purposes
        decimals = _decimalUnits;                            // Amount of decimals for display purposes
        symbol = _tokenSymbol;                               // Set the symbol for display purposes
    }

    function transfer(address _to, uint256 _value) external returns (bool success) {
        require(balances[msg.sender][0] >= _value);
        balances[msg.sender][0] -= _value;
        balances[_to][0] += _value;
        emit Transfer(msg.sender, _to, _value, 0, 0); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function transfer(address _to, uint256 _value, uint256 _from_tokenid, uint256 _to_tokenid) external returns (bool success) {
        require(balances[msg.sender][_from_tokenid] >= _value);
        if (_from_tokenid > 0) { // is_contract
            IERC721 nft = IERC721(msg.sender);
            require(nft.ownerOf(_from_tokenid) == tx.origin);
        }
        balances[msg.sender][_from_tokenid] -= _value;
        balances[_to][_to_tokenid] += _value;
        emit Transfer(msg.sender, _to, _value, _from_tokenid, _to_tokenid); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success) {
        uint256 _allowance = allowed[_from][0][msg.sender][0];
        require(balances[_from][0] >= _value && _allowance >= _value);
        balances[_to][0] += _value;
        balances[_from][0] -= _value;
        if (_allowance < MAX_UINT256) {
            allowed[_from][0][msg.sender][0] -= _value;
        }
        emit Transfer(_from, _to, _value, 0, 0); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value, uint256 _from_tokenid, uint256 _to_tokenid)
            external returns (bool success) {
        uint256 _allowance = allowed[_from][_from_tokenid][msg.sender][_to_tokenid];
        require(balances[_from][_from_tokenid] >= _value && _allowance >= _value);
        balances[_to][_to_tokenid] += _value;
        balances[_from][_from_tokenid] -= _value;
        if (_allowance < MAX_UINT256) {
            allowed[_from][_from_tokenid][msg.sender][_to_tokenid] -= _value;
        }
        emit Transfer(_from, _to, _value, _from_tokenid, _to_tokenid);
        return true;
    }

    function balanceOf(address _owner) external view returns (uint256 balance) {
        return balances[_owner][0];
    }

    function balanceOf(address _owner, uint256 _from_tokenid) external view returns (uint256 balance) {
        return balances[_owner][_from_tokenid];
    }

    function approve(address _spender, uint256 _value) external returns (bool success) {
        allowed[msg.sender][0][_spender][0] = _value;
        emit Approval(msg.sender, _spender, _value, 0, 0); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function approve(address _spender, uint256 _value, uint256 _from_tokenid, uint256 _to_tokenid) external returns (bool success) {
        allowed[msg.sender][_from_tokenid][_spender][_to_tokenid] = _value;
        if (_from_tokenid > 0) { // is_contract
            IERC721 nft = IERC721(msg.sender);
            require(nft.ownerOf(_from_tokenid) == tx.origin);
        }
        emit Approval(msg.sender, _spender, _value, _from_tokenid, _to_tokenid); //solhint-disable-line indent, no-unused-vars
        return true;
    }

    function allowance(address _owner, address _spender) external view returns (uint256 remaining) {
        return allowed[_owner][0][_spender][0];
    }
}
