import Testing
@testable import Tick

struct TickTests {

    // MARK: - Short-circuit behavior

    @Test func emptyOptionalField_skipsAllValidations() {
        let errors = Tick.validate("", rules: [.min(3), .matches(.email)])
        #expect(errors.isEmpty)
    }

    @Test func emptyRequiredField_onlyReturnsRequired() {
        let errors = Tick.validate("", rules: [.required, .min(3), .matches(.email)])
        #expect(errors.count == 1)
        #expect(errors.first.map { if case .required = $0 { true } else { false } } == true)
    }

    @Test func filledRequiredField_skipsRequiredRule() {
        let errors = Tick.validate("hello", rules: [.required])
        #expect(errors.isEmpty)
    }

    // MARK: - Required

    @Test func required_empty_fails() {
        let errors = Tick.validate("", rules: [.required])
        #expect(!errors.isEmpty)
    }

    @Test func required_filled_passes() {
        let errors = Tick.validate("x", rules: [.required])
        #expect(errors.isEmpty)
    }

    // MARK: - Min / Max

    @Test(arguments: [("ab", 3, true), ("abc", 3, false), ("abcd", 3, false)])
    func minLength(value: String, min: Int, shouldFail: Bool) {
        let errors = Tick.validate(value, rules: [.required, .min(min)])
        #expect(errors.isEmpty != shouldFail)
    }

    @Test(arguments: [("abcdef", 5, true), ("abcde", 5, false), ("abc", 5, false)])
    func maxLength(value: String, max: Int, shouldFail: Bool) {
        let errors = Tick.validate(value, rules: [.required, .max(max)])
        #expect(errors.isEmpty != shouldFail)
    }

    @Test func minOnOptionalEmpty_passes() {
        let errors = Tick.validate("", rules: [.min(3)])
        #expect(errors.isEmpty)
    }

    @Test func minOnOptionalFilled_validates() {
        let errors = Tick.validate("ab", rules: [.min(3)])
        #expect(!errors.isEmpty)
    }

    // MARK: - Name regex

