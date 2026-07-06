# Tick

![Swift 6.3](https://img.shields.io/badge/Swift-6.3-F05138?logo=swift&logoColor=white)
![iOS 18+](https://img.shields.io/badge/iOS-18%2B-007AFF)
![SPM](https://img.shields.io/badge/SPM-Compatible-blue)
![No Dependencies](https://img.shields.io/badge/Dependencies-None-green)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow)

A lightweight validation library for SwiftUI forms. Declare rules per field, validate in one call, get back only what failed. Supports IBAN, national IDs, social security numbers, postal codes, and custom validators.

## Features

- **Declarative rules** — Define validations as an array of `FieldType` cases
- **Single entry point** — `Tick.validate(_:validations:)` returns only failed rules
- **Smart empty handling** — Non-mandatory empty fields pass automatically
- **Built-in validators** — IBAN (ISO 13616), DNI/NIE, social security (NASS), postal codes, URLs
- **Regex patterns** — Name, email, phone, or custom regex
- **Extensible** — Add custom validators with a simple closure
- **Sendable** — All types are `Sendable`, safe for concurrent contexts
- **Zero dependencies** — Pure Swift, no external packages

## Installation

Add Tick to your project via Swift Package Manager:

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/markos92i/Tick.git", from: "1.0.0")
]
```

Or in Xcode: **File → Add Package Dependencies** → paste the repository URL.

## Quick Start

```swift
import Tick

let email = "user@example"
let failures = Tick.validate(email, validations: [.mandatory, .matches(.email)])

if failures.isEmpty {
    // Valid
} else {
    // Handle failures
}
```

## Validation Rules

| Rule | Description |
|------|-------------|
| `.mandatory` | Field must not be empty |
| `.min(n)` | Minimum character count |
| `.max(n)` | Maximum character count |
| `.matches(.email)` | Email format |
| `.matches(.name)` | Unicode name (letters, spaces, apostrophes) |
| `.matches(.phone)` | International phone (`+` or `00` prefix, 6-14 digits) |
| `.matches(.custom("regex"))` | Custom regex pattern |
| `.url` | Valid HTTP/HTTPS URL with host |
| `.numeric` | All characters are digits |
| `.equalTo { otherValue }` | Matches another value (e.g. password confirmation) |
| `.iban` | IBAN validation (ISO 13616, per-country length) |
| `.nationalID(.es)` | Spanish DNI/NIE validation |
| `.socialSecurity(.es)` | Spanish NASS (12-digit mod-97) |
| `.postalCode(.es)` | Spanish postal code (5 digits, province 01-52) |
| `.custom(predicate, message)` | Custom closure validator |

## Usage Examples

### Form validation

```swift
struct SignUpViewModel {
    func validateForm() -> [String: [FieldType]] {
        var errors: [String: [FieldType]] = [:]

        let emailErrors = Tick.validate(email, validations: [.mandatory, .matches(.email)])
        if !emailErrors.isEmpty { errors["email"] = emailErrors }

        let passErrors = Tick.validate(password, validations: [.mandatory, .min(8)])
        if !passErrors.isEmpty { errors["password"] = passErrors }

        let confirmErrors = Tick.validate(confirmPassword, validations: [
            .mandatory, .equalTo { self.password }
        ])
        if !confirmErrors.isEmpty { errors["confirm"] = confirmErrors }

        return errors
    }
}
```

### IBAN validation

```swift
let iban = "ES91 2100 0418 4502 0005 1332"
let result = Tick.validate(iban, validations: [.mandatory, .iban])
// result == [] → valid
```

### National ID (Spain)

```swift
let dni = "12345678Z"
let result = Tick.validate(dni, validations: [.mandatory, .nationalID(.es)])
```

### Custom validator

```swift
let age = "17"
let result = Tick.validate(age, validations: [
    .mandatory,
    .numeric,
    .custom({ Int($0).map { $0 >= 18 } ?? false }, "Must be 18+")
])
```

### Non-mandatory fields

Empty non-mandatory fields always pass — no unnecessary error messages:

```swift
let nickname = ""
let result = Tick.validate(nickname, validations: [.min(3), .max(20)])
// result == [] → valid (empty + not mandatory = skip)
```

## How It Works

`Tick.validate` follows a simple flow:

1. If the field is **empty and not mandatory** → return `[]` (pass)
2. If the field is **empty and mandatory** → return `[.mandatory]`
3. Otherwise → run all rules (except `.mandatory`) and return the ones that fail

This means you never get a `.min(3)` failure on an empty optional field.

## Supported Countries

Currently, country-specific validators support:

| Country | National ID | Social Security | Postal Code |
|---------|-------------|-----------------|-------------|
| Spain (`.es`) | DNI / NIE | NASS (12-digit) | 5-digit (01-52) |

IBAN validation supports all countries via ISO 13616 with per-country length enforcement.

## Requirements

| Requirement | Version |
|------------|---------|
| Swift | 6.3+ |
| iOS | 18.0+ |
| macOS | 15.0+ |
| Xcode | 26+ |

## License

Tick is available under the MIT license. See the [LICENSE](LICENSE) file for details.
