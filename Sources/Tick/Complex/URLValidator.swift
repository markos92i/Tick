//
//  URLValidator.swift
//  Tick
//

import Foundation

/// Validates URL strings using Foundation's URL parsing.
struct URLValidator {

    /// Validates that the value is a well-formed URL with a scheme and host.
    static func validate(_ value: String) -> Bool {
        guard let url = URL(string: value),
              let scheme = url.scheme,
              let host = url.host()
        else { return false }

        let validSchemes = ["http", "https"]
        return validSchemes.contains(scheme.lowercased()) && host.contains(".")
    }
}
