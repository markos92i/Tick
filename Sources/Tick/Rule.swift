//
//  Rule.swift
//  Tick
//

import Foundation

/// A validation rule that can be applied to a form field.
public enum Rule: Sendable {
    /// Field must not be empty.
    case required
    /// Field must not be empty when condition is met.
    case requiredIf(@Sendable () -> Bool)
    /// Minimum character count.
    case min(Int)
    /// Maximum character count.
    case max(Int)
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
    case iban
    case nationalID(Country)
    case socialSecurity(Country)
    case postalCode(Country, province: String? = nil)
    case custom(@Sendable (String) -> Bool, String)
}
