//w2q8
// 
// This transaction is a template for a transaction that
// could be used by the admin account to burn tokens
// from their stored Vault
//
// The burning amount would be a parameter to the transaction

import FungibleToken from Flow.FungibleToken
import Kibble from Project.Kibble

transaction(amount: UFix64) {

    // Vault resource that holds the tokens that are being burned
    //let vault: @FungibleToken.Vault

    prepare(signer: AuthAccount) {

        // Withdraw tokens from the admin vault in storage
        let vault <- signer.borrow<&Kibble.Vault>(from: Kibble.VaultStoragePath)!
            .withdraw(amount: amount)

        // Create a reference to the admin admin resource in storage
        let tokenBurner = signer.borrow<&Kibble.Burner>(from: Kibble.BurnerStoragePath)
                                ?? panic("Signer is not the token admin")
        
        tokenBurner.burnTokens(from: <- vault)

    }

}