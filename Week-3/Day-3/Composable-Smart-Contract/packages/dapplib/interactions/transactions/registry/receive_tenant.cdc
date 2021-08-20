import RegistrySampleContract from Project.RegistrySampleContract
import RegistryService from Project.RegistryService

// This transaction allows any Tenant to receive a Tenant Resource from
// RegistrySampleContract. It saves the resource to account storage.
//
// Note that this can only be called by someone who has already registered
// with the RegistryService and received an AuthNFT.

transaction() {

  prepare(signer: AuthAccount) {
    
    // save the Tenant resource to the account if it doesn't already exist
    if signer.borrow<&RegistrySampleContract.Tenant{RegistrySampleContract.ITenantPublic}>(from: RegistrySampleContract.TenantStoragePath) == nil { //W3Q3
    //if signer.borrow<&RegistrySampleContract.Tenant>(from: RegistrySampleContract.TenantStoragePath) == nil {
      // borrow a reference to the AuthNFT in account storage
      let authNFTRef = signer.borrow<&RegistryService.AuthNFT>(from: RegistryService.AuthStoragePath)
                        ?? panic("Could not borrow the AuthNFT")
      
      // save the new Tenant resource from RegistrySampleContract to account storage
      signer.save(<-RegistrySampleContract.instance(authNFT: authNFTRef), to: RegistrySampleContract.TenantStoragePath)

      // link the Tenant resource to the public
      //
      // NOTE: this is commented out for now because it is dangerous to link
      // our Tenant to the public without any resource interfaces restricting it.
      // If you add resource interfaces that Tenant must implement, you can
      // add those here and then uncomment the line below.
      // 
      // signer.link<&RegistrySampleContract.Tenant>(RegistrySampleContract.TenantPublicPath, target: RegistrySampleContract.TenantStoragePath)
      signer.link<&RegistrySampleContract.Tenant{RegistrySampleContract.ITenantPublic}>(RegistrySampleContract.TenantPublicPath, target: RegistrySampleContract.TenantStoragePath) //W3Q3
    }
  }

  execute {
    log("Registered a new Tenant for RegistrySampleContract.")
  }
}
