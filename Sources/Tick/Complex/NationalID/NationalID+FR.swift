//
//  NationalID+FR.swift
//  Tick
//

/// French NIR (Numéro d'Inscription au Répertoire) / Social Security Number.
/// 15 characters: 13 digits + 2-digit control key.
///
/// Structure: S AA MM DD OOO NNN CC
/// - S: sex (1=male, 2=female)
/// - AA: year of birth
/// - MM: month of birth (01-12, or 20+ for overseas)
/// - DD: department (01-95, 2A, 2B for Corsica → replaced by 99 for calculation)
/// - OOO: commune code (001-990)
/// - NNN: order number (001-999)
/// - CC: control key = 97 - (13-digit number % 97)
///
/// Special case: Corsica departments 2A and 2B are replaced by 19 and 18 respectively
/// in the numeric calculation.
enum NationalIDFR {

    static func validate(_ value: String) -> Bool {
        let cleaned = value.uppercased().replacingOccurrences(of: " ", with: "")
        guard cleaned.count == 15 else { return false }

        // Handle Corsica: 2A → 19, 2B → 18 for numeric calculation
        let numericString: String
        if cleaned.contains("A") {
            numericString = cleaned.replacingOccurrences(of: "2A", with: "19")
        } else if cleaned.contains("B") {
            numericString = cleaned.replacingOccurrences(of: "2B", with: "18")
        } else {
            numericString = cleaned
        }

        guard numericString.allSatisfy(\.isNumber) else { return false }

        // First 13 digits are the number, last 2 are control key
        let numberStr = String(numericString.prefix(13))
        let keyStr = String(numericString.suffix(2))

        guard let number = Int64(numberStr), let key = Int(keyStr) else { return false }

        // Control key = 97 - (number % 97)
        let expected = 97 - Int(number % 97)
        return key == expected
    }
}
