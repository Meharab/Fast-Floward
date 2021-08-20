import RegistrySampleContract from Project.RegistrySampleContract
import ComposedContract from Project.ComposedContract

pub fun main(account: Address): String {

    let tenant = getAccount(account).getCapability(RegistrySampleContract.TenantPublicPath).borrow<&RegistrySampleContract.Tenant{RegistrySampleContract.ITenantPublic}>()
                        ?? panic("Could not borrow the Tenant")

    return ComposedContract.getUserName(tenant: tenant)
}  