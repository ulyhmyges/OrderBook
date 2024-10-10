// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

//"@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {console} from "forge-std/Script.sol";
import {CurrencyFactory} from "./CurrencyFactory.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract OrderBook {

    enum TraderType {
        Buyer,
        Seller
    }
    
    struct Order {
        uint256 id;
        uint256 price;
        uint256 quantity;
        address trader;
        TraderType traderType;
    }
  
    mapping(uint256 => mapping(uint256 => Order[])) public qpSellOrders;
    mapping(uint256 => mapping(uint256 => Order[])) public qpBuyOrders;

    IERC20 public bitcoin;
    IERC20 public peso;

    constructor(address _token1, address _token2){
        require(_token1 != address(0));
        require(_token2 != address(0));
        require(_token1 != _token2);
        bitcoin = IERC20(_token1);
        peso = IERC20(_token2);
    }

       // Function to generate a pseudo-random number
    function getRandomNumber(uint256 _modulus) public view returns (uint256) {
        // Generate a pseudo-random number based on block data and sender address
        uint256 randomHash = uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, msg.sender)));
        
        return randomHash % _modulus;
    }

}
