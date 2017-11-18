# BookPub
Decentralized Book Self-Publishing Platform

![alt text](https://i.imgur.com/cWxF4Ac.png "Logo Title Text 1")

/*BookPub - Decentralized Book Publishing Contract   
// Authors fund book publishing by selling licensing equity via micro crowd funding   
//------------------------------------------------------*   
  
Often, talented writers are unable to effectively distribute their work to a large audience. This may be because the deal that publishers are presenting to readers is bad for the reader, and for the writer. "Pay us $5 for an eBook, or $30 for a hard copy" de-incentivizes readers from doing what writers want them to do, READ OUR BOOK! They place this barrier between authors and readers, and then take 80%+ of the profits.

What if we could remove the barrier? Find a way to fund physical printing of books, while awarding the author compensation. Luckily, creating an eBooks is free, so one can afford to give them away which gets readers in the door. But how can you afford to print physical books? They aren't free.  

Well people understand this, and they are willing to pay for a physical book that they really care about.  
Others honestly cannot afford to pay, but does it really make sense to turn away readers?  
What if we harness the payments of the people who are willing and able to pay for a physical copy, in order to subsidize the publishing of print copies for everyone else. 

To further incentivize readers, every coin they buy represents an equity portion of licensing rights.

# Rules
1) Publish contract with initial supply of 0 and sell coins at fixed price  
2) Readers purchase coins to reveal ebook download, and get in line for a hard copy  
3) Any amount of coins purchased is acceptable, price as low as a penny if you like  
4) The more coins you hold, the higher in line you get to receive your hard copy  
5) Every coin you own represents a small piece of equity in licensing rights  
6) Equity is determined by the number of coins you hold in proportion to total supply  
7) When certain funding goals are met, users at the top of the line are shipped a hard copy  
8) Coin holders are legally entitled to licesnsing revenue if a deal is made with a publisher, movie studio, amusementpark, etc.


#
// Book.sol
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

Users request access to use the application by providing their email address. They may include a payment of ETH along with their request. The two factors which determine their place in line are the timethey made the request and the amount of their payment (Link to code for queue placement). The founder then sets a goal which when met triggers invitations to be sent to the first users in queue. The founder may not access the funding until the goal is met, and until then, users are free to add to, or cancel invite requests. 



We use GroveLib to keep an ordered queue users. The users are grouped by the amount of ETH contributed into buckets defined by ETH range, if their payment amount falls within the range then they are added to the end of the list of users in that bucket.

  // GroveLib.sol
  function insert(Index storage index, bytes32 id, int value) public {
          if (index.nodes[id].id == id) {
              // A node with this id already exists.  If the value is
              // the same, then just return early, otherwise, remove it
              // and reinsert it.
              if (index.nodes[id].value == value) {
                  return;
              }
              remove(index, id);
          }

          bytes32 previousNodeId = 0x0;

          if (index.root == 0x0) {
              index.root = id;
          }
          Node storage currentNode = index.nodes[index.root];

          // Do insertion
          while (true) {
              if (currentNode.id == 0x0) {
                  // This is a new unpopulated node.
                  currentNode.id = id;
                  currentNode.parent = previousNodeId;
                  currentNode.value = value;
                  break;
              }

              // Set the previous node id.
              previousNodeId = currentNode.id;

              // The new node belongs in the right subtree
              if (value >= currentNode.value) {
                  if (currentNode.right == 0x0) {
                      currentNode.right = id;
                  }
                  currentNode = index.nodes[currentNode.right];
                  continue;
              }

              // The new node belongs in the left subtree.
              if (currentNode.left == 0x0) {
                  currentNode.left = id;
              }
              currentNode = index.nodes[currentNode.left];
          }

          // Rebalance the tree
          _rebalanceTree(index, currentNode.id);
  }

  // BookQueueLib.sol
  function createBucket(BookQueue storage queue, int value)
    internal
    returns(bytes32 bucketID)
  {
    bucketID = bytes32(value);
    queue.bucketIndex.insert(bucketID, value);
    return bucketID;
  }

  // BookQueueLib.sol
  function addToQueue(BookQueue storage queue, int value, address readerAddress) {
    //Take readers address, store it in BookQueue placement selected by value
    var bucketID = findBucket(queue, value);

    if (bucketID == 0x0) {
      bucketID = createBucket(queue, value);
      if(bucketID > queue.highestBucketID) {
        queue.highestBucketID = bucketID;
      }
    }
    addToBucket(queue, bucketID, readerAddress);
  }

A person’s equity is determined by their coin holding in proportion to the total number of coins in circulation. Equity coins can be immediately bought, and coins can be added to an account at any time. A user’s place in line is dynamic, and can go up by buying additional coins.

  // Book.sol
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


    queue.addToQueue(int(msg.value), msg.sender);
    return true;
  }


Once the goal of the contract is met, the users are notified and can request their invitation.
  // Book.sol
  function setFirstEligible()
    returns (bool success)
  {
    address first = queue.getFirstInLine();
    BookReader reader = readerEligibilityAndBalance[first];
    reader.eligibleForBook = true;
    queue.remove(first, int(reader.coinCount));
    return true;
  }
