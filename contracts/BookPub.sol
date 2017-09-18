//BookPub - Decentralized Book Self-Publishing Platform
//Must work for many, many authors
//Assume authors might have as many as 10,000,000 fans
//Gonna be sweet!
//------------------------------------------------------*

/* Summary:
// Authors fund book publishing by selling licensing equity via micro crowd funding
1) Publish contract with initial supply of 0 and sell coins at fixed price
2) Readers purchase coins to reveal ebook download, and get in line for a hard copy
3) Any amount of coins purchased is acceptable, price as low as a penny if you like
4) The more coins you hold, the higher in line you get to receive your hard copy
5) Every coin you own represents a small piece of equity in licensing rights
6) Equity is determined by the number of coins you hold in proportion to total supply
7) When certain funding goals are met, users at the top of the line are shipped a hard copy  
8) Coin holders are legally entitled to licesnsing revenue if a deal is made with a publisher, movie studio, amusementpark, etc.
*/

/*MAY NOT COMPILE*/

pragma solidity ^0.4.15;

import "./Stoppable.sol";

contract BookPub is Stoppable {
    address[] readersArray; //Keep all readers addresses in an array, in order of when they were added.
    address public author;  //Who owns the rights due to creation
    uint capital;           //Total income
    uint equity;            //Define the amount of equity the total coin supply is worth
    uint bookID;            //Keep track of every book published incrementing with each addition
    uint readerID;          //Keep track of every new reader who joins the platform
    function BookPub(address bookAuthor){}                //Empty constructor, what do I need in here?
    event BoughtCoin(address reader, uint amountPaid)     //New reader buys a book
    event NewQualifyingReaders ()                         //Crowdfunding goal is met, new readers become qualified
    event LogBookShipped(address reader);                 //Reader claims book
    modifier isOwner() {
      require(msg.sender == owner);
      _;}           //Owner of BookPub Platform
    modifier isAuthor() {
      require(authors[msg.sender] != 0) revert();
      _;}                                          //Author exists in Author mapping
    modifier isReader() {
      require(Readers[msg.sender] = 0) revert();
      _;}                                          //Reader exists in Reader mapping
    /*modifier meetsMinimumInvestment() {
      require(Readers[msg.sender] = 0) revert();
      _;}                           //Require reader to invest*/
    mapping(address => Authors) authors;
    mapping(bytes32 => Books) books;
    mapping(address => Readers) readers;
    //Hold author details [authorName, authorAddress, eligible, books[]]
    struct Author {
       bytes32 authorName;          //Author's legal name
       address authorAddress;       //Authors address
       uint totalEarned;            //How much has this writer earned?
       bool eligible;               //Does this reader qualify for hard copy to be shipped?
       uint[] books;                //BookIDs of all published books
     }
    //Hold book details [bookID, authorAddress, foregoneEquity, deadline, text, amountEarned, readers array]
    struct Book {
       address bookID;              //Global book ID ++1
       address authorAddress;       //Who was the author? Can be used to access Authors mapping
       uint foregoneEquity;         //How much equity did the author provision for readers?
       bool deadline;               //When will readers legally be assigned equity?
       bool text;                   //The book itself, in full
       uint amountEarned;           //How much has been earned?
       uint[] readers;              //Readers addresses in an array
       struct ReaderOfThisBook {
         uint readerID;
         uint amountInvested;
       }
       mapping(address => ThisBooksReaders);
     }
    //Hold reader details [address, coinValue,]
    struct Reader {
      uint readerID;               //Reader's ID
      address readerAddress;       //Reader's address
      uint value;                  //How many shares does this reader hold
      bool eligible;               //Does this reader qualify for hard copy to be shipped?
      uint shares;                 //How many book coins does this reader have? (Equivalent to % of ETH submitted)
      uint[] books;                //BookIDs of all owned books
     }
    //Reader buys a coin for first time
    function buyCoin(bytes32 bookID, uint amountPaid, address reader)
      public
      returns(bool success)
      isReader() {
        //Add reader to book's reader list, set value as amountPaid
        //Put reader at the front of the line for this amount spent
      readers[passwordHash] = Reader({
                                    readerAddress: msg.sender,
                                    shares: msg.value,
                                    eligible: false,
                                    claimed: false
                                    });

      //Add this reader to the readers array.
      readers.push(readers[msg.address].readerAddress);
      return true;
      }
    function becomeAuthor() {
      //Author signs up with the site
      readers[passwordHash] = Reader({
                                    readerAddress: msg.sender,
                                    shares: msg.value,
                                    eligible: false,
                                    claimed: false
                                    });
                                  }
    function publishBook (bytes32 book text, uint foregoneEquity)
      isAuthor {
        authors[msg.sender] = Author(){

        }
      }
    //Function is called when fund raising goals are met, making a new set of readers eligible to claim hard copy
    function shipBooks () {
      require(Readers[msg.sender].eligbile = true);
      Readers[msg.sender].claimed = true;
      Readers[msg.sender].eligible = false;
      LogBookShipped(msg.sender)
      }
    //Allow readers to claim books after shipBooks() makes more readers eligible
    function claimBook ()
      isReader {
      require(Readers[msg.sender].eligbile = true);
      Readers[msg.sender].claimed = true;
      Readers[msg.sender].eligible = false;
      LogBookShipped(msg.sender)
      }
    //Author withdraws the capital they earned through coin sales
    function withdrawCapital()
      isAuthor {

      }
}
