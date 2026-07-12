//
//  Tick.swift
//  Tick
//

import Foundation

public struct Tick {

    // MARK: - Generic engine

    /// Validates a non-optional value against a list of rules.
    /// Returns only the rules that failed.
    public static func validate<R: ValidationRule>(_ value: R.Value, rules: [R]) -> [R] {
        rules.filter { !$0.passes(value) }
    }

    /// Validates an optional value against a list of rules.
    /// If `nil` and no rule is required → skip (no errors).
    /// If `nil` and a required rule exists → return the required rules.
    /// If non-nil → unwrap and evaluate all rules.
    public static func validate<R: ValidationRule>(_ value: R.Value?, rules: [R]) -> [R] {
        let hasRequired = rules.contains { $0.isRequired }
        guard let value else {
            return hasRequired ? rules.filter { $0.isRequired } : []
        }
        return rules.filter { !$0.passes(value) }
    }

    // MARK: - String convenience (with empty-skip logic)

    /// Validates a String with skip-if-empty semantics.
    /// If the value is empty and not required → no errors.
    /// If the value is empty and required → returns the required rules.
    /// Otherwise evaluates all rules.
    public static func validate(_ value: String, rules: [StringRule]) -> [StringRule] {
        let hasRequired = rules.contains { $0.isRequired }

        if !hasRequired && value.isEmpty { return [] }

        if value.isEmpty {
            return rules.filter { $0.isRequired }
        }

        return rules.filter { !$0.passes(value) }
    }

    /// Validates a collection against collection rules.
    /// If empty and not required → no errors.
    /// If empty and required → returns the required rules.
    /// Otherwise evaluates all rules against the full collection.
    public static func validate<Element: Sendable>(collection: [Element], rules: [CollectionRule<Element>]) -> [CollectionRule<Element>] {
        let hasRequired = rules.contains { $0.isRequired }

        if !hasRequired && collection.isEmpty { return [] }

        if collection.isEmpty {
            return rules.filter { $0.isRequired }
        }

        return rules.filter { !$0.passes(collection) }
    }


}
