//
//  CollectionRule.swift
//  Tick
//

import Foundation

/// A validation rule for collections (arrays, sets, file lists, selections).
/// Rules receive the full collection, enabling element-level inspection in `.check`.
public enum CollectionRule<Element: Sendable>: ValidationRule, Sendable {
    /// Collection must not be empty.
    case required
    /// Minimum number of elements.
    case min(Int)
    /// Maximum number of elements.
    case max(Int)
    /// Exact number of elements.
    case count(Int)
    /// Custom validation — closure receives the full collection, must return `true` when valid.
    case check(@Sendable ([Element]) -> Bool, String)

    public func passes(_ value: [Element]) -> Bool {
        switch self {
        case .required:             !value.isEmpty
        case .min(let n):           value.count >= n
        case .max(let n):           value.count <= n
        case .count(let n):         value.count == n
        case .check(let fn, _):     fn(value)
        }
    }

    public var isRequired: Bool {
        if case .required = self { true } else { false }
    }
}
