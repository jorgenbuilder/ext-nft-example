# Hands-on with EXT NFT 💎🖐️

A simple NFT implementation using [Toniq Labs' EXT token standard](https://github.com/Toniq-Labs/extendable-token/). <-- Make sure to check it out to get all the details. Be aware, to make this a more useable demonstration, we omit the access control you'd want in a real implementation.

*Note: EXT is an evolving standard, and not the only one around in the community!*

**Now, try it out 🧐!**    

1. Run `mintNFT` 🌿: Punch in any old principal to mint an NFT under that principal's ownership. (Example principal: `bhvmm-kkp5p-pzycc-apxyy-26mff-zazxc-gyotq-dlvtq-ilprx-g47sw-zae`.)
2. Run `readLedger` 📜: There's your NFT!
3. Run `transfer` 💰: You can use this data for the parameters, or come up with your own:
    - to: (principal) azv7s-jmrxi-gq23o-pcf2z-flpmo-3etck-tciq3-3qo3m-t7phq-4bfdi-lae
    - from: (principal) bhvmm-kkp5p-pzycc-apxyy-26mff-zazxc-gyotq-dlvtq-ilprx-g47sw-zae
    - token: use your canister id! (If you're in the playground, it will be at the top of your candid UI after you deploy)
    - notify: false
    - amount: 1

In EXT, tokens have a globally unique, hex encoded uuid based on the following structure: `\x0Atid` `{domain seperator}{canister id}{token index}`.

Now you have the primitive capabilities of an NFT under your superhero belt 🐱‍🏍! Wow, you're doing it.

## A Little More Detail 🔎

The EXT token standard gets its name from it's EXTensible 🔗 nature. A standard implementation of the core module must provide the following functionality:

**Extensions** (`extensions : query () -> async [Extension];`)    
Get the extensions that this canister implements. After reading the results of this call, you know what functionality to expect from this canister.

**Balance** (`balance: query (request : BalanceRequest) -> async BalanceResponse;`)    
Check a user's balance for a token.

**Transfer** (`transfer: shared (request : TransferRequest) -> async TransferResponse;`)    
Transfer tokens between users.

----

This example implements the `@ext/nonfungible` extension, which means that it also provides these functions:

**MintNFT** (`mintNFT: shared (request : MintRequest) -> async ();`)    
Add an NFT to the ledger.

**Bearer** (`bearer: shared query (token : TokenIdentifier) -> async Result<AccountIdentifier, CommonError>;`)    

For the sake of utility, this example also implements a `readLedger` method, which is handy, but isn't currently a part of the EXT standard.

## That's It!

You thought minting NFTs meant expensive fees and burning trees? Guess again! 🌲🔥💵🔥🧯🧑‍🚒♾️ You can add anything your mind can dream up 🧠🤯.
