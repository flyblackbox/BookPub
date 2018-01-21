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
    uint bookID;            //ID applied to book upon pub, incrementing after each new book

    function BookPub(address bookAuthor){
        bookID = 0;
      }
    modifier isOwner() {
      require(msg.sender == owner);
      _;}           //Owner of BookPub Platform
    modifier isAuthor() {
      //  require(authors[msg.sender].totalEarned == 0);
      _;}                                          //Author exists in Author mapping
    modifier isReader() {
      //    require(readers[msg.sender].readerUsername);
      _;}                                          //Reader exists in Reader mapping

    mapping(address => Reader) readers;
    mapping(address => Author) authors;
    mapping(uint => Book) books;
    mapping(uint => uint) partnerShares;
    mapping(uint=>mapping(uint=>uint)) partnerShares;
    //Reader details [readersUsername, bookIDs purchased array]
    struct Reader {
      bytes readerUsername;      //Reader's username
      bool eligible;
      //uint[] booksPurchased;       //BookIDs of all owned books
      }
    //Author details [authorName, totalEarned, bookID published array]
    struct Author {
       bytes authorName;          //Author's legal name
       uint totalEarned;            //How much has this writer earned?
       //uint[] booksPublished;       //BookIDs of all published books
      }

    //Book details [bookID, authorAddress, readershipStake, readers array]
    struct Book {
      uint bookID;                 //Global book ID ++1
      address authorAddress;       //Who was the author? Can be used to access Authors mapping
      uint readershipStake;
      uint[] Partners;
      uint NumPartners;
      uint goal	;
      uint eligibleCount;
	    uint startdate;
	    uint enddate;

	    string tokenName;
	    string tokenSymbol;
	    string governanceModel;
	  //How much equity did the author provision for readers?
      }
    function addPartner(uint _bookID,uint _partnerID ,uint _share){
      uint i=books[_bookID].NumPartners;
	    partnershares[_bookID][i]=__share;

      books[_bookID].NumPartners=i+1;
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



    function publishBook (uint _readershipStake,string _tokenName,string _tokenSymbol,string _governanceModel)
      isAuthor() {
       bookID += 1;
		   uint t=0;
       //uint[] memory P = new uint[](10);//default 10 possible partners (possibly add option for more or less)
		   //uint[]  P;
		   //P[1]=12;

        books[bookID] = Book({
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
                            NumPartners:0

                            });
                          }
  function modifyBook(uint _bookID,uint _goal,uint _startdate,uint _enddate,uint _eligibleCount)
	 isAuthor()   {
	              Book memory temp=books[_bookID];
	              temp.goal=_goal;
	              temp.startdate=_startdate;
	              temp.enddate=_enddate;
	              temp.eligibleCount=_eligibleCount;




   }
   function structRet(uint n)  public returns(uint){
   Book memory b= books[n];
   return b.readershipStake;

   }
   function nameret(uint n)  public returns(string){
   Book memory b= books[n];
    return b.tokenName;

   }
   function symbolret(uint n)  public returns(string){
   Book memory b= books[n];
   return b.tokenSymbol;

   }
    function partner(uint n,uint m)  public returns(uint){
   Book memory b= books[n];
  uint c= b.Partners[m];
  return c;

   }
}
