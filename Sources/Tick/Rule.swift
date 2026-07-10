//
//  Rule.swift
//  Tick
//

import Foundation

/// A validation rule that can be applied to a form field.
public enum Rule: Sendable {
    case required
    case requiredIf(@Sendable () -> Bool)
    case min(Int)
    case max(Int)
    case matches(Pattern)
    case equalTo(@Sendable () -> String)
    case iban
    case nationalID(Country)
    case socialSecurity(Country)
    case postalCode(Country, province: String? = nil)
    case custom(@Sendable (String) -> Bool, String)
}
