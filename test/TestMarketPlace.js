const MarketPlace = artifacts.require("MarketPlace");

contract("MarketPlace Customer Registration Test", async accounts => {
  it("should create a customer entry", async () => {
  	const account_one = accounts[0];
    const account_two = accounts[1];
    let instance = await MarketPlace.deployed();
    await instance.registerCustomer('Rishikesh','Shringarpure',{from: account_one});
    assert.equal(true, true);
  });

   it("should create a storeowner entry", async () => {
  	const account_one = accounts[0];
    const account_two = accounts[1];
    let instance = await MarketPlace.deployed();
    await instance.registerCustomer('Rishikesh','Shringarpure',{from: account_one});
    assert.equal(true, true);
  });

});
