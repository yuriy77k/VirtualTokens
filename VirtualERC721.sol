// SPDX-License-Identifier: No License (None)
pragma solidity 0.8.19;

abstract contract Ownable {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

contract VirtualERC721 is Ownable {
    // Token name
    string private _name;
    // Token symbol
    string private _symbol;
    string private _baseURI;
    uint256 private _balance = 1; 
    mapping (address => bool) public operators;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Initializes the contract by setting a `name` and a `symbol` and a `baseURI` to the token collection.
     */
    constructor(string memory name_, string memory symbol_, string memory baseURI_) {
        _name = name_;
        _symbol = symbol_;
        _baseURI = baseURI_;
    }

    modifier onlyOperator() {
        require(operators[msg.sender], "Not approved");
        _;
    }
    
    function balanceOf(address) public view returns (uint256) {
        return _balance;
    }

    function ownerOf(uint256) public view returns (address) {
        return msg.sender;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function tokenURI(uint256 tokenId) public view returns (string memory) {
        string memory baseURI = _baseURI;
        return bytes(baseURI).length > 0 ? string.concat(baseURI, toString(tokenId)) : "";
    }

    function setBaseURI(string memory baseURI_) external onlyOwner {
        _baseURI = baseURI_;
    }

    // set tokens balance for all users
    function setBalance(uint256 balance_) external onlyOwner {
        _balance = balance_;
    }


    function approve(address, uint256) public pure {
        revert ("not allowed");
    }

    // transfer token to many users
    function batchTransferFrom(address from, address[] calldata to, uint256 tokenId) public onlyOperator {
        uint256 len = to.length;
        for(uint i; i<len; i++)
            emit Transfer(from, to[i], tokenId);
    }

    function getApproved(uint256) public view returns (address) {
        return owner();
    }

    function setApprovalForAll(address operator, bool approved) public onlyOwner {
        operators[operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(address, address operator) public view returns (bool) {
        return operators[operator];
    }

    function transferFrom(address from, address to, uint256 tokenId) public onlyOperator {
        emit Transfer(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public {
        transferFrom(from, to, tokenId);
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory) public {
        transferFrom(from, to, tokenId);
    }


    function toString(uint256 value) internal pure returns (string memory) {
        unchecked {
            uint256 length = log10(value) + 1;
            string memory buffer = new string(length);
            uint256 ptr;
            /// @solidity memory-safe-assembly
            assembly {
                ptr := add(buffer, add(32, length))
            }
            while (true) {
                ptr--;
                /// @solidity memory-safe-assembly
                assembly {
                    mstore8(ptr, byte(mod(value, 10), "0123456789"))
                }
                value /= 10;
                if (value == 0) break;
            }
            return buffer;
        }
    }

    function log10(uint256 value) internal pure returns (uint256) {
        uint256 result = 0;
        unchecked {
            if (value >= 10 ** 64) {
                value /= 10 ** 64;
                result += 64;
            }
            if (value >= 10 ** 32) {
                value /= 10 ** 32;
                result += 32;
            }
            if (value >= 10 ** 16) {
                value /= 10 ** 16;
                result += 16;
            }
            if (value >= 10 ** 8) {
                value /= 10 ** 8;
                result += 8;
            }
            if (value >= 10 ** 4) {
                value /= 10 ** 4;
                result += 4;
            }
            if (value >= 10 ** 2) {
                value /= 10 ** 2;
                result += 2;
            }
            if (value >= 10 ** 1) {
                result += 1;
            }
        }
        return result;
    }
}