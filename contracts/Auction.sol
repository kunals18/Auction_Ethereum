pragma solidity 0.5.0;

contract Auction {
    
    address payable private owner; 
    string title;
    uint startPrice;
    string description;

    enum State{Default, Running, Finalized}
    State public auctionState;

    uint public highestPrice;
    address payable public highestBidder;
    mapping(address => uint) public bids;

    constructor(
        address payable _owner,
        string memory _title,
        uint _startPrice,
        string memory _description
        
        ) public {
        owner = _owner;
        title = _title;
        startPrice = _startPrice;
        description = _description;
        auctionState = State.Running;
    }
    
    modifier notOwner(){
        require(msg.sender != owner);
        _;
    }
    
    function placeBid() public payable notOwner returns(bool) {
        require(auctionState == State.Running);
        require(msg.value > 0);
        // update the current bid
        uint currentBid = bids[msg.sender] + msg.value;
        require(currentBid > highestPrice);
        bids[msg.sender] = currentBid;
        //give back price to last highest
        address payable beneficiary;
        uint val;
        beneficiary = highestBidder;
        val = highestPrice;
        beneficiary.transfer(val);
        // update the highest price
        highestPrice = currentBid;
        highestBidder = msg.sender;
        
        return true;
    }
    
    function finalizeAuction() public{
        //only owner can finalize the auction.
        require(msg.sender == owner || bids[msg.sender] > 0);
        
        address payable recipiant;
        uint value;
        
        // owner can get highest price
        if(msg.sender == owner){
            recipiant = owner;
            value = highestPrice;
        }
        // highest bidder gets zero price
        else if (msg.sender == highestBidder){
            recipiant = highestBidder;
            value = 0;
        }
        // rest of bidders get back there money 
        else {
            recipiant = msg.sender;
            value = bids[msg.sender];
        }
        // initialize the value
        bids[msg.sender] = 0;
        recipiant.transfer(value);
        auctionState = State.Finalized;
    }   
    
    function returnContents() public view returns(        
        string memory,
        uint,
	    uint,
        string memory,
        State
        ) {
        return (
            title,
            startPrice,
	        highestPrice,
            description,
            auctionState
        );
    }
    
}
