//
//  Tick.swift
//  Tick
//

import Foundation

public struct Tick {

    /// Validates a value against a list of validation rules.
    /// Returns only the rules that failed.
    public static func validate(_ value: String, validations: [Rule]) -> [Rule] {
        let isMandatory = validations.contains { if case .mandatory = $0 { true } else { false } }

        // Empty + not mandatory → nothing to validate
        if !isMandatory && value.isEmpty { return [] }

        // Empty + mandatory → only mandatory fails
        if value.isEmpty { return [.mandatory] }

        // Non-empty → run all rules except mandatory
        return validations.filter { rule in
            switch rule {
            case .mandatory:                false
            case .min(let count):           value.count < count
            case .max(let count):           value.count > count
            case .matches(let regex):       !regex.matches(value)
            case .equalTo(let provider):    value != provider()
            case .iban:                     !IBANValidator.validate(value)
            case .nationalID(let country):  !IDValidator.validate(value, country: country)
            case .socialSecurity(let c):    !SocialSecurityValidator.validate(value, country: c)
            case .postalCode(let c, let p): !PostalCodeValidator.validate(value, country: c, province: p)
            case .custom(let predicate, _): predicate(value)
            }
        }
    }
}
