//
//  SocialSecurityValidator.swift
//  Tick
//

/// Validates social security numbers.
/// Currently supports Spain (NASS).
struct SocialSecurityValidator {

    /// Validates a social security number for the given country.
    static func validate(_ value: String, country: Country) -> Bool {
        switch country {
        case .es: validateSpain(value)
        }
    }

    // MARK: - Spain

    /// Spanish NASS format: 12 digits.
    /// [2 province][8 account][2 control]
    /// Control = full_number % 97
    private static func validateSpain(_ value: String) -> Bool {
        let cleaned = value.replacingOccurrences(of: " ", with: "")
        guard cleaned.count == 12, cleaned.allSatisfy(\.isNumber) else { return false }

        let provinceStr = String(cleaned.prefix(2))
        let accountStr = String(cleaned.dropFirst(2).prefix(8))
        let controlStr = String(cleaned.suffix(2))

        guard let province = Int(provinceStr),
              let account = Int(accountStr),
              let control = Int(controlStr),
              province > 0, province <= 52
        else { return false }

        let fullNumber = account < 10_000_000
            ? account + province * 10_000_000
            : Int(String(cleaned.dropLast(2)))!

        return control == fullNumber % 97
    }
}
