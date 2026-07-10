//
//  PostalCode+ES.swift
//  Tick
//

/// Spanish postal codes: 5 digits, first two are province (01-52).
/// If `province` is provided, the first two digits must match it.
enum PostalCodeES {

    static func validate(_ value: String, province: String?) -> Bool {
        let cleaned = value.replacingOccurrences(of: " ", with: "")
        guard cleaned.count == 5, cleaned.allSatisfy(\.isNumber) else { return false }

        let prefix = String(cleaned.prefix(2))
        guard let provinceCode = Int(prefix), provinceCode >= 1, provinceCode <= 52 else { return false }

        if let province { return prefix == province }
        return true
    }
}
