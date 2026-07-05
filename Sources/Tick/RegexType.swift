//
//  RegexType.swift
//  Tick
//

import Foundation

public enum RegexType: Sendable {
    case name
    case email
    case phone
    case custom(String)

    private var regex: Regex<Substring> {
        switch self {
        case .name:  /^[\p{L}\p{M}\s''-]+$/
        case .email: /^[a-zA-Z0-9][a-zA-Z0-9._%+-]*@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/
        case .phone: /^(?:\+|00)\d{6,14}$/
        case .custom(let pattern):
            (try? Regex(pattern)) ?? /^.*$/
        }
    }

    /// Tests if the value matches this regex pattern.
    func matches(_ value: String) -> Bool {
        (try? regex.wholeMatch(in: value)) != nil
    }
}
