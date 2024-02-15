# VirtualTokens

Allow to create virtual tokens for marketing. Any address own this token, so while transferring we just emit proper event 

## VirtualERC721

1. Set operator address who can transfer tokens
```Solidity
function setApprovalForAll(address operator, bool approved) public onlyOwner
```

2. Operator can transfer token to single receiver

```Solidity
function transferFrom(address from, address to, uint256 tokenId) public onlyOperator
```


3. Operator can transfer token to many receivers

```Solidity
function batchTransferFrom(address from, address[] calldata to, uint256 tokenId) public onlyOperator
```

