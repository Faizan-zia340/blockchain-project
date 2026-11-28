// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// STEP BY STEP: ERC721 (NFT) + Ownable + Pause / Freeze, ek hi file me
// Ye learning file hai - assignment wala FaizyToken alag hai.
// ERC20 me har token ek jaisa hota hai, 100 FAIZY = 100 FAIZY.
// ERC721 me har token UNIQUE hota hai, har NFT ka apna tokenId hota hai.
// Jaise har ghar ka apna address hota hai, har NFT ka apna tokenId hota hai.

interface IERC721Receiver {
    function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
}

contract LearnERC721 {
    // ============ 1. DATA ============
    string public name = "Faizy NFT";
    string public symbol = "FAIZY";
    uint256 public totalSupply;
    uint256 public nextTokenId = 1;
    address public owner;

    // Har tokenId ka malik kaun hai
    mapping(uint256 => address) private _owners;
    // Har address ke paas kitne NFT hain
    mapping(address => uint256) private _balances;
    // Ek NFT ke liye ek ko approve karo
    mapping(uint256 => address) private _tokenApprovals;
    // Sab NFT ke liye ek operator ko approve karo
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    // Har NFT ka link / metadata
    mapping(uint256 => string) private _tokenURIs;

    // Pause = poora NFT rok do, Freeze = ek account rok do
    bool public paused;
    mapping(address => bool) public frozen;

    // ============ 2. EVENTS ============
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Paused(address indexed account);
    event Unpaused(address indexed account);
    event Frozen(address indexed account);
    event Unfrozen(address indexed account);

    // ============ 3. ERROR / MODIFIER ============
    error NotOwner();
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    // ============ 4. CONSTRUCTOR ============
    constructor() {
        owner = msg.sender;
        paused = false;
    }

    // ============ 5. PAUSE / FREEZE - sirf owner ============
    function pause() public onlyOwner {
        paused = true;
        emit Paused(msg.sender);
    }
    function unpause() public onlyOwner {
        paused = false;
        emit Unpaused(msg.sender);
    }
    function freeze(address account) public onlyOwner {
        frozen[account] = true;
        emit Frozen(account);
    }
    function unfreeze(address account) public onlyOwner {
        frozen[account] = false;
        emit Unfrozen(account);
    }

    // ============ 6. ERC721 - READ (neele, free) ============
    function balanceOf(address owner_) public view returns (uint256) {
        require(owner_ != address(0), "Zero address");
        return _balances[owner_];
    }
    function ownerOf(uint256 tokenId) public view returns (address) {
        address tokenOwner = _owners[tokenId];
        require(tokenOwner != address(0), "Token does not exist");
        return tokenOwner;
    }
    function tokenURI(uint256 tokenId) public view returns (string memory) {
        require(_owners[tokenId] != address(0), "Token does not exist");
        return _tokenURIs[tokenId];
    }
    function getApproved(uint256 tokenId) public view returns (address) {
        require(_owners[tokenId] != address(0), "Token does not exist");
        return _tokenApprovals[tokenId];
    }
    function isApprovedForAll(address owner_, address operator) public view returns (bool) {
        return _operatorApprovals[owner_][operator];
    }

    // ============ 7. APPROVE ============
    // Ek NFT ke liye ek bande ko approve karo
    function approve(address to, uint256 tokenId) public {
        address tokenOwner = ownerOf(tokenId);
        require(msg.sender == tokenOwner || _operatorApprovals[tokenOwner][msg.sender], "Not owner or operator");
        _tokenApprovals[tokenId] = to;
        emit Approval(tokenOwner, to, tokenId);
    }
    // Sab NFT ke liye ek operator ko approve karo
    function setApprovalForAll(address operator, bool approved) public {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    // ============ 8. ANDAR WALA CHECK ============
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        address tokenOwner = ownerOf(tokenId);
        return (spender == tokenOwner ||
            _tokenApprovals[tokenId] == spender ||
            _operatorApprovals[tokenOwner][spender]);
    }
    function _checkTransfer(address from, address to, uint256 tokenId) internal view {
        require(!paused, "Token is paused");
        require(!frozen[from], "Sender is frozen");
        require(!frozen[to], "Receiver is frozen");
        require(ownerOf(tokenId) == from, "Not token owner");
        require(to != address(0), "Transfer to zero address");
    }
    function _transfer(address from, address to, uint256 tokenId) internal {
        delete _tokenApprovals[tokenId];
        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }

    // ============ 9. TRANSFER - OVERRIDE WALA HISSA ============
    // transferFrom: pehle approve check, phir pause/freeze check, phir transfer
    function transferFrom(address from, address to, uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Not approved or owner");
        _checkTransfer(from, to, tokenId);
        _transfer(from, to, tokenId);
    }
    // safeTransferFrom: transfer + check ke receiver NFT le sakta hai ya nahi
    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        safeTransferFrom(from, to, tokenId, "");
    }
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Not approved or owner");
        _checkTransfer(from, to, tokenId);
        _transfer(from, to, tokenId);
        require(_checkOnERC721Received(from, to, tokenId, data), "Not ERC721Receiver");
    }
    function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory data) internal returns (bool) {
        if (to.code.length == 0) {
            return true;
        }
        try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) returns (bytes4 retval) {
            return retval == IERC721Receiver.onERC721Received.selector;
        } catch {
            return false;
        }
    }

    // ============ 10. MINT / BURN ============
    // mint: sirf owner, har baar naya tokenId, 1, 2, 3...
    function mint(address to, string memory uri) public onlyOwner returns (uint256) {
        require(!paused, "Token is paused");
        require(!frozen[to], "Receiver is frozen");
        require(to != address(0), "Mint to zero address");
        uint256 tokenId = nextTokenId;
        nextTokenId += 1;
        totalSupply += 1;
        _owners[tokenId] = to;
        _balances[to] += 1;
        _tokenURIs[tokenId] = uri;
        emit Transfer(address(0), to, tokenId);
        return tokenId;
    }
    // burn: NFT khatam karo, sirf malik ya approved kar sakta hai
    function burn(uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "Not approved or owner");
        address tokenOwner = ownerOf(tokenId);
        delete _tokenApprovals[tokenId];
        _balances[tokenOwner] -= 1;
        totalSupply -= 1;
        delete _owners[tokenId];
        delete _tokenURIs[tokenId];
        emit Transfer(tokenOwner, address(0), tokenId);
    }

    // ============ 11. OWNABLE ============
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is zero address");
        address oldOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
    // WARNING: mat dabana, owner hamesha ke liye khatam ho jayega
    function renounceOwnership() public onlyOwner {
        address oldOwner = owner;
        owner = address(0);
        emit OwnershipTransferred(oldOwner, address(0));
    }
}
