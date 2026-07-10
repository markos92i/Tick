//
//  IDValidator.swift
//  Tick
//

/// Dispatches national ID validation to the appropriate country implementation.
struct IDValidator {

    static func validate(_ value: String, country: Country) -> Bool {
        switch country {
        case .es: NationalIDES.validate(value)
        case .ad: NationalIDAD.validate(value)
        case .pt: NationalIDPT.validate(value)
        case .it: NationalIDIT.validate(value)
        case .fr: NationalIDFR.validate(value)
        }
    }
}
