// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface ILearnERC721 {
    function mint(address to, string memory uri) external returns (uint256);
}

// TokenToNFT — Kirdar shop.
// User 5 FAIZY de kar 1 NFT khareedta hai.
// Rate: 100 FAIZY = 0.001 ETH (1 ETH = 100,000 FAIZY).
contract TokenToNFT is Ownable {
    IERC20 public token;
    ILearnERC721 public nft;
    uint256 public constant NFT_PRICE = 5 * 10 ** 18; // 5 FAIZY
    uint256 public constant TOKENS_PER_ETH = 100000;

    event TokensBought(address indexed buyer, uint256 ethAmount, uint256 tokenAmount);
    event NFTBought(address indexed buyer, uint256 indexed tokenId);

    constructor(address _token, address _nft) Ownable(msg.sender) {
        token = IERC20(_token);
        nft = ILearnERC721(_nft);
    }

    // ETH de kar FAIZY khareedo
    function buyTokens() external payable {
        require(msg.value > 0, "Send ETH to buy tokens");
        uint256 amount = (msg.value * TOKENS_PER_ETH * 10 ** 18) / 1 ether;
        require(token.balanceOf(address(this)) >= amount, "Not enough tokens in shop");
        require(token.transfer(msg.sender, amount), "Token transfer failed");
        emit TokensBought(msg.sender, msg.value, amount);
    }

    // 5 FAIZY de kar 1 NFT khareedo (pehle approve karna hoga)
    function buyNFT(string memory uri) external {
        require(token.transferFrom(msg.sender, address(this), NFT_PRICE), "Token payment failed");
        uint256 tokenId = nft.mint(msg.sender, uri);
        emit NFTBought(msg.sender, tokenId);
    }

    // Shop mein phansa ETH nikalna (sirf owner)
    function withdrawETH() external onlyOwner {
        (bool success, ) = payable(owner()).call{value: address(this).balance}("");
        require(success, "ETH withdraw failed");
    }

    // Shop mein phanse FAIZY nikalna (sirf owner)
    function withdrawTokens() external onlyOwner {
        uint256 balance = token.balanceOf(address(this));
        require(token.transfer(owner(), balance), "Token withdraw failed");
    }
}
