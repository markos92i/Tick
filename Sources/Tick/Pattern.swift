//
//  Pattern.swift
//  Tick
//

import Foundation

/// Validation patterns for string matching.
public enum Pattern: Sendable {
    case name
    case email
    case phone
    case url
    case numeric
    case custom(String)

    /// Tests if the value matches this validation pattern.
    func matches(_ value: String) -> Bool {
        switch self {
        case .url:     URLValidator.validate(value)
        case .numeric: value.allSatisfy(\.isNumber)
        default:       (try? regex.wholeMatch(in: value)) != nil
        }
    }

    private var regex: Regex<Substring> {
        switch self {
        case .name:    /^[\p{L}\p{M}\s''-]+$/
        case .email:   /^[a-zA-Z0-9][a-zA-Z0-9._%+-]*@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
        case .phone:   /^(?:\+|00)\d{6,14}$/
        case .custom(let pattern):
            (try? Regex(pattern)) ?? /^.*$/
        case .url, .numeric:
            /^.*$/
        }
    }
}

/// Backwards compatibility alias.
public typealias RegexType = Pattern
