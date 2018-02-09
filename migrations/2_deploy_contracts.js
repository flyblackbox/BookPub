var GroveLib = artifacts.require('./GroveLib.sol');
var BookQueueLib = artifacts.require('./BookQueueLib.sol');
var BookPub = artifacts.require('./BookPub.sol');
var Book = artifacts.require('./Book.sol');
var BookDistLib = artifacts.require('./BookDistLib.sol');
var Owned = artifacts.require('../contracts/Owned.sol');
var Stoppable = artifacts.require('../contracts/Stoppable.sol');

module.exports = function(deployer) {
  deployer.deploy(Owned);
  deployer.deploy(Stoppable);
  deployer.deploy(GroveLib);
  deployer.link(GroveLib, BookQueueLib);
  deployer.deploy(BookQueueLib);
  deployer.link(BookQueueLib, Book);
  deployer.link(BookQueueLib, BookPub);
  deployer.deploy(BookPub);
  deployer.deploy(Book);
  deployer.deploy(BookDistLib);
  
};
