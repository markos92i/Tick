//
//  SocialSecurity+ES.swift
//  Tick
//

/// Spanish NASS: 12 digits.
/// Format: [2 province][8 account][2 control].
/// Control = full_number % 97.
enum SocialSecurityES {

    static func validate(_ value: String) -> Bool {
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
