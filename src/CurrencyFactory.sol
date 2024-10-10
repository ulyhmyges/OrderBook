// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "./Currency.sol";
import {console} from "forge-std/Script.sol";

// The CurrencyFactory contract is responsible for creating new Token instances
// It uses OpenZeppelin's AccessControl for role-based access control
contract CurrencyFactory is AccessControl {    
    // Array to store the addresses of all deployed tokens
    address[] public deployedCurrencies;

    // Mapping to store the initial supply of each token by its address
    mapping(address => uint256) public currencyToSupply;

    // Address that holds the FACTORY_ROLE, can deploy new tokens
    address public me = 0x99bdA7fd93A5c41Ea537182b37215567e832A726;
    bytes32 public constant FACTORY_ROLE = keccak256("FACTORY_ROLE");

    // Event emitted when a new token is created
    event CurrencyCreated(uint256 initialSupply, string name, string symbol);

    constructor() {
        _grantRole(FACTORY_ROLE, me);
    }

    // Function to create a new Token instance
    // Can only be called by addresses with the FACTORY_ROLEs
    function createCurrency(uint256 initialSupply, string memory name, string memory symbol)
        public
        onlyRole(FACTORY_ROLE)
    {
        address newCurrency = address(new Currency(initialSupply, name, symbol, me));
        currencyToSupply[newCurrency] = initialSupply;
        deployedCurrencies.push(newCurrency);
        emit CurrencyCreated(initialSupply, name, symbol);
    }

    function getSupply(address _token) public view returns (uint256) {
        return currencyToSupply[_token];
    }

    function getCurrencies() public view returns (address[] memory) {
        return deployedCurrencies;
    }

    function getLengthDeployedCurrencies() public view returns (uint256) {
        return deployedCurrencies.length;
    }
}
