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
        bool isFilled;
    }
  
    mapping(uint256 => mapping(uint256 => Order[])) public qpSellOrders;
    mapping(uint256 => mapping(uint256 => Order[])) public qpBuyOrders;

    IERC20 public bitcoin;
    IERC20 public peso;

    // représente la quantité d'ordres de vente reçus
    uint256 public sellordersNum;

    // représente la quantité d'ordres d'achat reçus
    uint256 public buyordersNum;

    Order[] public filledOrders;

    constructor(address _token1, address _token2){
        require(_token1 != address(0));
        require(_token2 != address(0));
        require(_token1 != _token2);
        bitcoin = IERC20(_token1);
        peso = IERC20(_token2);
        sellordersNum = 0;
        buyordersNum = 0;
    }

       // Function to generate a pseudo-random number
    function getRandomNumber(uint256 _modulus) public view returns (uint256) {
        // Generate a pseudo-random number based on block data and sender address
        uint256 randomHash = uint256(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, msg.sender)));
        
        return randomHash % _modulus;
    }

    function addSellOrder(uint256 _quantity, uint256 _price) public {
        Order memory newOrder = Order({
            id: sellordersNum++,
            price: _price,
            quantity: _quantity,
            trader: msg.sender,
            traderType: TraderType.Seller,
            isFilled: false
        });
        qpSellOrders[_quantity][_price].push(newOrder);

        //bitcoin.approve(address(this), _quantity);
        bitcoin.transferFrom(msg.sender, address(this), _quantity);
    
        if ((qpBuyOrders[_quantity][_price]).length > 0){

            uint256 len = qpBuyOrders[_quantity][_price].length;
         
            peso.transferFrom(
                address(this),
                msg.sender, 
                _price
            );

            bitcoin.transferFrom(
                address(this), 
                qpBuyOrders[_quantity][_price][len - 1].trader,
                _quantity
            );
            
            qpBuyOrders[_quantity][_price][len - 1].isFilled = true;

            // add the executed order for history
            filledOrders.push(qpBuyOrders[_quantity][_price][len - 1]);

            // then delete the executed order because is filled
            qpBuyOrders[_quantity][_price].pop();
        }
    }

    // buy _quantity (of Bitcoins) for _price (of pesos)
    function addBuyOrder(uint256 _quantity, uint256 _price) public {
        Order memory newOrder = Order({
            id: buyordersNum++,
            price: _price,
            quantity: _quantity,
            trader: msg.sender,
            traderType: TraderType.Buyer,
            isFilled: false
        });
        qpBuyOrders[_quantity][_price].push(newOrder);

        //peso.approve(address(this), _price);
        peso.transferFrom(msg.sender, address(this), _price);

        if ( (qpSellOrders[_quantity][_price]).length > 0 ){

            uint256 len = qpSellOrders[_quantity][_price].length;
         
            bitcoin.transferFrom(
                address(this),
                msg.sender, 
                _quantity
            );

            peso.transferFrom(
                address(this), 
                qpSellOrders[_quantity][_price][len - 1].trader,
                _price
            );
            
            qpSellOrders[_quantity][_price][len - 1].isFilled = true;

            // add the executed order for history
            filledOrders.push(qpSellOrders[_quantity][_price][len - 1]);

            // then delete the executed order because is filled
            qpSellOrders[_quantity][_price].pop();
        }
    }

}
