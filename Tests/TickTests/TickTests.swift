import Testing
@testable import Tick

struct TickTests {

    // MARK: - Short-circuit behavior

    @Test func emptyOptionalField_skipsAllValidations() {
        let errors = Tick.validate("", validations: [.min(3), .matches(.email)])
        #expect(errors.isEmpty)
    }

    @Test func emptyMandatoryField_onlyReturnsMandatory() {
        let errors = Tick.validate("", validations: [.mandatory, .min(3), .matches(.email)])
        #expect(errors.count == 1)
        #expect(errors.first.map { if case .mandatory = $0 { true } else { false } } == true)
    }

    @Test func filledMandatoryField_skipsMandatoryRule() {
        let errors = Tick.validate("hello", validations: [.mandatory])
        #expect(errors.isEmpty)
    }

    // MARK: - Mandatory

    @Test func mandatory_empty_fails() {
        let errors = Tick.validate("", validations: [.mandatory])
        #expect(!errors.isEmpty)
    }

    @Test func mandatory_filled_passes() {
        let errors = Tick.validate("x", validations: [.mandatory])
        #expect(errors.isEmpty)
    }

    // MARK: - Min / Max

    @Test(arguments: [("ab", 3, true), ("abc", 3, false), ("abcd", 3, false)])
    func minLength(value: String, min: Int, shouldFail: Bool) {
        let errors = Tick.validate(value, validations: [.mandatory, .min(min)])
        #expect(errors.isEmpty != shouldFail)
    }

    @Test(arguments: [("abcdef", 5, true), ("abcde", 5, false), ("abc", 5, false)])
    func maxLength(value: String, max: Int, shouldFail: Bool) {
        let errors = Tick.validate(value, validations: [.mandatory, .max(max)])
        #expect(errors.isEmpty != shouldFail)
    }

    @Test func minOnOptionalEmpty_passes() {
        let errors = Tick.validate("", validations: [.min(3)])
        #expect(errors.isEmpty)
    }

    @Test func minOnOptionalFilled_validates() {
        let errors = Tick.validate("ab", validations: [.min(3)])
        #expect(!errors.isEmpty)
    }

    // MARK: - Name regex

