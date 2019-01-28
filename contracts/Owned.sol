pragma solidity ^0.5.0;

contract Owned{

	// Market Place Admin - who is the creator of this contract
	address owner;
	
	constructor() public {
		owner = msg.sender;
	}

	modifier onlyOwner{
		require(owner == msg.sender,"User Not Authorized.Only Contract Owner can make this call");
		_;
	}

	/*
	// ShoppingCart Functions 
	function addToShoppingCart(uint productkey, uint quantity, uint price) external returns (bool);
	function removeFromShoppingCart(int productkey, uint quantity) external returns (bool);
	function getShoppingCartItems() external view returns (bool);
	function getTotalShoppingCartValue() external view returns (uint);

	// Customer, StoreOwner , StoreFront Registration Functions
	function registerCustomer(uint customerKey, string memory firstName, string memory lastName) public returns (bool);
  	function registerStoreOwner(uint storeOwnerKey, string calldata firstName, string calldata lastName) external returns (bool);
 	function registerStoreFront(uint storeFrontKey, string calldata storeName) external returns (bool);
 	function unregisterCustomer(address customerAddress) external returns (bool);
  	function unregisterStoreOwner(address storeOwnerAddress) external returns (bool);
  	function unregisterStoreFront(address storeFrontAddress) external returns (bool);

  	// Inventory Functions
	function addToInventory(uint productKey, string calldata productName, string calldata productClass, uint quantity , uint costPerUnit, address supplierAddress) external returns (bool);
	function removeFromInventory(uint productKey, uint quantity) external returns (bool);
	function getAllProducts() external view returns (bool);
	function getTotalInventoryCost() external returns (uint);
	*/
}