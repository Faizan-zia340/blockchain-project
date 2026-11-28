// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// ProjectToken — har project ka apna ERC20 token
contract ProjectToken is ERC20, Ownable {
    constructor(string memory name, string memory symbol, uint256 supply) ERC20(name, symbol) Ownable(msg.sender) {
        _mint(msg.sender, supply * 10 ** decimals());
    }

    function decimals() public pure override returns (uint8) {
        return 18;
    }
}

// ProjectNFT — har project ka apna ERC721 NFT (sirf shop mint kar sakta hai)
contract ProjectNFT is ERC721, Ownable {
    uint256 private _tokenIdCounter;

    constructor(string memory name, string memory symbol) ERC721(name, symbol) Ownable(msg.sender) {}

    function mint(address to) external onlyOwner returns (uint256) {
        uint256 tokenId = _tokenIdCounter;
        _tokenIdCounter += 1;
        _safeMint(to, tokenId);
        return tokenId;
    }

    function totalSupply() external view returns (uint256) {
        return _tokenIdCounter;
    }
}

// ProjectShop — token se NFT khareedne ki dukaan
contract ProjectShop is Ownable {
    IERC20 public token;
    ProjectNFT public nft;
    uint256 public nftPrice;
    uint256 public constant TOKENS_PER_ETH = 100000;

    event TokensBought(address indexed buyer, uint256 ethAmount, uint256 tokenAmount);
    event NFTBought(address indexed buyer, uint256 indexed tokenId);

    constructor(address _token, address _nft, uint256 _nftPrice) Ownable(msg.sender) {
        token = IERC20(_token);
        nft = ProjectNFT(_nft);
        nftPrice = _nftPrice * 10 ** 18;
    }

    function buyTokens() external payable {
        require(msg.value > 0, "Send ETH to buy tokens");
        uint256 amount = (msg.value * TOKENS_PER_ETH * 10 ** 18) / 1 ether;
        require(token.balanceOf(address(this)) >= amount, "Not enough tokens in shop");
        require(token.transfer(msg.sender, amount), "Token transfer failed");
        emit TokensBought(msg.sender, msg.value, amount);
    }

    function buyNFT() external {
        require(token.transferFrom(msg.sender, address(this), nftPrice), "Token payment failed");
        uint256 tokenId = nft.mint(msg.sender);
        emit NFTBought(msg.sender, tokenId);
    }
}

// KirdarFactory — aik call mein poora project (token + NFT + shop) bana deta hai
contract KirdarFactory {
    struct ProjectParams {
        string tokenName;
        string tokenSymbol;
        uint8 tokenDecimals;
        uint256 tokenSupply;
        uint256 shopStock;
        string nftName;
        string nftSymbol;
        uint256 maxNFTs;
        uint256 nftPrice;
        uint256 placeholder;
    }

    event ProjectCreated(uint256 indexed index, address token, address nft, address shop, address creator);

    address[] public projects;

    function createProject(ProjectParams memory params) external returns (address token, address nft, address shop) {
        // Token banao — supply factory ko milti hai
        ProjectToken projectToken = new ProjectToken(params.tokenName, params.tokenSymbol, params.tokenSupply);
        // NFT banao
        ProjectNFT projectNFT = new ProjectNFT(params.nftName, params.nftSymbol);
        // Shop banao
        ProjectShop projectShop = new ProjectShop(address(projectToken), address(projectNFT), params.nftPrice);

        // Shop ko stock do, baaki creator ko
        uint256 shopAmount = params.shopStock * 10 ** 18;
        uint256 creatorAmount = params.tokenSupply * 10 ** 18 - shopAmount;
        require(projectToken.transfer(address(projectShop), shopAmount), "Shop stock transfer failed");
        require(projectToken.transfer(msg.sender, creatorAmount), "Creator transfer failed");

        // NFT ownership shop ko, token + shop ownership creator ko
        projectNFT.transferOwnership(address(projectShop));
        projectToken.transferOwnership(msg.sender);
        projectShop.transferOwnership(msg.sender);

        uint256 index = projects.length;
        projects.push(address(projectShop));
        emit ProjectCreated(index, address(projectToken), address(projectNFT), address(projectShop), msg.sender);

        return (address(projectToken), address(projectNFT), address(projectShop));
    }

    function getProjectCount() external view returns (uint256) {
        return projects.length;
    }
}