    @Test(arguments: ["John Doe", "María José", "Jean-Luc", "O'Connor", "Nguyễn", "김영희", "محمد", "Γιάννης", "Åsa", "Müller"])
    func validName(value: String) {
        let errors = Tick.validate(value, validations: [.matches(.name)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["John123", "John@Doe", "John_Doe", "John$Doe"])
    func invalidName(value: String) {
        let errors = Tick.validate(value, validations: [.matches(.name)])
        #expect(!errors.isEmpty)
    }

    // MARK: - Email regex

    @Test(arguments: ["john@example.com", "user.name+tag@domain.co.uk", "John_123@Doe.es"])
    func validEmail(value: String) {
        let errors = Tick.validate(value, validations: [.matches(.email)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["_leading@test.es", "john@", "@domain.com", "no-at-sign", "spaces in@email.com"])
    func invalidEmail(value: String) {
        let errors = Tick.validate(value, validations: [.matches(.email)])
        #expect(!errors.isEmpty)
    }

    // MARK: - Phone regex

    @Test(arguments: ["+34677555333", "0034677555333", "+1234567890123"])
    func validPhone(value: String) {
        let errors = Tick.validate(value, validations: [.matches(.phone)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["677555333", "+34", "abc", "+34 677 555 333"])
    func invalidPhone(value: String) {
        let errors = Tick.validate(value, validations: [.matches(.phone)])
        #expect(!errors.isEmpty)
    }

    // MARK: - Custom regex

    @Test func customRegex_matches() {
        let errors = Tick.validate("1234", validations: [.matches(.custom(#"^\d{4}$"#))])
        #expect(errors.isEmpty)
    }

    @Test func customRegex_noMatch() {
        let errors = Tick.validate("12a4", validations: [.matches(.custom(#"^\d{4}$"#))])
        #expect(!errors.isEmpty)
    }

    // MARK: - URL

    @Test(arguments: ["https://example.com", "http://sub.domain.org/path", "https://a.io"])
    func validURL(value: String) {
        let errors = Tick.validate(value, validations: [.matches(.url)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["not-a-url", "ftp://example.com", "https://", "example.com"])
    func invalidURL(value: String) {
        let errors = Tick.validate(value, validations: [.matches(.url)])
        #expect(!errors.isEmpty)
    }

    @Test func urlOptionalEmpty_passes() {
        let errors = Tick.validate("", validations: [.matches(.url)])
        #expect(errors.isEmpty)
    }

    // MARK: - Numeric

    @Test(arguments: ["12345", "0", "9999999"])
    func validNumeric(value: String) {
        let errors = Tick.validate(value, validations: [.matches(.numeric)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["12a45", "hello", "12.5", "12 34"])
    func invalidNumeric(value: String) {
        let errors = Tick.validate(value, validations: [.matches(.numeric)])
        #expect(!errors.isEmpty)
    }

    // MARK: - EqualTo

    @Test func equalTo_matches() {
        let errors = Tick.validate("password123", validations: [.equalTo { "password123" }])
        #expect(errors.isEmpty)
    }

    @Test func equalTo_differs() {
        let errors = Tick.validate("password123", validations: [.equalTo { "other" }])
        #expect(!errors.isEmpty)
    }

    @Test func equalTo_optionalEmpty_skips() {
        let errors = Tick.validate("", validations: [.equalTo { "something" }])
        #expect(errors.isEmpty)
    }

    // MARK: - IBAN

    @Test(arguments: ["ES5930042214135997744874", "ES59 3004 2214 1359 9774 4874", "DE89370400440532013000", "GB29NWBK60161331926819"])
    func validIBAN(value: String) {
        let errors = Tick.validate(value, validations: [.mandatory, .iban])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["ES5930042214135997344874", "ES123", "INVALIDIBAN", "DE89370400440532013001"])
    func invalidIBAN(value: String) {
        let errors = Tick.validate(value, validations: [.mandatory, .iban])
        #expect(!errors.isEmpty)
    }

    @Test func ibanOptionalEmpty_passes() {
        let errors = Tick.validate("", validations: [.iban])
        #expect(errors.isEmpty)
    }

    // MARK: - National ID (Spain)

    @Test(arguments: ["08988731D", "08988731d", "12345678Z", "X1234567L", "Y1234567X", "Z1234567R"])
    func validNationalID(value: String) {
        let errors = Tick.validate(value, validations: [.mandatory, .nationalID(.es)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["08988731A", "12345678A", "X1234567A", "123", "ABCDEFGHI"])
    func invalidNationalID(value: String) {
        let errors = Tick.validate(value, validations: [.mandatory, .nationalID(.es)])
        #expect(!errors.isEmpty)
    }

    // MARK: - Social Security (Spain)

    @Test(arguments: ["281234567840"])
    func validSocialSecurity(value: String) {
        let errors = Tick.validate(value, validations: [.mandatory, .socialSecurity(.es)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["281234567843", "123", "ABCDEFGHIJKL", "000000000000"])
    func invalidSocialSecurity(value: String) {
        let errors = Tick.validate(value, validations: [.mandatory, .socialSecurity(.es)])
        #expect(!errors.isEmpty)
    }

    // MARK: - Postal Code (Spain)

    @Test(arguments: ["28001", "08080", "01001", "52001"])
    func validPostalCode(value: String) {
        let errors = Tick.validate(value, validations: [.mandatory, .postalCode(.es)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["00001", "53001", "1234", "ABCDE", "280010"])
    func invalidPostalCode(value: String) {
        let errors = Tick.validate(value, validations: [.mandatory, .postalCode(.es)])
        #expect(!errors.isEmpty)
    }

    // MARK: - Custom validation

    @Test func custom_predicateTrue_fails() {
        let errors = Tick.validate("bad", validations: [.custom({ $0 == "bad" }, "no good")])
        #expect(!errors.isEmpty)
    }

    @Test func custom_predicateFalse_passes() {
        let errors = Tick.validate("good", validations: [.custom({ $0 == "bad" }, "no good")])
        #expect(errors.isEmpty)
    }

    // MARK: - Multiple rules

    @Test func multipleRules_allFailing() {
        let errors = Tick.validate("a", validations: [.mandatory, .min(3), .matches(.email)])
        #expect(errors.count == 2) // min + email (mandatory passes because non-empty)
    }

    @Test func multipleRules_somePassing() {
        let errors = Tick.validate("abc", validations: [.mandatory, .min(3), .matches(.email)])
        #expect(errors.count == 1) // only email fails
    }
}
