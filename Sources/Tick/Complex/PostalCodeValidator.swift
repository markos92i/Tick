//
//  PostalCodeValidator.swift
//  Tick
//

/// Validates postal codes by country.
struct PostalCodeValidator {

    static func validate(_ value: String, country: Country) -> Bool {
        switch country {
        case .es: validateSpain(value)
        }
    }

    // MARK: - Spain

    /// Spanish postal codes: 5 digits, first two are province (01-52).
    private static func validateSpain(_ value: String) -> Bool {
        let cleaned = value.replacingOccurrences(of: " ", with: "")
        guard cleaned.count == 5, cleaned.allSatisfy(\.isNumber) else { return false }

        guard let province = Int(String(cleaned.prefix(2))) else { return false }
        return province >= 1 && province <= 52
    }
}
