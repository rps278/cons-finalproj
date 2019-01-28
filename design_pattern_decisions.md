The project was created in Truffle using the Pet Shop tutorial as a starting point.
The contract design consists of 3 primary files 
1. Owned.sol - This contract forms the base contract which allows us to generically set the owner for any contacts that derive from it. Since setting a owner is a common feature it is put ihisn this base class
2. PriceCalculatorLib.sol - This contract is a Library contract and serves the purpose of provide sales related calculations. Currently only one function exist which calculates the shipping charge based on price of the item.
3. MarketPlace.sol -- This is the key contract containing all the main functions of the Market Place
	- I have used the functions from the SupplyChain.sol to handle the buying and selling of items.
	- I have created my own functions for registering and unregistering of customers, storeowners , stores

Structures in MarketPlace.sol

1. Firstly created count variables to hold the key counts for the various entity lists like custome rs,storeowners,items and stores.
2. Structs for Customer and StoreOwner allow to store information like firstName and LastName . Additionally an Active flag is added which can be toggled when the customer/storeowner decides to unregister. This reduces the complexity associated with constantly changing the collection size when customers/storeowners join and leave .

3. We use both the address array and mapping structure to store the list of customers and storeowners. The address array is used for quick loop of addresses, while the mapping is used to store more elaborate information in the form of a struct mapped to the address 

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

4. Function modifiers like onlyStoreOwner, onlyCustomer have been used to control which functions can be called by customers , storeOwners, administrators. These modifiers take the msg.sender and lookup the address in the list to see if there is a match for a customer or storeOwner (depending on the function modifier) and if there is a match allows the function to run. 

5. Function modifiers also introduced in the buying and selling of items.  The forSale , sold and shipped modifiers are used to allow certain functions to be performed depending on the state of the item (sku) in question . This allows for orderly transition of the state of the Item depending on the workflow decided.

6. Sanity Checks on names and  numbers- Using the require statement , I have checked for names and numbers to make sure they are not negative.
 or of zero length

7. User Interface:  I could not complete this piece . 
	I was able to connect to the local testrpc node on  localhost:t8545 and used it and instantiate a deployed contract. Also able to successfully call getCustomers() mthod on the smart contract.
	I was able to setup registration functions for customers and storeowners.


8. Testing : For testing the smart contracts I created tests in solidity and javascript . However the function calls kept failing with EVM execution failure. The variable tests however worked.