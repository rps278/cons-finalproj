App = {
  web3Provider: null,
  contracts: {},

  init: async function() {
    // Load pets.
    $.getJSON('../shoppingitems.json', function(data) {
      var petsRow = $('#petsRow');
      var petTemplate = $('#petTemplate');

      for (i = 0; i < data.length; i ++) {
        petTemplate.find('.panel-title').text(data[i].name);
        petTemplate.find('img').attr('src', data[i].picture);
        petTemplate.find('.pet-breed').text(data[i].breed);
        petTemplate.find('.pet-age').text(data[i].age);
        petTemplate.find('.pet-location').text(data[i].location);
        petTemplate.find('.pet-location').text(data[i].price);
        petTemplate.find('.btn-adopt').attr('data-id', data[i].id);
        petsRow.append(petTemplate.html());
      }
    });

    return await App.initWeb3();
  },

  initWeb3: async function() {

    if (window.ethereum) {
      console.log("initWeb3: Inside window.ethereum = true");
 
      App.web3Provider = window.ethereum;
      try {
        // Request account access
        await window.ethereum.enable();
      } catch (error) {
        // User denied account access...
        console.error("initWeb3: User denied account access")
      }
    }
    // Legacy dapp browsers...
    else if (window.web3) {
      console.log("initWeb3: Connecting to MetaMask");
      App.web3Provider = window.web3.currentProvider;
    }
    // If no injected web3 instance is detected, fall back to Ganache
    else {
      console.log("initWeb3: Connecting to test rpc @localhost:8545");
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:8545');
      console.log("initWeb3: Connected to test rpc @localhost:8545");
    }
    web3 = new Web3(App.web3Provider);
    return App.initMarketPlaceContract();
  },

  initMarketPlaceContract: function() {
     $.getJSON('MarketPlace.json', function(data) {
       console.log("initMarketPlaceContract: Post MarketPlace.json retreival");
        // Get the necessary contract artifact file and instantiate it with truffle-contract
        var MarketPlaceArtifact = data;

        console.log("initMarketPlaceContract: Start creating MarketPlace contract");
        App.contracts.MarketPlace = TruffleContract(MarketPlaceArtifact);
        console.log("initMarketPlaceContract: Finished creating MarketPlace contract");
        
        // Set the provider for our contract
        App.contracts.MarketPlace.setProvider(App.web3Provider);
        console.log("initMarketPlaceContract: Finished setting Web3 Provider");

      });
    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '.btn-adopt', App.handleBuy);
    $(document).on('click', '.btn-regCU', App.handleRegisterCustomer);
    $(document).on('click', '.btn-regSO', App.handleRegisterStoreOwner);
    $(document).on('click', '.btn-regSF', App.handleRegisterStoreFront);
    $(document).on('click', '.btn-regCUALL', App.getCustomers);
    $(document).on('click', '.btn-regSOALL', App.getStoreOwners);
  },

  getCustomers: function(){
     var marketplaceInstance;
     web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
      console.log("Successfully called getAccounts");
      var account = accounts[0];
      var _gasLimit = 100000000;
      App.contracts.MarketPlace.deployed().then(function(instance) {
        marketplaceInstance = instance;
        console.log("getCustomers:calling Solidity function getCustomers");
        return marketplaceInstance.getCustomers.call();
       }).then(function(customers){
           console.log("getCustomers:Successfully called Solidity function getCustomers");
           for(i=0; i< customers.length;i++)
            console.log("getCustomers: Listing customer Address:" + customers[i]);
       }).catch(function(err){
          console.log(err.message);
       });
   });

  },
  getStoreOwners: function(){
  },
  
  getStores: function(){
  },

  handleBuy: function(){
    event.preventDefault();
    var sku = parseInt($(event.target).data('id'));
    var marketplaceInstance;
     web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
      console.log("Successfully called getAccounts");
      var account = accounts[0];
      var _gasLimit = 100000000;
      App.contracts.MarketPlace.deployed().then(function(instance) {
        marketplaceInstance = instance;
        return marketplaceInstance.buyItem(sku,{from: account, gas:_gasLimit});
      }).then(function(sucess){

        });
    });

  },

  handleRegisterAdmin: function(event){
    var firstName = $('#fName').val();
    var lastName = $('#lName').val();
    console.log("firstName:" + firstName + " lastName:" + lastName);
    var marketplaceInstance;
     web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
      console.log("Successfully called getAccounts");
      var account = accounts[0];
      var _gasLimit = 100000000;
      App.contracts.MarketPlace.deployed().then(function(instance) {
        marketplaceInstance = instance;
        return marketplaceInstance.registerAdmin(firstName,lastName,{from: account, gas:_gasLimit});
      }).then(function(sucess){

        });
    });
  },

  handleRegisterCustomer: function(event){
    var firstName = $('#fName').val();
    var lastName = $('#lName').val();
    console.log("firstName:" + firstName + " lastName:" + lastName);
    var marketplaceInstance;
     web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
      console.log("Successfully called getAccounts");
      var account = accounts[0];
      var _gasLimit = 1000000;
      App.contracts.MarketPlace.deployed().then(function(instance) {
        marketplaceInstance = instance;
        return marketplaceInstance.registerCustomer(firstName,lastName,{from: account, gas:_gasLimit});
      }).then(function(error,sucess){

          console.log(error);
        });
    });
  },
  handleRegisterStoreOwner: function(event){
    var firstName = $('#fName').val();
    var lastName = $('#lName').val();
    console.log("firstName:" + firstName + " lastName:" + lastName);
    var _gasLimit = 1000000;
    var marketplaceInstance; 
     web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }
      console.log("Successfully called getAccounts");
      var account = accounts[0];
      App.contracts.MarketPlace.deployed().then(function(instance) {
        marketplaceInstance = instance;
        return marketplaceInstance.registerStoreOwner(firstName,lastName,{from: account,gas:_gasLimit});
      }).then(function(sucess){

        });
    });
     
  },
  handleRegisterStoreFront: function(event){
    var marketplaceInstance;
    var storeName = $('#fName').val();
    console.log("Store Name: " + storeName);
    var _gasLimit = 100000000;
          web3.eth.getAccounts(function(error, accounts) {
          if (error) {
                  console.log(error);
          }
          var account = accounts[0];
          App.contracts.MarketPlace.deployed().then(function(instance) {
              marketplaceInstance = instance;
              return marketplaceInstance.registerStoreFront(storeName,{from: account, gas:_gasLimit});
            }).then(function(sucess){

            });
        });
  },
  handleAdopt: function(event) {
    event.preventDefault();
    var petId = parseInt($(event.target).data('id'));
    var adoptionInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];

      App.contracts.Adoption.deployed().then(function(instance) {
        adoptionInstance = instance;

        // Execute adopt as a transaction by sending account
        return adoptionInstance.adopt(petId, {from: account});
      }).then(function(result) {
        return App.markAdopted();
      }).catch(function(err) {
        console.log(err.message);
      });
    });

  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
