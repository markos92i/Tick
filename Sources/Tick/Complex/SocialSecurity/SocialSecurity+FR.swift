//
//  SocialSecurity+FR.swift
//  Tick
//

/// French Social Security Number is the NIR — same validation as NationalIDFR.
/// 15 characters: 13 digits + 2-digit control key (mod 97).
enum SocialSecurityFR {

    static func validate(_ value: String) -> Bool {
        NationalIDFR.validate(value)
    }
}
