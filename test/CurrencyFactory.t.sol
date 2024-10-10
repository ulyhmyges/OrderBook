// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {CurrencyFactory} from "../src/CurrencyFactory.sol";
import {Currency} from "../src/Currency.sol";

contract CurrencyFactoryTest is Test {
    CurrencyFactory public factory;
    Currency public currency;
    address public wallet = vm.envAddress("WALLET_ADDRESS");

    function setUp() public {
        vm.startPrank(wallet);
        factory = new CurrencyFactory();
        vm.stopPrank();
    }

    function test_getLengthDeployedCurrencies(uint256 supply, string memory name, string memory symbol) public {
        vm.startPrank(wallet);

        assertEq(factory.getLengthDeployedCurrencies(), 0);

        // create a token
        factory.createCurrency(supply, name, symbol);

        assertEq(factory.getLengthDeployedCurrencies(), 1);
        vm.stopPrank();
    }

    // getTokens returns an array of token addresses
    function test_getCurrencies(uint256 supply, string memory name, string memory symbol) public {
        assertEq(factory.getCurrencies().length, 0);
        vm.startPrank(wallet);
        factory.createCurrency(supply, name, symbol);
        assertEq(factory.getCurrencies().length, 1);
        vm.stopPrank();
    }
 
    function test_getSupply(uint256 supply, string memory name, string memory symbol) public {
        vm.startPrank(wallet);

        // create a token and get its address
        //factory.createToken(supply, name, symbol);
        console.log("args: ", supply, name, symbol);
        factory.createCurrency(4567, "TOTO", "TT");
        address tokenAddress = factory.getCurrencies()[0];

        assertEq(factory.getSupply(tokenAddress), 4567);
        assertEq(address(factory).balance, 0);

        // total supply of created token
        assertEq(Currency(tokenAddress).balanceOf(address(factory)), 0);
        assertEq(Currency(tokenAddress).balanceOf(wallet), 4567);
        
        vm.stopPrank();
    }

    // function test_getTokenNumber_after() public view {
    //     assertEq(factory.getTokenNumber(), 1);
    // }
}
