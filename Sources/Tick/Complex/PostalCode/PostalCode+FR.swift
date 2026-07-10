//
//  PostalCode+FR.swift
//  Tick
//

/// French postal codes: exactly 5 digits, first two are department (01-95, 2A, 2B for Corsica excluded here).
enum PostalCodeFR {

    static func validate(_ value: String) -> Bool {
        let cleaned = value.replacingOccurrences(of: " ", with: "")
        return cleaned.count == 5 && cleaned.allSatisfy(\.isNumber)
    }
}
