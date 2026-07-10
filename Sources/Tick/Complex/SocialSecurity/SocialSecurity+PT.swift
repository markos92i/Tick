//
//  SocialSecurity+PT.swift
//  Tick
//

/// Portuguese NISS (Número de Identificação de Segurança Social): 11 digits with check digit.
///
/// Validation: weighted sum with factors [29,23,19,17,13,11,7,5,3,2] for first 10 digits.
/// Check digit = 9 - (sum % 10).
enum SocialSecurityPT {

    private static let weights = [29, 23, 19, 17, 13, 11, 7, 5, 3, 2]

    static func validate(_ value: String) -> Bool {
        let cleaned = value.replacingOccurrences(of: " ", with: "")
        guard cleaned.count == 11, cleaned.allSatisfy(\.isNumber) else { return false }

        let digits = cleaned.compactMap { $0.wholeNumberValue }

        let sum = zip(digits, weights).reduce(0) { $0 + $1.0 * $1.1 }
        let expected = 9 - (sum % 10)

        return digits[10] == expected
    }
}
