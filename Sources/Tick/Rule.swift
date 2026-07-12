//
//  Rule.swift
//  Tick
//

import Foundation

/// A validation rule for String fields.
public enum StringRule: ValidationRule, Sendable {
    /// Field must not be empty.
    case required
    /// Field must not be empty when condition is met.
    case requiredIf(@Sendable () -> Bool)
    /// Minimum character count.
    case min(Int)
    /// Maximum character count.
    case max(Int)
    /// Exact character count.
    case count(Int)
    /// Value must match a pattern (regex, url, numeric...).
    case matches(Pattern)
    /// All characters must belong to the given character set.
    case `is`(CharacterSet)
    /// Value must be one of the given options.
    case `in`([String])
    /// Value must contain the given substring.
    case contains(String)
    /// Value must start with the given prefix.
    case prefix(String)
    /// Value must end with the given suffix.
    case suffix(String)
    /// Parsed numeric value must be within the given range.
    case range(ClosedRange<Int>)
    /// Value must equal the result of the closure.
    case equalTo(@Sendable () -> String)
    /// Valid IBAN number.
    case iban
    /// Valid national ID document for the given country.
    case nationalID(Country)
    /// Valid social security number for the given country.
    case socialSecurity(Country)
    /// Valid postal code for the given country and optional province.
    case postalCode(Country, province: String? = nil)
    /// Custom validation — closure must return `true` when the value is valid.
    case check(@Sendable (String) -> Bool, String)

    public func passes(_ value: String) -> Bool {
        switch self {
        case .required:                 !value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case .requiredIf(let cond):     !cond() || !value.isEmpty
        case .min(let count):           value.count >= count
        case .max(let count):           value.count <= count
        case .count(let count):         value.count == count
        case .matches(let pattern):     pattern.matches(value)
        case .is(let set):              value.unicodeScalars.allSatisfy(set.contains)
        case .in(let options):          options.contains(value)
        case .contains(let sub):        value.contains(sub)
        case .prefix(let pre):          value.hasPrefix(pre)
        case .suffix(let suf):          value.hasSuffix(suf)
        case .range(let range):         Int(value).map { range.contains($0) } ?? false
        case .equalTo(let provider):    value == provider()
        case .iban:                     IBANValidator.validate(value)
        case .nationalID(let country):  IDValidator.validate(value, country: country)
        case .socialSecurity(let c):    SocialSecurityValidator.validate(value, country: c)
        case .postalCode(let c, let p): PostalCodeValidator.validate(value, country: c, province: p)
        case .check(let fn, _):         fn(value)
        }
    }

    public var isRequired: Bool {
        switch self {
        case .required: true
        case .requiredIf(let cond): cond()
        default: false
        }
    }
}

