<template>
  <div class="container">
    <div class="b-row">
      <div>
        <h1 style="background-color: #0000CD; color: white;">
          CS731: BLOCKCHAIN PROJECT
        </h1>
        <hr>
        <h3>
          Create Auction No: 
          <span>{{ amount }}</span>
        </h3>
        <hr>
        <div>
          <label for="title">
            Title
          </label>
          <b-form-input
            id="title"
            v-model="title"
            type="text"
            placeholder="title"
          />
        </div>
        <div>
          <label for="startPrice">
            Start Price
          </label>
          <b-form-input
            id="startPrice"
            v-model="startPrice"
            type="text"
            placeholder="start price ETH"
          />
        </div>
      </div>
    </div>
    <div class="b-row">
      <div>
        <label for="Description">
          Description
        </label>
        <br>
        <b-form-textarea
          id="Description"
          v-model="description"
          rows="5"
        />
      </div>
    </div>
    <hr>
    <div class="b-row">
      <div>
        <b-button block
          :variant="'primary'"
          @click="createAuction"
        >
          {{ createStatus }}
        </b-button>
        <img
          v-show="isLoad"
          src="https://media.giphy.com/media/2A6xoqXc9qML9gzBUE/giphy.gif"
        >
      </div>
    </div>
    <div v-show="isShow">
      <hr>
      <div v-for="(auctionCard,i) in auctionCards">
      <b-card-group
        columns
        class="mb-3"
      >
        <b-card
          :title="auctionCard[0]"
          tag="article"
          style="max-width: 20rem; background-color: rgba(0,0,255,.1);"
          class="mb-2"
        >
        <b-card-text style="color: grey">
        Start Price: {{auctionCard[1]}} ETH
        <br>
        Description: {{ auctionCard[3]}}
        </b-card-text>
          <hr>
          <p class="card-text, mt-3">
            {{ auctionCardDev[2] }}
          </p>
          <p class="card-text, mt-3">
            Bidders: {{ bidders[i] }}
          </p>
          <div>
            <form @submit.prevent="handleSubmit(auctionCard)">
              <b-input-group>
                <b-form-input
                  v-model="bidPrice[i]"
                />
                <b-input-group-append>
                  <button>Place BID</button>
                  
                </b-input-group-append>
              </b-input-group>
            </form>
          </div>
          <b-button
            class="mt-3"
            variant="outline-success"
            @click="handleFinalize(auctionCard)"
          >
            {{ finalizeStatus[i] }}
          </b-button>
        </b-card>
      </b-card-group>
      </div>
    </div>
  </div>
</template>

<script>
import web3 from '../contracts/web3';
import auction from '../contracts/auctionInstance';
import auctionBox from '../contracts/auctionBoxInstance';
let auction1=[];
export default {
  name: 'APP',
  data() {
    return {
      title: '',
      startPrice: '',
      highestPrice: '',
      description: '',
      amount: 0,
      auctionCards: [],
      auctionCardDev: [],
      isShow: false,
      isLoad: false,
      isBid: false,
      isFin: false,
      bidPrice: [],
      auctionAddress: '',
      bidders: [],
      finalizeStatus: [],
      createStatus: 'CREATE AUCTION',
      auctionlists:[],
      auctionIndexs:[],
    };
  },
  beforeMount() {
    // get auctionBox method: returnAllAuctions()
    auctionBox.methods
      .returnAllAuctions()
      .call()
      .then((auctions) => {
        console.log(auctions);
        // set the amount of auctions
        this.amount = auctions.length;
        
    });
  },
  methods: {
    createAuction() {
      // get accounts
      web3.eth.getAccounts().then((accounts) => {
        // convert 'ether' to 'wei'
        const startPrice = web3.utils.toWei(this.startPrice, 'ether');
        // createAuction in AuctionBox contract
        this.isLoad = true;
        return auctionBox.methods.createAuction(this.title, startPrice, this.description)
          .send({ from: accounts[0] });
      }).then(() => {
        // initialize forms
        this.isLoad = false;
        this.title = '';
        this.startPrice = '';
        this.highestPrice = '';
        this.description = '';
        // get the previous auction
        return auctionBox.methods.returnAllAuctions().call();
      }).then((auctions) => {
        const index = auctions.length - 1;
        this.auctionIndexs.push(index);
        auction1 = auctions.slice();
        console.log(auctions[index]);
        // get the contract address of the previous auction
        this.auctionAddress = auctions[index];
        // set the address as the parameter
        const auctionInstance = auction(auctions[index]);
        return auctionInstance.methods.returnContents().call();
      })
        .then((lists) => {
          console.log("This is the list");
          console.log(lists);
          this.auctionlists.push(lists);this.bidders.push(0);this.finalizeStatus.push("Finalize Now");
          this.bidPrice.push("");
                    // convert 'wei' to 'ether'
          for(let i in this.auctionlists){
            this.auctionlists[i][1] = web3.utils.fromWei(this.auctionlists[i][1], 'ether');
          }

          
          this.auctionCards = this.auctionlists;
          // show up the auction at the bottom of the page
          this.isShow = true;
          this.amount += 1;
        })
        .catch((err) => {
          console.log(err);
        });
    },
    handleSubmit(e) {
      // convert 'ether' to 'wei'
      const bidPriceWei = web3.utils.toWei(this.bidPrice[this.auctionlists.indexOf(e)], 'ether');
      // get the wallet adddress
      const fromAddress = web3.eth.accounts.givenProvider.selectedAddress;
      // set the address as the parameter
      console.log("Index");
      console.log(this.auctionlists.indexOf(e));
      console.log(this.auctionIndexs);
      
      const selectedAuction = auction(auction1[this.auctionIndexs[this.auctionlists.indexOf(e)]]);
      this.isBid = true;
      // placeBid in Auction contract
      selectedAuction.methods
        .placeBid()
        .send({
          from: fromAddress,
          value: bidPriceWei,
        })
        .then(() => {
          this.isBid = false;
          // increase the number of bidders
          this.bidders[this.auctionlists.indexOf(e)] += 1;
          this.bidPrice[this.auctionlists.indexOf(e)] = '';
        });
    },
    handleFinalize(e) {
      // get accounts
      web3.eth.getAccounts().then((accounts) => {
        // set the address as the parameter
        const selectedAuction = auction(auction1[this.auctionIndexs[this.auctionlists.indexOf(e)]]);
        this.isFin = true;
        // finalizeAuction in Auction contract
        selectedAuction.methods
          .finalizeAuction()
          .send({ from: accounts[0] })
          .then(() => {
            this.isFin = false;
            this.finalizeStatus[this.auctionlists.indexOf(e)] = 'Finalized';
          });
      });
    },
  },
};
</script>

<style>
#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}

h1{
  text-align:center;
  color: #0000CD;
}

ul {
  list-style-type: none;
  padding: 0;
}

li {
  display: inline-block;
  margin: 0 10px;
}

a {
  color: #42b983;
}

button {
  background-color: #008cba;
  color: white;
}

button:hover {
  background-color: white; /* Green */
  color: #008cba;
  border: #008cba 3px solid;
}

img {
  width: 32px;
}

#isBid, #isFin {
  height: 32px;
  margin-top: 16px;
  margin-left: 8px;
}

</style>
