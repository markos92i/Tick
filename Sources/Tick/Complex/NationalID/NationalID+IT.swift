//
//  NationalID+IT.swift
//  Tick
//

/// Italian Codice Fiscale: 16 alphanumeric characters with check character.
///
/// Structure: SSSNNN YYXDD ZZZZ C
/// - SSS: 3 consonants from surname
/// - NNN: 3 consonants from first name
/// - YY: year of birth (2 digits)
/// - X: month letter (A=Jan, B=Feb, C=Mar, D=Apr, E=May, H=Jun, L=Jul, M=Aug, P=Sep, R=Oct, S=Nov, T=Dec)
/// - DD: day of birth (females add 40)
/// - ZZZZ: municipality code (letter + 3 digits)
/// - C: check character computed from odd/even position algorithm
enum NationalIDIT {

    // Odd-position values (1st, 3rd, 5th... using 1-based indexing)
    private static let oddValues: [Character: Int] = [
        "0": 1,  "1": 0,  "2": 5,  "3": 7,  "4": 9,
        "5": 13, "6": 15, "7": 17, "8": 19, "9": 21,
        "A": 1,  "B": 0,  "C": 5,  "D": 7,  "E": 9,
        "F": 13, "G": 15, "H": 17, "I": 19, "J": 21,
        "K": 2,  "L": 4,  "M": 18, "N": 20, "O": 11,
        "P": 3,  "Q": 6,  "R": 8,  "S": 12, "T": 14,
        "U": 16, "V": 10, "W": 22, "X": 25, "Y": 24,
        "Z": 23
    ]

    // Even-position values (2nd, 4th, 6th... using 1-based indexing)
    private static let evenValues: [Character: Int] = [
        "0": 0,  "1": 1,  "2": 2,  "3": 3,  "4": 4,
        "5": 5,  "6": 6,  "7": 7,  "8": 8,  "9": 9,
        "A": 0,  "B": 1,  "C": 2,  "D": 3,  "E": 4,
        "F": 5,  "G": 6,  "H": 7,  "I": 8,  "J": 9,
        "K": 10, "L": 11, "M": 12, "N": 13, "O": 14,
        "P": 15, "Q": 16, "R": 17, "S": 18, "T": 19,
        "U": 20, "V": 21, "W": 22, "X": 23, "Y": 24,
        "Z": 25
    ]

    private static let checkLetters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    static func validate(_ value: String) -> Bool {
        let cleaned = value.uppercased().replacingOccurrences(of: " ", with: "")
        guard cleaned.count == 16 else { return false }
        guard cleaned.allSatisfy({ $0.isLetter || $0.isNumber }) else { return false }

        let chars = Array(cleaned)

        // Calculate check character from first 15 characters
        var sum = 0
        for i in 0..<15 {
            let char = chars[i]
            // Positions are 1-based: odd positions (1,3,5...) use oddValues
            if (i + 1) % 2 == 1 {
                guard let val = oddValues[char] else { return false }
                sum += val
            } else {
                guard let val = evenValues[char] else { return false }
                sum += val
            }
        }

        let checkIndex = sum % 26
        let expectedCheck = checkLetters[checkLetters.index(checkLetters.startIndex, offsetBy: checkIndex)]

        return chars[15] == expectedCheck
    }
}
