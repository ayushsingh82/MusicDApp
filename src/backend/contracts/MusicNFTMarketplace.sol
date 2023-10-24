//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MusicNFTMarketplace is ERC721,Ownable{
       constructor ()  ERC721("MusicNFTMarketplace", "NFM")
        Ownable(msg.sender) {}

    string public baseURI="https://bafybeidhjjbjonyqcahuzlpt7sznmh4xrlbspa3gstop5o47l6gsiaffee.ipfs.nftstorage.link/";
    string public baseExtension=".json";
    address public artist;
    uint256 public royaltyFee;

    struct MarketItem{
        uint256 tokenId;
        address payable seller;
        uint256 price;
    }

    MarketItem[] public marketItems;

    event MarketItemBought(
        uint256 indexed tokenId,
        address indexed seller,
        address buyer,
        uint256 price
    ); 
  
   constructor(
    uint256 _royaltyFee,
    address artist,
    uint256[] memory _pirces
   ) payable{
    require(_prices.length+_royaltyFee<=msg.value,
    "Deployer must pay royalty fee for each token listed on the marketplace");
    royaltyFee=_royaltyFee;
    artist=_artist;
    for(uint8 i=0;i<_pirces.length;i++){
        require(_prices[i]>0,"Price must be greater than zero");
        _mint(address(this),i);
        marketItems.push(MarketItem(i,payable(msg.sender),_prices[i]));  
    }
   }


//only owner can update the royalty fee
   function updateRoyaltyFee(uint256 _royaltyFee) external onlyOwner{
    royaltyFee=_royaltyFee;
   }

   function buyToken(uint256 _tokenId) external payable{
    uint256 price=marketItems[_tokenId].price;
    address seller=marketItems[_tokenId].seller;
    require(
        msg.value==price,"Please sed the asking price"
    );
    marketItems[_tokenId].seller=payabe(address(0));
    _transfer(address(this),msg.sender,_tokenId);
    payable(artist).transfer(royaltyFee);
     payable(seller).transfer(msg.value);
     emit MarketItemBought(_tokenId, seller, msg.sender, price);
   }


   //allow someone to resell their music nft
   function resellToken(uint256 _tokenId,uint256 _price) external payable{
    require(msg.value==royaltyFee,"Must pay royalty fee");
    require(_price>0,"price should be greater than zero");
   marketItems[_tokenId].price=_price;
   marketItems[_tokenId].seller=payable(msg.sender);

   _transfer((msg.sender,address(this),_tokenId));
   emit MarketItemRelisted(_tokenId,_price);
   }

   //fetches all the token currently listed for sale
   function  getAllUnsoldTokens() external view returns (MarketItem[] memory){
    uint256 unsoldCount=balanceOf(address(this));
    MarketItem[] memory tokens=new MarketItem[](unsoldCount);
    uint256 currentIndex;
    for(uint256 i=0;i<marketItems.length;i++){
        if(marketItems[i].seller!=address(0)){
            tokens[currentIndex]=marketItems[i];
            currentIndex++;
        }
    }
    return (tokens);
   }

   function getMyTokens() external view returns (MarketItem[] memory){
     uint256 myTokenCount=balanceOf(msg.sender);
     MarketItem[] memory tokens=new MarketItem[](myTokenCount);
     uint256 currentIndex;
     for(uint256 i=0;i<marketItems.length;i++){
        if(ownerOf(i)==msg.sender){
            tokens[currentIndex]=marketItems[i];
            currentIndex++;
        }
     }
     return (tokens);
   }

  //   /* Internal function that gets the baseURI initialized in the constructor */
   function _baseURI() internal view virtual override returns(string memory){
    return baseURI;
   }
}

// 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266