//
//  NationalID+PT.swift
//  Tick
//

/// Portuguese NIF (Número de Identificação Fiscal): 9 digits with check digit.
///
/// Validation: weighted sum with factors [9,8,7,6,5,4,3,2] applied to first 8 digits.
/// Check digit = 11 - (sum % 11). If result is 10 or 11, check digit is 0.
/// First digit indicates entity type (1,2,3 = individuals, 5 = legal entities, etc.).
enum NationalIDPT {

    private static let validFirstDigits: Set<Character> = ["1", "2", "3", "5", "6", "7", "8", "9"]

    static func validate(_ value: String) -> Bool {
        let cleaned = value.replacingOccurrences(of: " ", with: "")
        guard cleaned.count == 9, cleaned.allSatisfy(\.isNumber) else { return false }
        guard let first = cleaned.first, validFirstDigits.contains(first) else { return false }

        let digits = cleaned.compactMap { $0.wholeNumberValue }
        let weights = [9, 8, 7, 6, 5, 4, 3, 2]

        let sum = zip(digits, weights).reduce(0) { $0 + $1.0 * $1.1 }
        let remainder = sum % 11
        let expected = remainder < 2 ? 0 : 11 - remainder

        return digits[8] == expected
    }
}
