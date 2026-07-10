//
//  SocialSecurity+IT.swift
//  Tick
//

/// Italian social security uses the Codice Fiscale — same validation as NationalIDIT.
/// 16 alphanumeric characters with odd/even check character algorithm.
enum SocialSecurityIT {

    static func validate(_ value: String) -> Bool {
        NationalIDIT.validate(value)
    }
}
