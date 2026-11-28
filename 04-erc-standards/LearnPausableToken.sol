// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// STEP BY STEP: ERC20 + Ownable + Pause / Freeze, ek hi file me
// Ye learning file hai - assignment wala FaizyToken alag hai.
// Pause = poora token rok do, koi transfer nahi kar sakta.
// Freeze = sirf ek account rok do, baaki sab transfer kar sakte hain.

contract LearnPausableToken {
    // ============ 1. DATA (state variables) ============
    string public name = "Faizy Token";
    string public symbol = "FAIZY";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public owner;

    // Pause: ek bool, poore token ke liye
    bool public paused;
    // Freeze: har account ke liye alag bool
    mapping(address => bool) public frozen;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // ============ 2. EVENTS ============
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Paused(address indexed account);
    event Unpaused(address indexed account);
    event Frozen(address indexed account);
    event Unfrozen(address indexed account);

    // ============ 3. ERROR ============
    error NotOwner();

    // ============ 4. MODIFIERS ============
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    // ============ 5. CONSTRUCTOR ============
    constructor() {
        owner = msg.sender;
        paused = false;
        // Supply 0 hai - mint alag se karna hai
    }

    // ============ 6. PAUSE / UNPAUSE - sirf owner ============
    // pause: poora token rok do
    function pause() public onlyOwner {
        paused = true;
        emit Paused(msg.sender);
    }

    // unpause: poora token dobara chalu karo
    function unpause() public onlyOwner {
        paused = false;
        emit Unpaused(msg.sender);
    }

    // ============ 7. FREEZE / UNFREEZE - sirf owner ============
    // freeze: ek account rok do
    function freeze(address account) public onlyOwner {
        frozen[account] = true;
        emit Frozen(account);
    }

    // unfreeze: us account ko dobara chalu karo
    function unfreeze(address account) public onlyOwner {
        frozen[account] = false;
        emit Unfrozen(account);
    }

    // ============ 8. ANDAR WALA CHECK ============
    // Har transfer se pehle ye check chalega
    function _checkNotPausedOrFrozen(address from, address to) internal view {
        require(!paused, "Token is paused");
        require(!frozen[from], "Sender is frozen");
        require(!frozen[to], "Receiver is frozen");
    }

    // ============ 9. ERC20 - WRITE ============
    // transfer ko override kiya hai - pehle pause/freeze check, phir balance change
    function transfer(address to, uint256 amount) public returns (bool) {
        _checkNotPausedOrFrozen(msg.sender, to);
        require(balanceOf[msg.sender] >= amount, "Not enough balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // transferFrom me bhi wahi check lagta hai
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        _checkNotPausedOrFrozen(from, to);
        require(balanceOf[from] >= amount, "Not enough balance");
        require(allowance[from][msg.sender] >= amount, "Not allowed");
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    // ============ 10. MINT / BURN - pause me mint bhi nahi hoga ============
    function mint(address to, uint256 amount) public onlyOwner {
        require(!paused, "Token is paused");
        require(!frozen[to], "Receiver is frozen");
        totalSupply += amount;
        balanceOf[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    function burn(uint256 amount) public {
        require(!paused, "Token is paused");
        require(balanceOf[msg.sender] >= amount, "Not enough balance");
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    // ============ 11. OWNABLE - WRITE ============
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
