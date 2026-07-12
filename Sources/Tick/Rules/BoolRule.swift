//
//  BoolRule.swift
//  Tick
//

import Foundation

/// A validation rule for Bool fields.
public enum BoolRule: ValidationRule, Sendable {
    /// Value must be `true`.
    case mustBeTrue
    /// Custom validation — closure must return `true` when the value is valid.
    case check(@Sendable (Bool) -> Bool, String)

    public func passes(_ value: Bool) -> Bool {
        switch self {
        case .mustBeTrue:           value
        case .check(let fn, _):     fn(value)
        }
    }

    public var isRequired: Bool { false }
}
