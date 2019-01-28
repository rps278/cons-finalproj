pragma solidity ^0.5.0;

library PriceCalculatorLib {
	function calculateShippingCharge(uint price) public pure returns (uint shippingCharge)
	{
		if (price > 100 ) 
			return 20;
		else
			return 5; 
	}
}