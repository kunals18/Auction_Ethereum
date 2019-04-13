pragma solidity 0.5.0;

import "./Auction.sol";

contract AuctionBox{
    Auction[] public auctions; 
   
    function createAuction (
        string memory _title,
        uint _startPrice,	
        string memory _description
        ) public{
        require(_startPrice > 0);
        // create new auction
        Auction newAuction = new Auction(msg.sender, _title, _startPrice, _description);
        auctions.push(newAuction);
    }
    
    function returnAllAuctions() public view returns(Auction[] memory){
        return auctions;
    }
}
