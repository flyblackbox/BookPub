pragma solidity ^0.4.15;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/BookPub.sol";

contract TestBookPub{

  function TestBookIndex() public {
    BookPub  book = BookPub(DeployedAddresses.BookPub());

	  uint expected=1;
	  uint expected1=3;
	
    book.publishBook(1,'BK','MYBOOK','boardroom');
    book.publishBook(3,'BK1','MYBOOK1','boardroom');
    uint ReaderStake=book.StructRet(1);
    uint ReaderStake2=book.StructRet(2);
    Assert.equal(ReaderStake, expected, "Readership stake should be 1");
    Assert.equal(ReaderStake2, expected1, "Readership stake should be 3");

  }






}
