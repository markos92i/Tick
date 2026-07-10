//
//  PostalCode+AD.swift
//  Tick
//

/// Andorran postal codes: "AD" followed by 3 digits (AD100–AD700).
enum PostalCodeAD {

    static func validate(_ value: String) -> Bool {
        let cleaned = value.replacingOccurrences(of: " ", with: "")
        guard cleaned.count == 5 else { return false }
        guard cleaned.prefix(2).uppercased() == "AD" else { return false }

        let digits = String(cleaned.dropFirst(2))
        return digits.allSatisfy(\.isNumber)
    }
}
