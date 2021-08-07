import Cycles "mo:base/ExperimentalCycles";
import Debug "mo:base/Debug";
import HashMap "mo:base/HashMap";
import Iter "mo:base/Iter";
import Nat "mo:base/Nat";
import Principal "mo:base/Principal";
import Result "mo:base/Result";

import AID "mo:ext/util/AccountIdentifier";
import ExtCore "mo:ext/Core";
import ExtNonFungible "mo:ext/NonFungible";

shared actor class BetaDeck () = canister {

    ////////////
    // Types //
    //////////

    type AccountIdentifier = ExtCore.AccountIdentifier;
    type SubAccount = ExtCore.SubAccount;
    type User = ExtCore.User;
    type Balance = ExtCore.Balance;
    type TokenIdentifier = ExtCore.TokenIdentifier;
    type TokenIndex  = ExtCore.TokenIndex;
    type Extension = ExtCore.Extension;
    type CommonError = ExtCore.CommonError;
    type BalanceRequest = ExtCore.BalanceRequest;
    type BalanceResponse = ExtCore.BalanceResponse;
    type TransferRequest = ExtCore.TransferRequest;
    type TransferResponse = ExtCore.TransferResponse;
    type MintRequest  = ExtNonFungible.MintRequest;

    ////////////
    // State //
    //////////

    let EXTENSIONS : [Extension] = ["@ext/common", "@ext/nonfungible"];

    stable var nextTokenId : TokenIndex = 0;

    stable var stableLedger : [(TokenIndex, AccountIdentifier)] = [];
    
    var ledger : HashMap.HashMap<TokenIndex, AccountIdentifier> = HashMap.fromIter(stableLedger.vals(), 0, ExtCore.TokenIndex.equal, ExtCore.TokenIndex.hash);

    system func preupgrade() {
        stableLedger := Iter.toArray(ledger.entries());
    };

    system func postupgrade() {
        stableLedger := [];
    };

    /////////////
    // Things //
    ///////////

    // Ext core

    public shared query func extensions () : async [Extension] {
        EXTENSIONS;
    };

    public shared query func balance (request : BalanceRequest) : async BalanceResponse {
        if (not ExtCore.TokenIdentifier.isPrincipal(request.token, Principal.fromActor(canister))) {
            return #err(#InvalidToken(request.token));
        };
        let token = ExtCore.TokenIdentifier.getIndex(request.token);
        let aid = ExtCore.User.toAID(request.user);
        switch (ledger.get(token)) {
            case (?owner) {
                if (AID.equal(aid, owner)) return #ok(1);
                return #ok(0);
            };
            case Null #err(#InvalidToken(request.token));
        };
    };

    public shared({ caller }) func transfer (request : TransferRequest) : async TransferResponse {
        if (request.amount != 1) {
            return #err(#Other("Only logical transfer amount for an NFT is 1, got" # Nat.toText(request.amount) # "."));
        };
        if (not ExtCore.TokenIdentifier.isPrincipal(request.token, Principal.fromActor(canister))) {
            return #err(#InvalidToken(request.token));
        };
        let token = ExtCore.TokenIdentifier.getIndex(request.token);
        let owner = ExtCore.User.toAID(request.from);
        let recipient = ExtCore.User.toAID(request.to);
        switch (ledger.get(token)) {
            case (?tokenOwner) {
                if (AID.equal(owner, tokenOwner)) {
                    ledger.put(token, recipient);
                    return #ok(request.amount);
                };
                #err(#Unauthorized(owner));
            };
            case Null return #err(#InvalidToken(request.token));
        };
    };

    // Ext nonfungible

    public shared query func bearer (token : TokenIdentifier) : async Result.Result<AccountIdentifier, CommonError> {
        if (not ExtCore.TokenIdentifier.isPrincipal(token, Principal.fromActor(canister))) {
            return #err(#InvalidToken(token));
        };
        let i = ExtCore.TokenIdentifier.getIndex(token);
        switch (ledger.get(i)) {
            case (?owner) #ok(owner);
            case Null #err(#InvalidToken(token));
        };
    };

    public shared({ caller }) func mintNFT (request : MintRequest) : async () {
        let recipient = ExtCore.User.toAID(request.to);
        let token = nextTokenId;
        ledger.put(token, recipient);
        nextTokenId := nextTokenId + 1;
    };

    // Just useful things

    public query func readLedger () : async [(TokenIndex, AccountIdentifier)] {
        Iter.toArray(ledger.entries());
    };

};
