pragma solidity ^0.4.15;

import "./BookQueueLib.sol";
import "tokens/HumanStandardToken.sol";

contract Book is HumanStandardToken {
  using BookQueueLib for BookQueueLib.BookQueue;
  address authorAddress;
  address[] readers;
  uint readershipStake;
  uint balance;
  uint goal;
  uint userCount;
  BookQueueLib.BookQueue queue;

  function Book
    (
     address _authorAddress,
     bytes metadata,
     uint _readershipStake,
     uint _goal,
     uint _userCount
     uint _initialAmount,
     string _tokenName,
     uint8 _decimalUnits,
     string _tokenSymbol)
    HumanStandardToken(_initialAmount, _tokenName, _decimalUnits, _tokenSymbol){
    authorAddress = _authorAddress;
    readershipStake = _readershipStake;
    goal = _goal;
    userCount = _userCount;
  }
  event BoughtCoin(address reader, uint amountPaid);
  event GoalMet(bool success);

  //Book reader details [eligibleForBook, coinCount]
  struct BookReader {
    bool eligibleForBook;      //Reader's username
    uint coinCount;          //Does this reader qualify for hard copy to be shipped?
  }

  mapping (address => BookReader) readerEligibilityAndBalance;

  function goalMet() {
    return balance >= goal;
  }

  function buyCoin()
    public
    payable
    returns(bool success){
    balance += msg.value;

    // Reader buys coins the first time
    if (readerEligibilityAndBalance[msg.sender].coinCount == 0) {
      //Set coinCount as amountPaid
      readerEligibilityAndBalance[msg.sender] = BookReader({
        eligibleForBook: false,
        coinCount: readerEligibilityAndBalance[msg.sender].coinCount += msg.value
      });
      readers.push(msg.sender);

      // Add the reader to the que in the
      queue.addToQueue(int(msg.value), msg.sender);
    } else { //Reader buys more coins later on
      queue.remove(msg.sender, int(readerEligibilityAndBalance[msg.sender].coinCount));
      readerEligibilityAndBalance[msg.sender].coinCount += msg.value;

      // Unsure about this, seems like adding the user first when he buys more coins is bound to be gamed.
      // I.e why buy 100 when you can buy 50 + 50 and be at the front of the 100: line...
      queue.addToQueueFirst(int(readerEligibilityAndBalance[msg.sender].coinCount), msg.sender);
    }

    if (goalMet()) {
      GoalMet(true);
    }

    queue.addToQueue(int(msg.value), msg.sender);
    return true;
  }

  function getFirstInLine()
    constant
    returns (address readerAddress)
  {
    return queue.getFirstInLine();
  }

  function setFirstEligible()
    returns (bool success)
  {
    address first = queue.getFirstInLine();
    BookReader reader = readerEligibilityAndBalance[first];
    reader.eligibleForBook = true;
    queue.remove(first, int(reader.coinCount));
    return true;
  }

  //((Author)) withdraws the capital they earned through coin sales
  function withdrawCapital()
    /*isAuthor()*/{
    authorAddress.transfer(balance);
  }

}
