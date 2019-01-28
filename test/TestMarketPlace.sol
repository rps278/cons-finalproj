pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/MarketPlace.sol";


contract TestMarketPlace {

  MarketPlace mplace = MarketPlace(DeployedAddresses.MarketPlace());

  function testSKUCount() public{
    Assert.equal(mplace.skuCount(),0,"SKU Count is 0");
  }

  function testCustomerCount() public {
    Assert.equal(mplace.customerCount(),0,"Customer Count should be 0");
  }

  function testStoreOwnerCount() public {
    Assert.equal(mplace.storeOwnerCount(),0,"StoreOwner Count should be 0");
  }

  function testSKUToReceivedState() public {
        Assert.equal(mplace.customerCount(),0,"Customer Count should be 0");

  }

}
