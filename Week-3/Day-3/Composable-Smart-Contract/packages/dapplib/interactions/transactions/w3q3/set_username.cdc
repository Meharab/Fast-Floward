import NonFungibleToken from Flow.NonFungibleToken
import RegistrySampleContract from Project.RegistrySampleContract

transaction(name: String) {
    
    // the tenant
    let tenant: &RegistrySampleContract.Tenant{RegistrySampleContract.ITenantPrivate}
    let name: String

    prepare(signer: AuthAccount) {

        self.tenant = signer.borrow<&RegistrySampleContract.Tenant{RegistrySampleContract.ITenantPrivate}>(from: RegistrySampleContract.TenantStoragePath)
                        ?? panic("Could not borrow the Tenant")        
        self.name = name
    }

    execute {
        self.tenant.updateUserName(name: self.name)
    }
}