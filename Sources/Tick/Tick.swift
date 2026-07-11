//
//  Tick.swift
//  Tick
//

import Foundation

public struct Tick {

    /// Validates a value against a list of validation rules.
    /// Returns only the rules that failed.
    public static func validate(_ value: String, validations: [Rule]) -> [Rule] {
        let isRequired = validations.contains { rule in
            switch rule {
            case .required: true
            case .requiredIf(let condition): condition()
            default: false
            }
        }

        // Empty + not required → nothing to validate
        if !isRequired && value.isEmpty { return [] }

        // Empty + required → only required fails
        if value.isEmpty {
            // Return the same case that was passed in
            let failedRule = validations.first { rule in
                switch rule {
                case .required: true
                case .requiredIf: true
                default: false
                }
            }
            return [failedRule ?? .required]
        }

        // Non-empty → run all rules except required
        return validations.filter { rule in
            switch rule {
            case .required:                 false
            case .requiredIf:               false
            case .min(let count):           value.count < count
            case .max(let count):           value.count > count
            case .matches(let pattern):     !pattern.matches(value)
            case .is(let set):              !value.unicodeScalars.allSatisfy(set.contains)
            case .in(let options):          !options.contains(value)
            case .contains(let sub):        !value.contains(sub)
            case .prefix(let pre):          !value.hasPrefix(pre)
            case .suffix(let suf):          !value.hasSuffix(suf)
            case .range(let range):         Int(value).map { !range.contains($0) } ?? true
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
