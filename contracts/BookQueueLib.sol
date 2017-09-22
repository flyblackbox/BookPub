pragma solidity ^0.4.15;

import "./GroveLib.sol";
import "./BookPub.sol";

library BookQueueLib {
  using GroveLib for GroveLib.Index;

    struct BookQueue {
      GroveLib.Index bucketIndex;
      mapping(bytes32 => address[]) buckets;
      bytes32 highestBucketID;
      }
    function createQueue()
      internal
      returns (BookQueue){
        return BookQueue({
            bucketIndex: GroveLib.Index(sha3(this, block.number)),
            highestBucketID: 0
        });
      }
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
    function retrieve(address readerAddress){}
    function findBucket(BookQueue storage queue, int value)
      internal
      returns (bytes32 bucketID){
      bucketID = queue.bucketIndex.query("==", value);
      }
    function remove(address reader) {}
    function createBucket(BookQueue storage queue, int value)
      internal
      returns(bytes32 bucketID){
      bucketID = bytes32(value);
      queue.bucketIndex.insert(bucketID, value);
      }
    function addToBucket(BookQueue storage queue, bytes32 bucketID, address readerAddress)
      internal{
      var bucket = queue.buckets[bucketID];
      bucket.push(readerAddress);

      }
    function getFirstInLine(BookQueue storage queue)
      constant
      returns(address readerAddress){
        var bucketID = queue.highestBucketID;
        var bucket = queue.buckets[bucketID];
        return bucket[bucket.length - 1];
      }
    function getLinePosition(BookQueue storage queue, uint index)
      constant
      returns(address readerAddress){
        /*var bucketID = queue.highestBucketID;
        var bucket = queue.buckets[bucketID];
        return bucket[bucket.length - 1];*/
      }

}
