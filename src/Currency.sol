// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

//"@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {console} from "forge-std/Script.sol";

contract Currency is ERC20 {
    constructor(
        uint256 initialSupply, 
        string memory name, 
        string memory symbol, 
        address account
        ) ERC20(name, symbol) 
    {
        _mint(account, initialSupply);
    }
}
