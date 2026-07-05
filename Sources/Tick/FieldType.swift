//
//  FieldType.swift
//  Tick
//

import Foundation

public enum FieldType: Sendable {
    case mandatory
    case min(Int)
    case max(Int)
    case matches(RegexType)
    case url
    case numeric
    case equalTo(@Sendable () -> String)
    case iban
    case nationalID(Country)
    case socialSecurity(Country)
    case postalCode(Country)
    case custom(@Sendable (String) -> Bool, String)
}
