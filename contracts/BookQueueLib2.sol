pragma solidity ^0.4.15;

import "./OrderedStatisticTree.sol";
library BookQueueLib2 {
  using OrderedStatisticTree for OrderedStatisticTree.Index;


	struct BookQueue {

  		//bytes32 id;
    OrderedStatisticTree.Index ReaderValues;
  	mapping(address=>uint) insertOrder;
		mapping(address=>uint) readerBalance;
		mapping(uint=>address) balanceToReader;
  //  mapping(address=>uint) positions;
    address firstInLine;
		uint numberReaders;

	}
	function createQueue()
    internal
    returns (BookQueue)
  {
    return BookQueue({
      ReaderValues: OrderedStatisticTree.Index(),numberReaders:0,firstInLine:0x3

          });
  }

	function insertReader(BookQueue storage queue,address reader,uint value) returns (uint){
  if(queue.readerBalance[reader]==0){
    queue.numberReaders+=1;
  }
	   uint prevBalance=queue.readerBalance[reader];
	   queue.readerBalance[reader]+=value;
	  // queue.ReaderValues.remove(prevBalance);
    uint temp=queue.readerBalance[reader];
	   queue.ReaderValues.insert(temp);
	  // queue.positions[reader]=queue.ReaderValues.rank(value);
      uint Rank=queue.ReaderValues.rank(temp);
      if(Rank==queue.numberReaders){
        queue.firstInLine=reader;
      }
      return Rank;
	}
  function readerWithdraw(BookQueue storage queue,address reader, uint value){
       uint prevBalance=queue.readerBalance[reader];
       queue.readerBalance[reader]-=value;
       queue.ReaderValues.remove(prevBalance);
       queue.ReaderValues.insert(queue.readerBalance[reader]);
       //queue.positions[reader]=queue.ReaderValues.rank(value);

  }
  function findReaderPos(BookQueue storage queue,address reader) returns(uint){
	   uint balance=queue.readerBalance[reader];
	   uint pos=queue.ReaderValues.rank(balance);
	  return pos;
	}
  function getFirstInLine(BookQueue storage queue) returns(address){
    return queue.firstInLine;

  }
  function findbalance(BookQueue storage queue,address reader) returns(uint){
     return queue.readerBalance[reader];
  }
}
