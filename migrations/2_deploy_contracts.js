
//var GroveLib = artifacts.require('./GroveLib.sol');
var OrderedStatisticTree=artifacts.require('./OrderedStatisticTree.sol')
//var BookQueueLib = artifacts.require('./BookQueueLib.sol');

var OrderedStatisticTree = artifacts.require('./OrderedStatisticTree.sol');
var BookQueueLib = artifacts.require('./BookQueueLib2.sol');

var BookPub = artifacts.require('./BookPub.sol');
var Book = artifacts.require('./Book.sol');
var BookDistLib = artifacts.require('./BookDistLib.sol');
var Owned = artifacts.require('../contracts/Owned.sol');
var Stoppable = artifacts.require('../contracts/Stoppable.sol');

module.exports = function(deployer) {
  deployer.deploy(Owned);
  deployer.deploy(Stoppable);
  deployer.deploy(OrderedStatisticTree);

  

  deployer.link(OrderedStatisticTree, BookQueueLib);
  deployer.deploy(BookQueueLib);
  deployer.link(BookQueueLib, Book);
  deployer.link(BookQueueLib, BookPub);

  deployer.deploy(BookPub);
  deployer.deploy(Book,'0x627306090abaB3A6e1400e9345bC60c78a8BEf57',100,100,100,100,100,"TestBook",10000,1,50,"TB");
  deployer.deploy(BookDistLib);

};
