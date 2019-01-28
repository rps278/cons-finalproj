pragma solidity ^0.5.0;
 
import "./Owned.sol";  
import "./PriceCalculatorLib.sol"; 

contract MarketPlace is Owned {


   /* Add a variable called skuCount to track the most recent sku # */
  uint public skuCount;
  uint public customerCount;
  uint public storeOwnerCount;
  uint public adminCount;
  uint public storeCount;

  enum State { 
    ForSale,
    Sold,
    Shipped,
    Received 
  }

  /* Create a struct named Item.
    Here, add a name, sku, price, state, seller, and buyer
    We've left you to figure out what the appropriate types are,
    if you need help you can ask around :)
  */
   struct Item{
     string name;
     uint sku;
     uint price;
     State state;
     address payable seller;
     address payable buyer;
   }

	struct StoreFront {
		uint storeNumber;
		mapping(uint => Item) itemsMap;	
	}	

	struct OrderItem {
		uint productKey;
		uint quantity;
		uint price;
	}

	struct StoreOwner {
		address storeOwnerAddress;
		uint storeOwnerKey;
		string firstName;
		string lastName;
		bool isActive;
	}

	struct Customer {
		address customerAddress;
		uint customerKey;
		string firstName;
		string lastName;
		bool isActive;
	}

	struct Admin {
		address adminAddress;
		uint adminKey;
		string firstName;
		string lastName;
		bool isActive;
	}
	


	// Collections that can be returned from functions
	address[] adminaddressArr;
	address[] customerAddressArr;
	address[] storeOwnerAdressArr;

	mapping (address => Customer) public customers;
	mapping (address => StoreOwner) public storeOwners;
	mapping (address => Admin) public admins;


	// Mapping of items
	mapping(uint => Item) public items;

	// Store Owner A --> (Struct) ,  Store Owner B --> (Struct)
	mapping (address => mapping(uint => StoreFront)) public ownerStoreFrontsMapMap;
	// Store Owner A --> [1,2,3] , Store Owner B --> [1,2,3]
	mapping (address => uint[]) public ownerStoreFrontIDsMapArr;
	// Store Owner A --> (count = 2) ,  Store Owner B --> (count = 5)
	mapping (address => uint) public ownerStoreFrontsCountMap;  




	event LogRegisteredAdmin(address accountAddress);
	event LogRegisteredCustomer(address accountAddress);
	event LogRegisteredStoreOwner(address accountAddress);
	event LogRegisteredStoreFront(address storeOwnerAddress, uint indexed storeNumber);

	event LogUnRegisteredAdmin(address accountAddress);
	event LogUnRegisteredCustomer(address accountAddress);
	event LogUnRegisteredStoreOwner(address accountAddress);
	event LogUnRegisteredStoreFront(address storeOwnerAddress, uint indexed storeNumber);


	// Events related to Buying/Selling of the products
	event ForSale(uint sku);
	event Sold(uint sku);
	event Shipped(uint sku);
	event Received(uint sku);


	modifier onlyAdmin{
		require(admins[msg.sender].isActive,"User Not Authorized. Only Admins can call this function");
		_;
	}

	modifier onlyCustomer{
		require(customers[msg.sender].isActive,"User Not Authorized. Only Customers can call this function");
		_;
	}

	modifier onlyStoreOwner{
		require(storeOwners[msg.sender].isActive,"User Not Authorized. Only StoreOwners can call this function");
		_;
	}

	modifier verifyCaller (address _address) { 
		require (msg.sender == _address);
		 _;
	}

    modifier paidEnough(uint _price) { 
    	require(msg.value >= _price); 
    	_;
    }

    modifier checkValue(uint _sku)  {
	    //refund them after pay for item (why it is before, _ checks for logic before func)
	    _;
	    uint _price = items[_sku].price;
	    uint amountToRefund = msg.value - _price;
	    items[_sku].buyer.transfer(amountToRefund);
  	}

	modifier forSale(uint sku) {
		require(items[sku].state == State.ForSale);
		_;
	}

	modifier sold(uint sku) {
		require(items[sku].state == State.Sold);
		_;
	}

	modifier shipped(uint sku) {
		require(items[sku].state == State.Shipped);
		_;
	}

	modifier received(uint sku) {
	require(items[sku].state == State.Received);
	_;
	}



	// Add Customer
	function registerCustomer(string memory firstName, string memory lastName) public returns (bool) {
		require(bytes(firstName).length > 0 && bytes(lastName).length > 0 ,"First Name or Last Name appears empty");
	    Customer memory custObj = Customer(msg.sender,1,firstName,lastName,true);
		customers[msg.sender] = custObj;
		customerAddressArr[customerCount] = msg.sender;
		customerCount++;
		emit LogRegisteredCustomer(msg.sender);
		return true;
	}


	function registerAdmin(string memory firstName, string memory lastName) public returns (bool) {
		require(bytes(firstName).length > 0 && bytes(lastName).length > 0 ,"First Name or Last Name appears empty");
	    Admin memory custObj = Admin(msg.sender,1,firstName,lastName,true);
		admins[msg.sender] = custObj;
		adminaddressArr[adminCount] = msg.sender;
		adminCount++;
		emit LogRegisteredAdmin(msg.sender);
		return true;
	}
	// Add StoreOwner , Set store front count to be 10 max 
  	function registerStoreOwner(string memory firstName, string memory lastName) public returns (bool){
  		require(bytes(firstName).length > 0 && bytes(lastName).length > 0 ,"First Name or Last Name appears empty");
  		StoreOwner memory storeOwnerObj = StoreOwner(msg.sender,1,firstName,lastName,true);
  		storeOwners[msg.sender] = storeOwnerObj;
  		storeOwnerAdressArr[storeOwnerCount] = msg.sender;
  		storeOwnerCount++;
  		emit LogRegisteredStoreOwner(msg.sender);
  		return true;
  	}

  	// Add StoreFront
 	function registerStoreFront() public onlyStoreOwner returns (bool){
 		StoreFront memory storeFrontObj = StoreFront(storeCount);
  		ownerStoreFrontsMapMap[msg.sender][ownerStoreFrontsCountMap[msg.sender]] = storeFrontObj;
  		ownerStoreFrontIDsMapArr[msg.sender][ownerStoreFrontsCountMap[msg.sender]] = ownerStoreFrontsCountMap[msg.sender];
  		ownerStoreFrontsCountMap[msg.sender] = ownerStoreFrontsCountMap[msg.sender] + 1; 
  		emit LogRegisteredStoreFront(msg.sender,storeCount);
  		storeCount++;
  		return true;
 	}

 	function unregisterCustomer() public onlyCustomer returns (bool){
 		customers[msg.sender].isActive = false;
 		emit LogUnRegisteredAdmin(msg.sender);
 		return true;
 	}

  	function unregisterStoreOwner() public onlyStoreOwner returns (bool){
  		storeOwners[msg.sender].isActive = false;
  		emit LogUnRegisteredStoreOwner(msg.sender);
  		return true;
  	}

  	function unregisterAdmin() public onlyAdmin returns (bool){
  		admins[msg.sender].isActive = false;
  		emit LogUnRegisteredAdmin(msg.sender);
  		return true;
  	}

  	function unregisterStoreFront(uint storeNumber) public onlyStoreOwner returns (bool){
  		emit LogUnRegisteredStoreFront(msg.sender, storeNumber);
  		return false;
  	}

	// Function to get list of customer addresses
	function getCustomers() public view returns (address[] memory) {
		return customerAddressArr;
	}

	function getCustomerInfo(address customeraddress) public view returns (string memory firstName, string memory lastName,bool isActive){
		return( customers[customeraddress].firstName, customers[customeraddress].lastName, customers[customeraddress].isActive);
	}
	// Function to get list of store owner addresses
	function getStoreOwners() public view returns (address[] memory) {
		return storeOwnerAdressArr;
	}
	// Function to get list info for a store owner
	function getStoreOwnerInfo(address storeowneraddress) public view returns (string memory firstName, string memory lastName,bool isActive){
		return( storeOwners[storeowneraddress].firstName, storeOwners[storeowneraddress].lastName, storeOwners[storeowneraddress].isActive);
	}

	function getAllStoreFrontsByOwner() public onlyStoreOwner onlyAdmin view returns (uint[] memory) {
		return ownerStoreFrontIDsMapArr[msg.sender];
	}

	function addItem(string memory _name, uint _price,uint storeNumber) public onlyStoreOwner returns(bool){
	    emit ForSale(skuCount);
	    StoreFront storage storeFrontObj= ownerStoreFrontsMapMap[msg.sender][storeNumber];
	    Item memory newItem = Item({name: _name, sku: skuCount, price: _price, state: State.ForSale, seller: msg.sender, buyer: address(0)}); 
	    items[skuCount] = newItem;
	    storeFrontObj.itemsMap[skuCount] = newItem;
	    skuCount = skuCount +1;
	    return true;
	}

	function buyItem(uint sku) public payable forSale(sku) paidEnough(items[sku].price) checkValue(sku)
	{
		    items[sku].buyer = msg.sender;
		    uint price_with_shipping = items[sku].price + PriceCalculatorLib.calculateShippingCharge(items[sku].price);
		    items[sku].seller.transfer(price_with_shipping); 
		    items[sku].state = State.Sold;
		    emit Sold(sku);
	}

	function shipItem(uint sku) public sold(sku) verifyCaller(items[sku].seller)
	{
		    items[sku].state = State.Shipped;
		    emit Shipped(sku);
	}

	function receiveItem(uint sku) public shipped(sku) verifyCaller(items[sku].buyer)
	{
		    items[sku].state = State.Received;
		    emit Received(sku);
	}
}

