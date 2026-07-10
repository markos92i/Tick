//
//  NationalID+ES.swift
//  Tick
//

/// Spanish national ID (DNI/NIE).
/// DNI: 8 digits + 1 control letter.
/// NIE: X/Y/Z + 7 digits + 1 control letter.
enum NationalIDES {

    private static let letterTable = "TRWAGMYFPDXBNJZSQVHLCKET"

    static func validate(_ value: String) -> Bool {
        let uppercased = value.uppercased().trimmingCharacters(in: .whitespaces)
        guard uppercased.count >= 8, uppercased.count <= 9 else { return false }

        // Replace NIE prefix with numeric equivalent
        let numericString: String
        switch uppercased.first {
        case "X": numericString = "0" + String(uppercased.dropFirst())
        case "Y": numericString = "1" + String(uppercased.dropFirst())
        case "Z": numericString = "2" + String(uppercased.dropFirst())
        default:  numericString = uppercased
        }

        // Extract numeric part (all but last character)
        let digits = String(numericString.dropLast())
        guard let number = Int(digits) else { return false }

        // Calculate expected letter
        let index = number % 23
        let expectedLetter = letterTable[letterTable.index(letterTable.startIndex, offsetBy: index)]

        return expectedLetter == uppercased.last
    }
}
