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

### Deployed
- https://bscscan.com/address/0x984260c2325d050d481eba75348e4832b7a60775
- https://etherscan.io/address/0x74829afd42842f4103d00c35453d19b1c2ede811
