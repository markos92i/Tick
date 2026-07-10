//
//  PostalCode+IT.swift
//  Tick
//

/// Italian postal codes (CAP): exactly 5 digits.
enum PostalCodeIT {

    static func validate(_ value: String) -> Bool {
        let cleaned = value.replacingOccurrences(of: " ", with: "")
        return cleaned.count == 5 && cleaned.allSatisfy(\.isNumber)
    }
}
