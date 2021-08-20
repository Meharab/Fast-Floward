import RegistrySampleContract from Project.RegistrySampleContract

// This is a blank ComposedContract template. It imports
// the blank RegistrySampleContract template because you will
// use that in here.

pub contract ComposedContract {

    //W3Q3
    pub fun getUserName(tenant: &RegistrySampleContract.Tenant{RegistrySampleContract.ITenantPublic}): String {
        return "Hello ".concat(tenant.userName).concat(", Whazz-up...!!!")
    }

    init() {

    }
}