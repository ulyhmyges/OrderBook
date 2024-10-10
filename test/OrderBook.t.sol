// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {OrderBook} from "../src/OrderBook.sol";
import {CurrencyFactory} from "../src/CurrencyFactory.sol";

contract OrderBookTest is Test {
    OrderBook public orderbook;
    CurrencyFactory public factory;
    address public token1;
    address public token2;

    address public wallet = vm.envAddress("WALLET_ADDRESS");

    function setUp() public {
        vm.startPrank(wallet);

      
        factory = new CurrencyFactory();
        factory.createCurrency(21000, "Bitcoin", "BTC");
        factory.createCurrency(1000000, "Peso", "MEX");
        token1 = factory.getCurrencies()[0];
        token2 = factory.getCurrencies()[1];

        vm.stopPrank();

        orderbook = new OrderBook(token1, token2);
        console.log("addr wallet: ", address(wallet));
        console.log("addr :", address(factory));
        console.log("addr OrderBook: ", address(orderbook));
    }

    function test_getRandomNumber() public view {
        uint256 r = orderbook.getRandomNumber(10);
        console.log("log: ", r);
        //assertEq(r, 1);
    }

    function test_addSellorder() public {
        
    }
}
