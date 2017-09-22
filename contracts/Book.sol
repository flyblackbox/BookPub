pragma solidity ^0.4.15;

import "tokens/HumanStandardToken.sol";

contract Book is HumanStandardToken {
  address authorAddress;
  address[] readers;
  uint readerID;
  uint readershipStake;
  uint balance;

  function Book (address _authorAddress, bytes metadata, uint _readershipStake) {
    readerID = 1;
    authorAddress = _authorAddress;
    readershipStake = _readershipStake;
    }
  event BoughtCoin(address reader, uint amountPaid);

  //Book reader details [eligibleForBook, coinCount]
  struct BookReader {
      bool eligibleForBook;      //Reader's username
      uint coinCount;          //Does this reader qualify for hard copy to be shipped?
    }

  mapping (address => BookReader) readerEligibilityAndBalance;

  function buyCoin(bytes32 bookID, uint amountPaid, address reader)
    public
    payable
    returns(bool success){
    balance += msg.value;
    //Set coinCount as amountPaid
    readerEligibilityAndBalance[msg.sender] = BookReader({
                                  eligibleForBook: false,
                                  coinCount: readerEligibilityAndBalance[msg.sender].coinCount += amountPaid
                                  });
    //Put reader at the front of the line for this amount spent
    //BookQueueLib.addToBucket(BookQueue storage queue, bytes32 bucketID, address readerAddress)
    //Add this reader to the readers array.
    readers.push(msg.sender);
    readerID += 1;
    return true;
    }
  //Reader buys more coins later on
  function buyMoreCoin(bytes32 bookID, uint amountPaid, address reader){
    //BookQueueLib.remove(reader)
    //BookQueueLib.addToBucket(BookQueue storage queue, bytes32 bucketID, address readerAddress)
    }
  //Author withdraws the capital they earned through coin sales
  function withdrawCapital()
    /*isAuthor()*/{
    authorAddress.transfer(balance);
    }

}
