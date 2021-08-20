// 🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨
// ⚠️ THIS FILE IS AUTO-GENERATED WHEN packages/dapplib/interactions CHANGES
// DO **** NOT **** MODIFY CODE HERE AS IT WILL BE OVER-WRITTEN
// 🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨

const fcl = require("@onflow/fcl");

module.exports = class DappTransactions {

	static registry_receive_tenant() {
		return fcl.transaction`
				import RegistrySampleContract from 0x01cf0e2f2f715450
				import RegistryService from 0x01cf0e2f2f715450
				
				// This transaction allows any Tenant to receive a Tenant Resource from
				// RegistrySampleContract. It saves the resource to account storage.
				//
				// Note that this can only be called by someone who has already registered
				// with the RegistryService and received an AuthNFT.
				
				transaction() {
				
				  prepare(signer: AuthAccount) {
				    // save the Tenant resource to the account if it doesn't already exist
				    if signer.borrow<&RegistrySampleContract.Tenant>(from: RegistrySampleContract.TenantStoragePath) == nil {
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
				    }
				  }
				
				  execute {
				    log("Registered a new Tenant for RegistrySampleContract.")
				  }
				}
				
		`;
	}

	static registry_receive_auth_nft() {
		return fcl.transaction`
				import RegistryService from 0x01cf0e2f2f715450
				
				// Allows a Tenant to register with the RegistryService. It will
				// save an AuthNFT to account storage. Once an account
				// has an AuthNFT, they can then get Tenant Resources from any contract
				// in the Registry.
				//
				// Note that this only ever needs to be called once per Tenant
				
				transaction() {
				
				    prepare(signer: AuthAccount) {
				        // if this account doesn't already have an AuthNFT...
				        if signer.borrow<&RegistryService.AuthNFT>(from: RegistryService.AuthStoragePath) == nil {
				            // save a new AuthNFT to account storage
				            signer.save(<-RegistryService.register(), to: RegistryService.AuthStoragePath)
				
				            // we only expose the IAuthNFT interface so all this does is allow us to read
				            // the authID inside the AuthNFT reference
				            signer.link<&RegistryService.AuthNFT{RegistryService.IAuthNFT}>(RegistryService.AuthPublicPath, target: RegistryService.AuthStoragePath)
				        }
				    }
				
				    execute {
				
				    }
				}
		`;
	}

}
