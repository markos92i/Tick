//
//  ValidationRule.swift
//  Tick
//

/// A type-safe validation rule that knows how to evaluate itself against a value.
public protocol ValidationRule: Sendable {
    associatedtype Value: Sendable

    /// Returns `true` if the value satisfies this rule.
    func passes(_ value: Value) -> Bool

    /// Whether this rule represents a "required" constraint (skip-if-empty logic).
    var isRequired: Bool { get }

    /// Human-readable error message when this rule fails.
    var error: String { get }
}

/// Default error — consumers must provide meaningful messages via extension.
extension ValidationRule {
    public var error: String { "" }
}
