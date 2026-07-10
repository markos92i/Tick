//
//  PostalCode+PT.swift
//  Tick
//

/// Portuguese postal codes: format NNNN-NNN (7 digits with hyphen).
enum PostalCodePT {

    static func validate(_ value: String) -> Bool {
        let cleaned = value.replacingOccurrences(of: " ", with: "")
        guard cleaned.count == 8 else { return false }

        let parts = cleaned.split(separator: "-")
        guard parts.count == 2, parts[0].count == 4, parts[1].count == 3 else { return false }

        return parts[0].allSatisfy(\.isNumber) && parts[1].allSatisfy(\.isNumber)
    }
}
