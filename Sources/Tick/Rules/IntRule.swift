//
//  IntRule.swift
//  Tick
//

import Foundation

/// A validation rule for Int fields.
public enum IntRule: ValidationRule, Sendable {
    /// Value must be greater than or equal to the given minimum.
    case min(Int)
    /// Value must be less than or equal to the given maximum.
    case max(Int)
    /// Value must fall within the given range.
    case between(ClosedRange<Int>)
    /// Custom validation — closure must return `true` when the value is valid.
    case check(@Sendable (Int) -> Bool, String)

    public func passes(_ value: Int) -> Bool {
        switch self {
        case .min(let n):           value >= n
        case .max(let n):           value <= n
        case .between(let range):   range.contains(value)
        case .check(let fn, _):     fn(value)
        }
    }

    public var isRequired: Bool { false }
}
