// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {OrderBook} from "../src/OrderBook.sol";
import {CurrencyFactory} from "../src/CurrencyFactory.sol";
import {Currency} from "../src/Currency.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


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
        factory.createCurrency(10000, "Peso", "MEX");
        token1 = factory.getCurrencies()[0];
        token2 = factory.getCurrencies()[1];

        vm.stopPrank();

        orderbook = new OrderBook(token1, token2);
        console.log("addr wallet: ", address(wallet));
        console.log("addr :", address(factory));
        console.log("addr OrderBook: ", address(orderbook));
    }

    // 
    function test_getSupplyTokens() public view {
        assertEq(Currency(token1).balanceOf(wallet), 21000);
        assertEq(Currency(token2).balanceOf(wallet), 10000);
    }

    function test_addSellOrder() public {
        //0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38
        address defaultSender = msg.sender;

        vm.startPrank(wallet);
        Currency(token1).approve(address(orderbook), 1);
        orderbook.addSellOrder(1, 500);
        vm.stopPrank();

        assertEq(Currency(token1).balanceOf(wallet), 20999);
        assertEq(Currency(token2).balanceOf(wallet), 10000);

        // vm.startPrank(wallet);
        // Currency(token2).approve(address(orderbook), 500);
        // IERC20(token2).transferFrom(wallet, address(orderbook), 500);
        // vm.stopPrank();
      
        // assertEq(Currency(token2).balanceOf(wallet), 10000);

        //assertEq(Currency(token2).balanceOf(defaultSender), 500);
       

        vm.startPrank(wallet);
        console.log("1: ---", defaultSender);
        console.log("2: ---", msg.sender);
        vm.stopPrank();
    }

       function test_addBuyOrder() public {
        //0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38
        address defaultSender = msg.sender;

        vm.startPrank(wallet);
        Currency(token2).approve(address(orderbook), 500);
        orderbook.addBuyOrder(1, 500);
        vm.stopPrank();

        assertEq(Currency(token1).balanceOf(wallet), 21000);
        assertEq(Currency(token2).balanceOf(wallet), 9500);

        // vm.startPrank(wallet);
        // Currency(token1).approve(address(orderbook), 1);
        // IERC20(token1).transferFrom(wallet, address(orderbook), 1);
        // vm.stopPrank();
      
        // assertEq(Currency(token2).balanceOf(wallet), 10000);

        //assertEq(Currency(token2).balanceOf(defaultSender), 500);

        vm.startPrank(wallet);
        console.log("1: ---", defaultSender);
        console.log("2: ---", msg.sender);
        vm.stopPrank();
    }
}
