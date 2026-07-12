//
//  DateRule.swift
//  Tick
//

import Foundation

/// A validation rule for Date fields.
public enum DateRule: ValidationRule, Sendable {
    /// Date must be on or after the given date.
    case min(Date)
    /// Date must be on or before the given date.
    case max(Date)
    /// Date must fall within the given range.
    case between(ClosedRange<Date>)
    /// Custom validation — closure must return `true` when the value is valid.
    case check(@Sendable (Date) -> Bool, String)

    public func passes(_ value: Date) -> Bool {
        switch self {
        case .min(let date):        value >= date
        case .max(let date):        value <= date
        case .between(let range):   range.contains(value)
        case .check(let fn, _):     fn(value)
        }
    }

    public var isRequired: Bool { false }
}
