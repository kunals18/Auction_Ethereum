var auctionbox = artifacts.require("./AuctionBox.sol");
var auction = artifacts.require("./Auction.sol");
module.exports = function(deployer) {
  deployer.deploy(auctionbox);
  //deployer.deploy(auction, "Ultra Auction NFT", "UANFT");
};
