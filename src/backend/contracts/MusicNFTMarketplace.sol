//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MusicNFTMarketplace is ERC721,Ownable{
    string public baseURI="https://bafybeidhjjbjonyqcahuzlpt7sznmh4xrlbspa3gstop5o47l6gsiaffee.ipfs.nftstorage.link/";

    constructor ()  ERC721("MusicNFTMarketplace", "NFM")
        Ownable(msg.sender) {}
}

// 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266