pragma solidity ^0.4.15;


import "./BookPub.sol";

library BookDistLib {

  event NewQualifyingReaders ();          //Some readers become eligible after goal is met
  event BookRequested(address reader);    //Reader claims book
  event LogBookShipped(address reader);   //Author sends shipping confirmation

  //Some readers become eligible to claim hard copy upon funding goal
  function prepShip(uint readers){
    //getFirstInLine(BookQueue storage queue)
    //Book.readerEligibilityAndBalance.eligibleForBook = true;
    }
  //Readers can claim hard copy after they become eligible
  function requestDelivery (){
    //require(Book.readerEligibilityAndBalance.eligibleForBook = false = true);
    //Book.readerEligibilityAndBalance.eligibleForBook = false;
    BookRequested(msg.sender);
    }
  function markShipped (address reader){
    //How should I alert the reader?
    LogBookShipped(reader);
    }

}
