//BookStructPub - Decentralized BookStruct Self-Publishing Platform
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
import "./Book.sol";

contract BookPub is Stoppable {
    uint bookID;            //ID applied to book upon pub, incrementing after each new book

    function BookPub(address bookAuthor){
        bookID = 0;
      }
    modifier isOwner() {
      require(msg.sender == owner);
      _;}           //Owner of BookStructPub Platform
    modifier isAuthor() {
      //  require(authors[msg.sender].totalEarned == 0);
      _;}                                          //Author exists in Author mapping
    modifier isReader() {
      //    require(readers[msg.sender].readerUsername);
      _;}                                          //Reader exists in Reader mapping

    mapping(address => Reader) readers;
    mapping(address => Author) authors;
    mapping(uint => BookStruct) books;
    //mapping(uint => uint) partnerShares;
    mapping(uint=>mapping(uint=>uint)) partnerShares;
    //Reader details [readersUsername, bookIDs purchased array]
    struct Reader {
      bytes readerUsername;      //Reader's username
      bool eligible;
      //uint[] booksPurchased;       //BookStructIDs of all owned books
      }
    //Author details [authorName, totalEarned, bookID published array]
    struct Author {
       bytes authorName;          //Author's legal name
       uint totalEarned;            //How much has this writer earned?
       //uint[] booksPublished;       //BookStructIDs of all published books
      }

    //BookStruct details [bookID, authorAddress, readershipStake, readers array]
    struct BookStruct {
      uint bookID;                 //Global book ID ++1
      address authorAddress;       //Who was the author? Can be used to access Authors mapping
      uint readershipStake;
      //uint[] Partners;
      uint numPartners;
      uint goal	;
      uint eligibleCount;
	    uint startdate;
	    uint enddate;

	    string tokenName;
	    string tokenSymbol;
	    string governanceModel;
	  //How much equity did the author provision for readers?
      }
    function addPartner(uint _bookID,uint _share){
      uint i=books[bookID].numPartners;
	    partnerShares[_bookID][i]=_share;

      books[_bookID].numPartners=i+1;
    }
    function becomeReader(bytes _readerUsername) {
      //Reader signs up to buy book coins
      readers[msg.sender] = Reader({
                                  readerUsername: _readerUsername,
                                  eligible: false
                                  });
                                }
    function becomeAuthor(bytes _authorName) {
      //Author signs up to publish
      authors[msg.sender] = Author({
                                  authorName: _authorName,
                                  totalEarned: 0
                                  });
                                }



    function createBookStruct (uint _readershipStake,string _tokenName,string _tokenSymbol,string _governanceModel)
      isAuthor() {
       bookID += 1;
		   uint t=10;
       //uint[] memory P = new uint[](10);//default 10 possible partners (possibly add option for more or less)
		   //uint[]  P;
		   //P[1]=12;


        books[bookID] = BookStruct({
                            bookID: bookID,
                            authorAddress: msg.sender,
                            readershipStake: _readershipStake,
                            tokenName:_tokenName,
                            tokenSymbol:_tokenSymbol,
							              governanceModel:_governanceModel,
							              goal:t,
						                startdate:t,
	 						              enddate:t,
	 						              eligibleCount:t,
						               //	Partners:P,
                            numPartners:0

                            });
                          }
  function modifyBookStruct(uint _bookID,uint _goal,uint _startdate,uint _enddate,uint _eligibleCount)
	 isAuthor()   {
	              BookStruct storage temp=books[_bookID];
	              temp.goal=_goal;
	              temp.startdate=_startdate;
	              temp.enddate=_enddate;
	              temp.eligibleCount=_eligibleCount;

      //bytes data=0xa50b4f0;
      publishBook( _bookID ,  uint8(1000), uint(1000),  uint(0) );
   }

  function publishBook(uint id, uint8 _decimalUnits,uint _initialAmount, uint _toBeShipped ){
     BookStruct memory temp=books[id];

     Book newBook = new Book(msg.sender, temp.readershipStake, temp.goal, _toBeShipped,
                             temp.eligibleCount, _initialAmount, temp.tokenName,_decimalUnits,temp.startdate,temp.enddate,temp.tokenSymbol);
   }

   function structRet(uint n)  public returns(uint){
     BookStruct memory b= books[n];
     return b.readershipStake;

   }
   function nameret(uint n)  public returns(string){
     BookStruct memory b= books[n];
     return b.tokenName;

   }
   function symbolret(uint n)  public returns(string){
     BookStruct memory b= books[n];
     return b.tokenSymbol;

   }
   function getBookStruct(uint n) public  returns (BookStruct) {
     return books[n];
   }
   function getOtherparams(uint n) returns(uint,uint,uint,uint){
     BookStruct memory b= books[n];
     return(b.goal,b.startdate,b.enddate,b.eligibleCount);

 }
  function getPartnerShare(uint n,uint m) public  returns (uint) {
    return  partnerShares[n][m];
  }
  function returnallShares(uint n) public returns (uint[]){
    BookStruct memory B=books[n];
    uint sz=B.numPartners;
    uint[] memory P = new uint[](sz);
    for(uint i=0;i<sz;i++){
    P[i]=getPartnerShare(n,i);

  }
  return P;
}
}
