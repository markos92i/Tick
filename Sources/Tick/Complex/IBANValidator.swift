//
//  IBANValidator.swift
//  Tick
//

/// Validates IBAN numbers using ISO 13616 mod-97 algorithm.
/// Supports all countries via the universal check digit validation,
/// with per-country length enforcement.
struct IBANValidator {

    // IBAN lengths per country code (ISO 3166-1 alpha-2)
    private static let lengths: [String: Int] = [
        "AL": 28, "AD": 24, "AT": 20, "AZ": 28, "BH": 22,
        "BY": 28, "BE": 16, "BA": 20, "BR": 29, "BG": 22,
        "CR": 22, "HR": 21, "CY": 28, "CZ": 24, "DK": 18,
        "DO": 28, "EG": 29, "SV": 28, "EE": 20, "FO": 18,
        "FI": 18, "FR": 27, "GE": 22, "DE": 22, "GI": 23,
        "GR": 27, "GL": 18, "GT": 28, "HU": 28, "IS": 26,
        "IQ": 23, "IE": 22, "IL": 23, "IT": 27, "JO": 30,
        "KZ": 20, "XK": 20, "KW": 30, "LV": 21, "LB": 28,
        "LI": 21, "LT": 20, "LU": 20, "MT": 31, "MR": 27,
        "MU": 30, "MD": 24, "MC": 27, "ME": 22, "NL": 18,
        "MK": 19, "NO": 15, "PK": 24, "PS": 29, "PL": 28,
        "PT": 25, "QA": 29, "RO": 24, "LC": 32, "SM": 27,
        "SA": 24, "RS": 22, "SC": 31, "SK": 24, "SI": 19,
        "ES": 24, "SE": 24, "CH": 21, "TL": 23, "TN": 24,
        "TR": 26, "UA": 29, "AE": 23, "GB": 22, "VG": 24
    ]

    /// Validates an IBAN string (spaces allowed).
    static func validate(_ value: String) -> Bool {
        let cleaned = value.replacingOccurrences(of: " ", with: "").uppercased()

        guard cleaned.count >= 4,
              cleaned.allSatisfy({ $0.isASCII && ($0.isLetter || $0.isNumber) })
        else { return false }

        let countryCode = String(cleaned.prefix(2))

        // Validate country-specific length if known
        if let expectedLength = lengths[countryCode] {
            guard cleaned.count == expectedLength else { return false }
        }

        return mod97(cleaned) == 1
    }

    private static func mod97(_ iban: String) -> Int {
        let rearranged = iban.dropFirst(4) + iban.prefix(4)
        return rearranged.reduce(0) { remainder, character in
            let value = Int(String(character), radix: 36)!
            let factor = value < 10 ? 10 : 100
            return (factor * remainder + value) % 97
        }
    }
}
