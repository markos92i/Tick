//
//  PostalCodeValidator.swift
//  Tick
//

/// Dispatches postal code validation to the appropriate country implementation.
struct PostalCodeValidator {

    static func validate(_ value: String, country: Country, province: String? = nil) -> Bool {
        switch country {
        case .es: PostalCodeES.validate(value, province: province)
        case .ad: PostalCodeAD.validate(value)
        case .pt: PostalCodePT.validate(value)
        case .it: PostalCodeIT.validate(value)
        case .fr: PostalCodeFR.validate(value)
        }
    }
}
