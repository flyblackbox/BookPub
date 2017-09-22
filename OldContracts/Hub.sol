
/* Book Pub Hub */

pragma solidity ^0.4.6;

import "Stoppable.sol";
import "Dbook.sol";

contract Hub is Stoppable {

    address[] public books;

    event LogNewBook(address book)

    function newBook()
      returns (address bookAddress){
        Dbook trustedBook = new Dbook();
        books.push(trustedBook)
        LogNewBook(address trustedBook)
        return trustedBook;
      }
    }

    function getBookCount()
      public
      constant
      returns(uint bookCount){
        return books.length;
      }


    function Hub(){
    }
    //Keep track of your BoardMembers in a Struct. Key is the hash of sender address & password.
    mapping(bytes32 => Readers) readers;


    struct Readers {
       address readerAddress;       //Reader's address
       uint shares;                 //How many shares does this reader hold
       bool eligible;               //Does this reader qualify for hard copy to be shipped?
       bool claimed;                //Has this reader claimed their hard copy?
    }

    event LogBookShipped(address reader);

    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier isReader() {
        require(msg.sender == Readers[msg.sender].readerAddress);
        _;
    }

    function shipBook ()
      isReader {
      require(Readers[msg.sender].eligbile = true);
      Readers[msg.sender].claimed = true;
      LogBookShipped(msg.sender)

    }



/*

    //Creates a new member, must be executed by owner.
    //Member must be in same room as owner to enter password without revealing.
    function addMember(
                bytes32 memberName,
                address memberAddress,
                uint256 memberPassword,
                uint    voteWeight)
            isOwner(){
                bytes32 passwordHash;
                //mapping(bytes32 => VoteHistory) voteHistory;
                passwordHash = keccak256 (memberPassword, memberAddress);
                boardMembers[passwordHash] = BoardMember({
                                              memberAddress: memberAddress,
                                              memberName: memberName,
                                              amount: msg.value,
                                              passwordHash: passwordHash,
                                              voteWeight: voteWeight
                                              //voteHistory:
                                             });
                //Add this member to the board members array.
                boardMembersArray.push(boardMembers[passwordHash].memberAddress);
        }

    //Owner can change weight of members, but member must consent.
    //Member must provide password in person to change their weight.
   function changeVoteWeight(uint newVoteWeight, address _memberAddress, bytes32 _membersPassword)
        isOwner(){
        bytes32 passwordHash;
          passwordHash = keccak256(_memberAddress,  _membersPassword);
          boardMembers[passwordHash].voteWeight = newVoteWeight;
   }


    //Submit a proposal to the board
    function propose(bytes32 proposal, bytes32 _password, uint deadline) //User inputs text for the proposal when calling this function as well as their password, and the number of blocks until deadline
        {
         bytes32 passwordHash;
        passwordHash = keccak256(_password, msg.sender);
        //Require that this exact proposal does not already exist
        require(keccak256(proposal) != proposals[keccak256(proposal)].proposalText);
        proposals[keccak256(proposal, msg.sender)] = Proposal({
                                                        memberAddress: msg.sender,
                                                        memberName: boardMembers[passwordHash].memberName,
                                                        deadlineBlock: block.number + deadline,
                                                        proposalText: proposal,
                                                        proposalHash: passwordHash,
                                                        approved: false,
                                                        challenged: false,
                                                        yesVotes: boardMembers[passwordHash].voteWeight,
                                                        noVotes: 0
                                                        }
        //Track proposal keys in an array.
        //BoardMember[passwordHash].membersProposals.push(proposals[keccak256(proposal)]);

        });
    }



    //vote yes or no to a proposal
    function vote(bytes32 proposal, bytes32 password, bool voteTypeTrueUpFalseDown){
        uint256 passwordHash;
        uint voteWeight;
        passwordHash = keccak256(password, msg.sender);
        /*If approved proposal has less points than a late contrarian vote, initiate challenge, which re-opens voting*/
    /*    require(Proposal[keccak256(proposal)].approved != true);
        /*Require only one vote per member per proposal*/
  /*      if(!voteTypeTrueUpFalseDown){
            voteWeight += boardMembers[passwordHash].voteWeight * -1;
            proposals[proposal].noVotes.push(msg.sender);
        } else {
            voteWeight += boardMembers[passwordHash].voteWeight;
            proposals[proposal].yesVotes.push(msg.sender);
        }
    }

    //Put a resolved proposal back on the table for another vote
    function challenge(bytes32 memberPassword){
     //Restrict to members who have more weight than proposal.score?

     require(msg.sender);
     LogChallenge();
    }

}
