//
//  NationalID+AD.swift
//  Tick
//

/// Andorran passport/ID: format varies, basic length check.
/// Typical format: a letter followed by 6 digits (e.g., F123456).
enum NationalIDAD {

    static func validate(_ value: String) -> Bool {
        let cleaned = value.uppercased().trimmingCharacters(in: .whitespaces)
        guard cleaned.count >= 6, cleaned.count <= 8 else { return false }
        guard cleaned.first?.isLetter == true else { return false }

        return cleaned.dropFirst().allSatisfy(\.isNumber)
    }
}
