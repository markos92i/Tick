//
//  SocialSecurityValidator.swift
//  Tick
//

/// Dispatches social security number validation to the appropriate country implementation.
struct SocialSecurityValidator {

    static func validate(_ value: String, country: Country) -> Bool {
        switch country {
        case .es: SocialSecurityES.validate(value)
        case .ad: SocialSecurityES.validate(value) // Andorra uses Spanish NASS system
        case .pt: SocialSecurityPT.validate(value)
        case .it: SocialSecurityIT.validate(value)
        case .fr: SocialSecurityFR.validate(value)
        }
    }
}
