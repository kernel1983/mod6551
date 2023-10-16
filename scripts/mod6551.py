
from brownie import ERC20, WalletNFT, accounts

def main():
    ERC20.deploy({'from': accounts[0]})
    ERC20[0].init(1000000, 'U', 0, 'U', {'from': accounts[0]})
    #ERC721.deploy("Test NFT", "NFT", {'from': accounts[0]})
    #ERC721[0].mint(accounts[1], 1)
    WalletNFT.deploy({'from': accounts[0]})
    WalletNFT[0].mint(1, {'from': accounts[1]})
    WalletNFT[0].mint(2, {'from': accounts[2]})
    print(WalletNFT[0].addrs(accounts[2]))

    #ERC20[0].transfer(ERC721[0], 200, 0, 1, {'from': accounts[0]})
    #     from:a[0]     with wallet  value a[0] to_tokenid
    ERC20[0].transfer(WalletNFT[0], 200, 0, 1, {'from': accounts[0]})
    #print('NFT balance', ERC20[0].balanceOf(ERC721[0], 1))
    print('NFT balance', ERC20[0].balanceOf(WalletNFT[0], 1))
    print('Owner balance', ERC20[0].balanceOf(accounts[0]))

    #ERC20[0].erc20_transfer(ERC721[0], 200, 0, 1, {'from': accounts[1]})
    #     from:a[1]        token contract    to:a[0]   value  from_tokenid  to:a[0] tokenid 0
    WalletNFT[0].erc20_transfer(ERC20[0], accounts[0], 200, 1, 0, {'from': accounts[1]})
    print('NFT balance', ERC20[0].balanceOf(WalletNFT[0], 1))
    print('Owner balance', ERC20[0].balanceOf(accounts[0]))


    ERC20[0].approve(WalletNFT[0], 300, 0, 2, {'from': accounts[0]})
    WalletNFT[0].erc20_transferFrom(ERC20[0], accounts[0], WalletNFT[0], 300, 0, 2, {'from': accounts[1]})
    print('NFT balance', ERC20[0].balanceOf(WalletNFT[0], 2))
    print('Owner balance', ERC20[0].balanceOf(accounts[0]))

    #     from:a[1]        token contract    to:a[0]   value  from_tokenid  to:a[0] tokenid 0
    WalletNFT[0].erc20_transfer(ERC20[0], accounts[0], 200, 2, 0, {'from': accounts[2]})
    print('NFT balance', ERC20[0].balanceOf(WalletNFT[0], 2))
    print('Owner balance', ERC20[0].balanceOf(accounts[0]))
