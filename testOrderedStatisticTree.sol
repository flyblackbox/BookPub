pragma solidity ^0.4.15;

import "truffle/Assert.sol";
import "../contracts/OrderedStatisticTree.sol ";

contract testOrderedStatisticTree {
  using  OrderedStatisticTree for  OrderedStatisticTree.Index ;

   OrderedStatisticTree.Index  OrderTreeIndex;
    function testInsertNew() {

        address readerAddress = 0x3;
        address readerAddress1 = 0x4;
	address readerAddress1 = 0x5;
        uint value = 2;
        uint value1=5;
	uint value2=10;


        OrderTreeIndex.insert(readerAddress,value);

        // Assert
        Assert.equal(OrderTreeIndex.nodes[0].children[true], value, "value should be added");
    }




}
