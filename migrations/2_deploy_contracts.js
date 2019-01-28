var PriceCalculatorLib = artifacts.require("./PriceCalculatorLib.sol");
var MarketPlace = artifacts.require("./MarketPlace.sol");

module.exports = function(deployer) {
  deployer.deploy(PriceCalculatorLib);
  deployer.link(PriceCalculatorLib, MarketPlace);
  deployer.deploy(MarketPlace);
};