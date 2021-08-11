import FungibleToken from Flow.FungibleToken

pub contract Kibble: FungibleToken {
    // TokensInitialized
    //
    // The event that is emitted when the contract is created
    pub event TokensInitialized(initialSupply: UFix64)

    // TokensWithdrawn
    //
    // The event that is emitted when tokens are withdrawn from a Vault
    pub event TokensWithdrawn(amount: UFix64, from: Address?)

    // TokensDeposited
    //
    // The event that is emitted when tokens are deposited to a Vault
    pub event TokensDeposited(amount: UFix64, to: Address?)

    // TokensMinted
    //
    // The event that is emitted when new tokens are minted
    pub event TokensMinted(amount: UFix64)

    // TokensBurned
    //
    // The event that is emitted when tokens are destroyed
    pub event TokensBurned(amount: UFix64)

    // MinterCreated
    //
    // The event that is emitted when a new minter resource is created
    pub event MinterCreated(allowedAmount: UFix64)

    // Named paths
    //
    pub let VaultStoragePath: StoragePath
    pub let ReceiverPublicPath: PublicPath
    pub let BalancePublicPath: PublicPath
    pub let MinterStoragePath: StoragePath
    //w2q8
    pub let BurnerStoragePath: StoragePath

    // Total supply of Kibbles in existence
    pub var totalSupply: UFix64

    // Vault
    //
    // Each user stores an instance of only the Vault in their storage
    // The functions in the Vault and governed by the pre and post conditions
    // in FungibleToken when they are called.
    // The checks happen at runtime whenever a function is called.
    //
    // Resources can only be created in the context of the contract that they
    // are defined in, so there is no way for a malicious user to create Vaults
    // out of thin air. A special Minter resource needs to be defined to mint
    // new tokens.
    //
    pub resource Vault: FungibleToken.Provider, FungibleToken.Receiver, FungibleToken.Balance {

        // The total balance of this vault
        pub var balance: UFix64

        // initialize the balance at resource creation time
        init(balance: UFix64) {
            self.balance = balance
        }

        // withdraw
        //
        // Function that takes an amount as an argument
        // and withdraws that amount from the Vault.
        //
        // It creates a new temporary Vault that is used to hold
        // the money that is being transferred. It returns the newly
        // created Vault to the context that called so it can be deposited
        // elsewhere.
        //
        pub fun withdraw(amount: UFix64): @FungibleToken.Vault {
            // TODO: Delete the line below and implement this function
            //return <- create Vault(balance: 0.0)

            // 1) Take away 'amount' balance from this Vault
            self.balance = self.balance - amount
            // 2) emit TokensWithdrawn
            emit TokensWithdrawn(amount: amount, from: self.owner?.address)
            // 3) return a new Vault with balance == 'amount'
            return <- create Vault(balance: amount)
        }

        // deposit
        //
        // Function that takes a Vault object as an argument and adds
        // its balance to the balance of the owners Vault.
        //
        // It is allowed to destroy the sent Vault because the Vault
        // was a temporary holder of the tokens. The Vault's balance has
        // been consumed and therefore can be destroyed.
        //
        pub fun deposit(from: @FungibleToken.Vault) {
            // TODO: Delete the line below and implement this function
            //destroy from

            // 1) Convert 'from' from a @FungibleToken.Vault to a 
            // new variable called 'vault' of type @Kibble.Vault using 'as!'
            let vault <- from as! @Kibble.Vault
            // 2) Add the balance inside 'vault' to this Vault
            self.balance = self.balance + vault.balance
            // 3) emit TokensDeposited
            emit TokensDeposited(amount: vault.balance, to: self.owner?.address)
            // 4) Set 'vault's balance to 0.0
            vault.balance = 0.0
            // 5) destroy 'vault'
            destroy vault
        }

        destroy() {
            Kibble.totalSupply = Kibble.totalSupply - self.balance
            if(self.balance > 0.0) {
                emit TokensBurned(amount: self.balance)
            }
        }
    }

    // createEmptyVault
    //
    // Function that creates a new Vault with a balance of zero
    // and returns it to the calling context. A user must call this function
    // and store the returned Vault in their storage in order to allow their
    // account to be able to receive deposits of this token type.
    //
    pub fun createEmptyVault(): @Vault {
        return <-create Vault(balance: 0.0)
    }

    // Minter
    //
    // Resource object to mint new tokens.
    //
    pub resource Minter {

        // mintTokens
        //
        // Function that mints new tokens, adds them to the total supply,
        // and returns them to the calling context.
        //
        pub fun mintTokens(amount: UFix64): @Kibble.Vault {
            // TODO: Delete the line below and implement this function
            //return <-create Vault(balance: 0.0)

            // 1) Add a pre-condition to make sure 'amount' is greater than 0.0
            pre {
                amount > 0.0:
                    "amount cannot be negative!"
            }
            // 2) Update Kibble.totalSupply by adding 'amount'
            Kibble.totalSupply = Kibble.totalSupply + amount
            // 3) emit TokensMinted
            emit TokensMinted(amount: amount)
            // 4) return a Vault with balance == 'amount'
            return <- create Vault(balance: amount)
        }

        init() {
    
        }
    }

    //w2q8
    //
    // Burner
    //
    // Resource object that token admin accounts can hold to burn tokens.
    //
    pub resource Burner {

        // burnTokens
        //
        // Function that destroys a Vault instance, effectively burning the tokens.
        //
        // Note: the burned tokens are automatically subtracted from the
        // total supply in the Vault destructor.
        //
        pub fun burnTokens(from: @FungibleToken.Vault) {
            let vault <- from as! @Kibble.Vault
            let amount = vault.balance
            destroy vault
            emit TokensBurned(amount: amount)
        }
    }

    init() {
        // Set our named paths.
        self.VaultStoragePath = /storage/kibbleVault
        self.ReceiverPublicPath = /public/kibbleReceiver
        self.BalancePublicPath = /public/kibbleBalance
        self.MinterStoragePath = /storage/kibbleMinter
        //w2q8
        self.BurnerStoragePath = /storage/kibbleBurner

        // Initialize contract state.
        self.totalSupply = 0.0

        // Create the one true Minter object and deposit it into the conttract account.
        let minter <- create Minter()
        self.account.save(<-minter, to: self.MinterStoragePath)

        // Emit an event that shows that the contract was initialized.
        emit TokensInitialized(initialSupply: self.totalSupply)

        //w2q8
        // Create burner resource and deposit it into the contract account.
        let burner <- create Burner()
        self.account.save(<-burner, to: self.BurnerStoragePath)
    }
}