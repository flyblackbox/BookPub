var GroveLib = artifacts.require("./GroveLib.sol");
var BookQueueLib = artifacts.require("./BookQueueLib.sol");

module.exports = function(deployer) {
  deployer.deploy(GroveLib);
  deployer.link(GroveLib, BookQueueLib);
  deployer.deploy(BookQueueLib);

};