    @Test(arguments: ["John Doe", "María José", "Jean-Luc", "O'Connor", "Nguyễn", "김영희", "محمد", "Γιάννης", "Åsa", "Müller"])
    func validName(value: String) {
        let errors = Tick.validate(value, rules: [.matches(.name)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["John123", "John@Doe", "John_Doe", "John$Doe"])
    func invalidName(value: String) {
        let errors = Tick.validate(value, rules: [.matches(.name)])
        #expect(!errors.isEmpty)
    }

    // MARK: - Email regex

    @Test(arguments: ["john@example.com", "user.name+tag@domain.co.uk", "John_123@Doe.es"])
    func validEmail(value: String) {
        let errors = Tick.validate(value, rules: [.matches(.email)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["_leading@test.es", "john@", "@domain.com", "no-at-sign", "spaces in@email.com"])
    func invalidEmail(value: String) {
        let errors = Tick.validate(value, rules: [.matches(.email)])
        #expect(!errors.isEmpty)
    }

    // MARK: - Phone regex

    @Test(arguments: ["+34677555333", "0034677555333", "+1234567890123"])
    func validPhone(value: String) {
        let errors = Tick.validate(value, rules: [.matches(.phone)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["677555333", "+34", "abc", "+34 677 555 333"])
    func invalidPhone(value: String) {
        let errors = Tick.validate(value, rules: [.matches(.phone)])
        #expect(!errors.isEmpty)
    }

    // MARK: - Custom regex

    @Test func customRegex_matches() {
        let errors = Tick.validate("1234", rules: [.matches(.custom(#"^\d{4}$"#))])
        #expect(errors.isEmpty)
    }

    @Test func customRegex_noMatch() {
        let errors = Tick.validate("12a4", rules: [.matches(.custom(#"^\d{4}$"#))])
        #expect(!errors.isEmpty)
    }

    // MARK: - URL

    @Test(arguments: ["https://example.com", "http://sub.domain.org/path", "https://a.io"])
    func validURL(value: String) {
        let errors = Tick.validate(value, rules: [.matches(.url)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["not-a-url", "ftp://example.com", "https://", "example.com"])
    func invalidURL(value: String) {
        let errors = Tick.validate(value, rules: [.matches(.url)])
        #expect(!errors.isEmpty)
    }

    @Test func urlOptionalEmpty_passes() {
        let errors = Tick.validate("", rules: [.matches(.url)])
        #expect(errors.isEmpty)
    }

    // MARK: - Numeric

    @Test(arguments: ["12345", "0", "9999999"])
    func validNumeric(value: String) {
        let errors = Tick.validate(value, rules: [.matches(.numeric)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["12a45", "hello", "12.5", "12 34"])
    func invalidNumeric(value: String) {
        let errors = Tick.validate(value, rules: [.matches(.numeric)])
        #expect(!errors.isEmpty)
    }

    // MARK: - EqualTo

    @Test func equalTo_matches() {
        let errors = Tick.validate("password123", rules: [.equalTo { "password123" }])
        #expect(errors.isEmpty)
    }

    @Test func equalTo_differs() {
        let errors = Tick.validate("password123", rules: [.equalTo { "other" }])
        #expect(!errors.isEmpty)
    }

    @Test func equalTo_optionalEmpty_skips() {
        let errors = Tick.validate("", rules: [.equalTo { "something" }])
        #expect(errors.isEmpty)
    }

    // MARK: - IBAN

    @Test(arguments: ["ES5930042214135997744874", "ES59 3004 2214 1359 9774 4874", "DE89370400440532013000", "GB29NWBK60161331926819"])
    func validIBAN(value: String) {
        let errors = Tick.validate(value, rules: [.required, .iban])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["ES5930042214135997344874", "ES123", "INVALIDIBAN", "DE89370400440532013001"])
    func invalidIBAN(value: String) {
        let errors = Tick.validate(value, rules: [.required, .iban])
        #expect(!errors.isEmpty)
    }

    @Test func ibanOptionalEmpty_passes() {
        let errors = Tick.validate("", rules: [.iban])
        #expect(errors.isEmpty)
    }

    // MARK: - National ID (Spain)

    @Test(arguments: ["08988731D", "08988731d", "12345678Z", "X1234567L", "Y1234567X", "Z1234567R"])
    func validNationalID(value: String) {
        let errors = Tick.validate(value, rules: [.required, .nationalID(.es)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["08988731A", "12345678A", "X1234567A", "123", "ABCDEFGHI"])
    func invalidNationalID(value: String) {
        let errors = Tick.validate(value, rules: [.required, .nationalID(.es)])
        #expect(!errors.isEmpty)
    }

    // MARK: - Social Security (Spain)

    @Test(arguments: ["281234567840"])
    func validSocialSecurity(value: String) {
        let errors = Tick.validate(value, rules: [.required, .socialSecurity(.es)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["281234567843", "123", "ABCDEFGHIJKL", "000000000000"])
    func invalidSocialSecurity(value: String) {
        let errors = Tick.validate(value, rules: [.required, .socialSecurity(.es)])
        #expect(!errors.isEmpty)
    }

    // MARK: - Postal Code (Spain)

    @Test(arguments: ["28001", "08080", "01001", "52001"])
    func validPostalCode(value: String) {
        let errors = Tick.validate(value, rules: [.required, .postalCode(.es)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["00001", "53001", "1234", "ABCDE", "280010"])
    func invalidPostalCode(value: String) {
        let errors = Tick.validate(value, rules: [.required, .postalCode(.es)])
        #expect(!errors.isEmpty)
    }

    // MARK: - Check validation

    @Test func check_passing_passes() {
        let errors = Tick.validate("good", rules: [.check({ $0 != "bad" }, "no good")])
        #expect(errors.isEmpty)
    }

    @Test func check_failing_fails() {
        let errors = Tick.validate("bad", rules: [.check({ $0 != "bad" }, "no good")])
        #expect(!errors.isEmpty)
    }

    // MARK: - Multiple rules

    @Test func multipleRules_allFailing() {
        let errors = Tick.validate("a", rules: [.required, .min(3), .matches(.email)])
        #expect(errors.count == 2) // min + email (required passes because non-empty)
    }

    @Test func multipleRules_somePassing() {
        let errors = Tick.validate("abc", rules: [.required, .min(3), .matches(.email)])
        #expect(errors.count == 1) // only email fails
    }

    // MARK: - CharacterSet (.is)

    @Test(arguments: ["12345", "0", "999"])
    func is_decimalDigits_valid(value: String) {
        let errors = Tick.validate(value, rules: [.is(.decimalDigits)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["12a45", "hello", "12.5", "12 34"])
    func is_decimalDigits_invalid(value: String) {
        let errors = Tick.validate(value, rules: [.is(.decimalDigits)])
        #expect(!errors.isEmpty)
    }

    @Test(arguments: ["hello", "WORLD", "Café"])
    func is_letters_valid(value: String) {
        let errors = Tick.validate(value, rules: [.is(.letters)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["hello1", "AB CD", "test!"])
    func is_letters_invalid(value: String) {
        let errors = Tick.validate(value, rules: [.is(.letters)])
        #expect(!errors.isEmpty)
    }

    @Test func is_optionalEmpty_passes() {
        let errors = Tick.validate("", rules: [.is(.decimalDigits)])
        #expect(errors.isEmpty)
    }

    // MARK: - In

    @Test(arguments: ["DNI", "NIE", "Pasaporte"])
    func in_validOption(value: String) {
        let errors = Tick.validate(value, rules: [.in(["DNI", "NIE", "Pasaporte"])])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["dni", "Otro", "X"])
    func in_invalidOption(value: String) {
        let errors = Tick.validate(value, rules: [.in(["DNI", "NIE", "Pasaporte"])])
        #expect(!errors.isEmpty)
    }

    @Test func in_optionalEmpty_passes() {
        // Empty + not required → skip
        let errors = Tick.validate("", rules: [.in(["A", "B"])])
        #expect(errors.isEmpty)
    }

    // MARK: - Range

    @Test(arguments: ["18", "30", "65"])
    func range_validValue(value: String) {
        let errors = Tick.validate(value, rules: [.range(18...65)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["17", "66", "0", "100"])
    func range_invalidValue(value: String) {
        let errors = Tick.validate(value, rules: [.range(18...65)])
        #expect(!errors.isEmpty)
    }

    @Test func range_nonNumeric_fails() {
        let errors = Tick.validate("abc", rules: [.range(1...100)])
        #expect(!errors.isEmpty)
    }

    @Test func range_optionalEmpty_passes() {
        let errors = Tick.validate("", rules: [.range(1...100)])
        #expect(errors.isEmpty)
    }

    // MARK: - RequiredIf

    @Test func requiredIf_conditionTrue_emptyFails() {
        let errors = Tick.validate("", rules: [.requiredIf { true }])
        #expect(!errors.isEmpty)
    }

    @Test func requiredIf_conditionFalse_emptyPasses() {
        let errors = Tick.validate("", rules: [.requiredIf { false }])
        #expect(errors.isEmpty)
    }

    @Test func requiredIf_conditionTrue_filledPasses() {
        let errors = Tick.validate("value", rules: [.requiredIf { true }])
        #expect(errors.isEmpty)
    }

    // MARK: - Contains

    @Test func contains_present_passes() {
        let errors = Tick.validate("https://linkedin.com/in/user", rules: [.contains("linkedin.com")])
        #expect(errors.isEmpty)
    }

    @Test func contains_absent_fails() {
        let errors = Tick.validate("https://facebook.com/user", rules: [.contains("linkedin.com")])
        #expect(!errors.isEmpty)
    }

    @Test func contains_optionalEmpty_passes() {
        let errors = Tick.validate("", rules: [.contains("test")])
        #expect(errors.isEmpty)
    }

    // MARK: - Prefix

    @Test func prefix_correct_passes() {
        let errors = Tick.validate("https://example.com", rules: [.prefix("https://")])
        #expect(errors.isEmpty)
    }

    @Test func prefix_wrong_fails() {
        let errors = Tick.validate("http://example.com", rules: [.prefix("https://")])
        #expect(!errors.isEmpty)
    }

    @Test func prefix_optionalEmpty_passes() {
        let errors = Tick.validate("", rules: [.prefix("https://")])
        #expect(errors.isEmpty)
    }

    // MARK: - Suffix

    @Test func suffix_correct_passes() {
        let errors = Tick.validate("document.pdf", rules: [.suffix(".pdf")])
        #expect(errors.isEmpty)
    }

    @Test func suffix_wrong_fails() {
        let errors = Tick.validate("document.doc", rules: [.suffix(".pdf")])
        #expect(!errors.isEmpty)
    }

    @Test func suffix_optionalEmpty_passes() {
        let errors = Tick.validate("", rules: [.suffix(".pdf")])
        #expect(errors.isEmpty)
    }

    // MARK: - Decimal pattern

    @Test(arguments: ["123", "0", "99999"])
    func decimal_integers_valid(value: String) {
        let errors = Tick.validate(value, rules: [.matches(.decimal)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["abc", "12.34.56", "1,2,3"])
    func decimal_invalid(value: String) {
        let errors = Tick.validate(value, rules: [.matches(.decimal)])
        #expect(!errors.isEmpty)
    }

    @Test func decimal_optionalEmpty_passes() {
        let errors = Tick.validate("", rules: [.matches(.decimal)])
        #expect(errors.isEmpty)
    }
}
