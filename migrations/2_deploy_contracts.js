var GroveLib = artifacts.require("./GroveLib.sol");
var BookQueueLib = artifacts.require("./BookQueueLib.sol");
var BookPub = artifacts.require("./BookPub.sol");
var BookDistLib = artifacts.require("./BookDistLib.sol");
var Owned = artifacts.require("../contracts/Owned.sol")
var Stoppable = artifacts.require("../contracts/Stoppable.sol");

module.exports = function(deployer) {
  deployer.deploy(Owned);
  deployer.deploy(Stoppable);
  deployer.deploy(BookPub);
  deployer.deploy(GroveLib);
  deployer.link(GroveLib, BookQueueLib);
  deployer.deploy(BookQueueLib);
  deployer.deploy(BookDistLib);
};
