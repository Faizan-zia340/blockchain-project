// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// STEP BY STEP: ERC20 + Ownable, dono ek hi file me
// Ye learning file hai - har function ka code yahan likha hai,
// taake tum dekh sako ke andar kya ho raha hai.
// Assignment wala FaizyToken OpenZeppelin use karta hai,
// ye wala usi ka manual version hai, samajhne ke liye.

contract LearnERC20Ownable {
    // ============ 1. DATA (state variables) ============
    string public name = "Faizy Token";
    string public symbol = "FAIZY";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public owner;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // ============ 2. EVENTS ============
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // ============ 3. ERROR (Ownable jaisa) ============
    error NotOwner();

    // ============ 4. MODIFIER (Ownable) ============
    // Sirf owner hi aage ja sakta hai, warna revert
    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    // ============ 5. CONSTRUCTOR ============
    // Deploy ke waqt ek dafa chalta hai, deployer owner ban jata hai
    constructor() {
        owner = msg.sender;
        // Supply 0 hai - mint alag se karna hai, jaise FaizyToken me hai
    }

    // ============ 6. ERC20 - READ (view, neele) ============
    // balanceOf aur allowance upar public mapping se auto milte hain
    // totalSupply, name, symbol, decimals, owner bhi public se auto milte hain

    // ============ 7. ERC20 - WRITE (orange) ============
    // transfer: apne token doosre ko bhejo
    function transfer(address to, uint256 amount) public returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Not enough balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    // approve: doosre ko ijazat do ke wo tumhare naam par kharch kar sake
    function approve(address spender, uint256 amount) public returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // transferFrom: jis ko approve mila hai, wo transfer kare
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(balanceOf[from] >= amount, "Not enough balance");
        require(allowance[from][msg.sender] >= amount, "Not allowed");
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        emit Transfer(from, to, amount);
        return true;
    }

    // ============ 8. MINT - sirf owner (Ownable) ============
    function mint(address to, uint256 amount) public onlyOwner {
        totalSupply += amount;
        balanceOf[to] += amount;
        emit Transfer(address(0), to, amount);
    }

    // ============ 9. BURN - apne token khatam karo ============
    function burn(uint256 amount) public {
        require(balanceOf[msg.sender] >= amount, "Not enough balance");
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }

    // ============ 10. OWNABLE - WRITE ============
    // owner badlo - sirf owner kar sakta hai
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is zero address");
        address oldOwner = owner;
        owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    // owner khatam karo - WARNING: phir kabhi mint nahi hoga, test me mat dabana
    function renounceOwnership() public onlyOwner {
        address oldOwner = owner;
        owner = address(0);
        emit OwnershipTransferred(oldOwner, address(0));
    }
}
