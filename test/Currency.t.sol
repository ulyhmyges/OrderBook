// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {CurrencyFactory} from "../src/CurrencyFactory.sol";
import {Currency} from "../src/Currency.sol";

contract CurrencyFactoryTest is Test {
    Currency public currency;

    address public wallet = vm.envAddress("WALLET_ADDRESS");

    function setUp() public {
        vm.startPrank(wallet);
        currency = new Currency(45, "currencyName", "cur", wallet);
        vm.stopPrank();
    }

    function test_currency() public {
        assertEq(currency.name(), "currencyName");
        assertEq(currency.symbol(), "cur");
        assertEq(currency.totalSupply(), 45);
        assertEq(currency.decimals(), 18);
        assertEq(currency.balanceOf(wallet), 45);
        // DefaultSender: 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38
        assertEq(currency.balanceOf(msg.sender), 0);
        vm.startPrank(wallet);
        currency.transfer(0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38, 10);
        assertEq(currency.balanceOf(0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38), 10);
        vm.stopPrank();
        
        // my balance after transfer operation
        assertEq(currency.balanceOf(wallet), 35);
    }
}
