pragma solidity ^0.4.15;

import "truffle/Assert.sol";
import "../contracts/BookQueueLib2.sol";

contract TestBookQueueLib2{
  using BookQueueLib2 for BookQueueLib2.BookQueue;

  BookQueueLib2.BookQueue queue;
  BookQueueLib2.BookQueue queue1;
  BookQueueLib2.BookQueue queue2;
  function beforeAll(){
  //  queue = BookQueueLib.createNew();
  }

  function test0_insertReader(){
	address readerAddress = 0x3;
	address readerAddress1 = 0x4;
	address readerAddress2= 0x5;
    address readerAddress3 = 0x6;
   	uint value = 2;	
	uint value1=5;
	uint value2=9;
    uint value3=12;
	uint order=1;
   	queue.insertReader( readerAddress,value);
	queue.insertReader( readerAddress1,value1);	  
	queue.insertReader( readerAddress2,value2);
	//queue.insertReader( readerAddress3,value3);
	Assert.equal(queue.findReaderPos(readerAddress), queue.findReaderPos(readerAddress1), "Rank failiing");
  }
   function test0_insertReader2(){
	address readerAddress = 0x3;
	address readerAddress1 = 0x4;
    	uint value = 2;	
        uint value1=5;
    	uint order=1;
    queue1.insertReader( readerAddress,value);
	queue1.insertReader( readerAddress1,value1);
	address readerAddress2= 0x5;
        uint value2=9;
	queue1.insertReader( readerAddress2,value2);
	Assert.equal(queue.findvalueAtRank(2), 1, "Reader not added");
  }
  function test0_insertReader3(){
	address readerAddress = 0x3;
	address readerAddress1 = 0x4;
	address readerAddress2= 0x5;
    address readerAddress3 = 0x6;
   	uint value = 2;	
	uint value1=5;
	uint value2=9;
    uint value3=12;
	
   	queue.insertReader( readerAddress,value);
	queue.insertReader( readerAddress1,value1);	  
	queue.insertReader( readerAddress2,value2);
	
	uint x=queue2.findNodeCount(value);
	//uint y=queue2.findNodeCount(value1);
	Assert.equal(x, 1, "Rank failiing");
  }
  /* } */
  /* function test2_testAddAnotherReaderLowerValue(){ */
  /*   address currentFirstInLine = queue.getFirstInLine(); */
  /*   address readerAddress = 0x6; */
  /*   int value = 1; */
  /*   queue.addToQueue(value, readerAddress); */
  /*   Assert.equal(queue.getLinePosition(0), currentFirstInLine, "Reader not added correctly"); */
  /* } */

  /* function test3_testAddAnotherReaderSameValue(){ */
  /*   address readerAddress = 0x7; */
  /*   int value = 3; */
  /*   queue.addToQueue(value, readerAddress); */
  /*   Assert.equal(queue.getLinePosition(1), readerAddress, "Reader not added correctly"); */
  /*   } */

  function test4_testEnumerateLine(){
    // queue.getLine or getReaderAtPositionInLine or ???
    //
  }

  //test function to make sure line enumeration works as expected


}
