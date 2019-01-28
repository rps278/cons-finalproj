pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/MarketPlace.sol";


contract TestMarketPlace {

  MarketPlace mplace = MarketPlace(DeployedAddresses.MarketPlace());

  
   // Purpose of this test is to test the value of the skuCount variable
  function testSKUCount() public{
    Assert.equal(mplace.skuCount(),0,"SKU Count is 0");
  }

     // Purpose of this test is to test the value of the Customer Count variable
  function testCustomerCount() public {
    Assert.equal(mplace.customerCount(),0,"Customer Count should be 0");
  }

     // Purpose of this test is to test the value of the skuCount variable
  function testStoreOwnerCount() public {
    Assert.equal(mplace.storeOwnerCount(),0,"StoreOwner Count should be 0");
  }

}
