pragma solidity ^0.4.15;

import "./BookQueueLib2.sol";
import "./BookDistLib.sol";
import "tokens/HumanStandardToken.sol";

contract Book is HumanStandardToken {
  using BookQueueLib2 for BookQueueLib2.BookQueue;
  address authorAddress;
  uint readershipStake;
  uint balance;
  uint goal;
  uint toBeShipped;
  uint userCount;
  uint eligibleCount;
  uint startdate;
  uint enddate;
  uint gasSaved;
  BookQueueLib2.BookQueue queue;

  function Book
    (
     address _authorAddress,
     //bytes metadata,
     uint _readershipStake,
     uint _goal,
     uint _toBeShipped,
     //uint _userCount,
     uint _eligibleCount,
     uint _initialAmount,
     string _tokenName,
     uint8 _decimalUnits,
     uint _startdate,
     uint _enddate,
     string _tokenSymbol)
    HumanStandardToken(_initialAmount, _tokenName, _decimalUnits, _tokenSymbol){
    authorAddress = _authorAddress;
    readershipStake = _readershipStake;
    goal = _goal;
  //  userCount = _userCount;
    eligibleCount = _eligibleCount;
    toBeShipped = _toBeShipped;
    startdate=_startdate;
    enddate=_enddate;
  }

  enum ReaderStatus { Waiting, Eligible, Requested, Shipped, Confirmed }

  struct Reader {
    uint id;
    bytes readerUsername;      //Reader's username
    ReaderStatus status;
  }

  event BoughtCoin(address reader, uint amountPaid);
  event GoalMet(bool success);
  event NewQualifyingReaders ();          //Some readers become eligible after goal is met
  event BookRequested(address reader);    //Reader claims book
  event LogBookShipped(address reader);   //Author sends shipping confirmation
  event LogBookConfirmed(address reader);   //Author sends shipping confirmation

  mapping (address => Reader) readers;
  mapping(uint=>uint) weeklysales;
//  mapping(address=>uint) balances;
  modifier goalMet {
    require (goalReached()&&(now>enddate));
    _;
  }
  modifier TimeValid {
    require ((startdate>now)&&(enddate<now));
    _;
  }

  function goalReached()
    returns (bool goalMet)
  {
    return balance >= goal;
  }

  function goalFailed()
    returns (bool goalFailed)
  {
    return ((balance<goal)&&(now>enddate));
  }

  function buyCoin()
    public
    payable
    returns(bool success){

    // Reader buys coins the first time
    if (balances[msg.sender] == 0) {
      // Add reader
      readers[msg.sender] = Reader({ id: userCount, readerUsername: 'Anonymous', status: ReaderStatus.Waiting });
      userCount++;

      // Add the reader to the queue in the last position
    }

    balances[msg.sender] += msg.value;
    queue.insertReader( msg.sender,uint(balances[msg.sender]));

    if (goalReached()) {
      GoalMet(true);
    }

  //  queue.addToQueue(int(msg.value), msg.sender);

    balance += msg.value;
    weekSaleSum( msg.value);
    return true;
  }

  function getFirstInLine()

  {

  }
  function weekSaleSum(uint value){
  //  uint currentday=((now-start)/86400)%7;
    uint currentweek=((now-startdate)/86400)/7;
    weeklysales[currentweek]+=value;
  }
  function ETA(uint week)returns (uint){
    uint temp= weeklysales[week];
    temp=temp/7;
    uint ETA=goal/temp;
    return(ETA);
  }
  // Anyone can call this
  // Idealy the author should as soon as the goal is met
  function setFirstEligible()
    goalMet
    returns (bool success)
  {
    require(eligibleCount <= toBeShipped);
    eligibleCount++;
    //address first = queue.getFirstInLine();
    //readers[first].status = ReaderStatus.Eligible;
  //  queue.remove(first, int(balances[first]));
    return true;
  }

  //((Author)) withdraws the capital they earned through coin sales
  function withdrawCapital()
    goalMet
    /*isAuthor()*/{
    authorAddress.transfer(balance);
  }
  function withdrawInvestment(){
    uint temp=balances[msg.sender];
    balances[msg.sender]=0;
    msg.sender.transfer(temp);

  }
  function claimCoins()
     goalMet
  {
    uint temp=balances[msg.sender];
    balances[msg.sender]=0;
    msg.sender.transfer((temp/balance));
  }
  //Readers can claim hard copy after they become eligible
  function requestDelivery (address readerAddress) returns (bool success) {
    require(readers[readerAddress].status == ReaderStatus.Eligible);
    readers[readerAddress].status = ReaderStatus.Requested;
    BookRequested(msg.sender);
    return true;
  }

  function markShipped (address reader) returns (bool success) {
    require(readers[reader].status == ReaderStatus.Requested);
    readers[reader].status = ReaderStatus.Shipped;
    LogBookShipped(reader);
    return true;
  }

  function confirmDelivery (address reader) returns (bool success) {
    require(readers[reader].status == ReaderStatus.Shipped);
    readers[reader].status = ReaderStatus.Confirmed;
    LogBookConfirmed(reader);
    return true;
  }

}