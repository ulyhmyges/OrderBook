// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

//"@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {console} from "forge-std/Script.sol";
import {CurrencyFactory} from "./CurrencyFactory.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract OrderBook {

    enum Booker {
        Buyer,
        Seller
    }
    
    struct Order {
        uint256 price;
        uint256 quantity;
        address addr;
        Booker booker;
    }

    Order[] sellOrders;
    Order[] buyOrders;

    IERC20 bitcoin;
    IERC20 peso;

    constructor(address _token1, address _token2){
        require(_token1 != address(0));
        require(_token2 != address(0));
        require(_token1 != _token2);
        bitcoin = IERC20(_token1);
        peso = IERC20(_token2);

    }

    

}
