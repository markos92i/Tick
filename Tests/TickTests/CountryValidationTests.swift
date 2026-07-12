import Testing
@testable import Tick

struct CountryValidationTests {

    // MARK: - National ID: Portugal (NIF)

    @Test(arguments: [
        "123456789",  // Valid: check digit 9
        "999999990",  // Valid: all 9s with check 0
        "501442600",  // Valid: legal entity (5xx)
        "272214345"   // Valid: individual
    ])
    func validPortugueseNIF(value: String) {
        let errors = Tick.validate(value, rules: [.required, .nationalID(.pt)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: [
        "123456780",  // Wrong check digit
        "000000000",  // Invalid first digit (0)
        "412345678",  // Invalid first digit (4)
        "12345678",   // Too short
        "1234567890", // Too long
        "12345678A",  // Contains letters
        "ABCDEFGHI"   // All letters
    ])
    func invalidPortugueseNIF(value: String) {
        let errors = Tick.validate(value, rules: [.required, .nationalID(.pt)])
        #expect(!errors.isEmpty)
    }

    // MARK: - National ID: Italy (Codice Fiscale)

    @Test(arguments: [
        "RSSMRA85M01H501Q",  // Valid: male, born 1985, Roma
        "BNCLRA70A01F205A",  // Valid: female, born 1970
        "VRDLGU90B15L219X"   // Valid: male, born 1990
    ])
    func validItalianCodiceFiscale(value: String) {
        let errors = Tick.validate(value, rules: [.required, .nationalID(.it)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: [
        "RSSMRA85M01H501A",  // Wrong check letter (should be Q)
        "RSSMRA85M01H5012",  // Last char is digit, not letter
        "RSSMRA85M01H50",    // Too short (15 chars)
        "RSSMRA85M01H501QQ", // Too long (17 chars)
        "ABCDEFGHIJKLMNOP"   // All letters, wrong check
    ])
    func invalidItalianCodiceFiscale(value: String) {
        let errors = Tick.validate(value, rules: [.required, .nationalID(.it)])
        #expect(!errors.isEmpty)
    }

    // MARK: - National ID: France (NIR)

    @Test(arguments: [
        "185057800501890",  // Valid: male, 1985, May, dept 78
        "254031702400595",  // Valid: female, 1954, March, dept 17
        "199072A00400406"   // Valid: Corsica 2A department
    ])
    func validFrenchNIR(value: String) {
        let errors = Tick.validate(value, rules: [.required, .nationalID(.fr)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: [
        "185057800501800",  // Wrong control key
        "254031702400500",  // Wrong control key
        "12345678901234",   // Too short (14 chars)
        "1234567890123456", // Too long (16 chars)
        "ABCDEFGHIJKLMNO",  // All letters
        "18505780050185X"   // Letter in wrong position
    ])
    func invalidFrenchNIR(value: String) {
        let errors = Tick.validate(value, rules: [.required, .nationalID(.fr)])
        #expect(!errors.isEmpty)
    }

    // MARK: - Social Security: Portugal (NISS)

    @Test(arguments: [
        "11234567892"   // Valid: check digit calculated from weights
    ])
    func validPortugueseNISS(value: String) {
        let errors = Tick.validate(value, rules: [.required, .socialSecurity(.pt)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: [
        "11234567890",  // Wrong check digit
        "1123456789",   // Too short (10 digits)
        "112345678901", // Too long (12 digits)
        "1123456789A",  // Contains letter
        "ABCDEFGHIJK"   // All letters
    ])
    func invalidPortugueseNISS(value: String) {
        let errors = Tick.validate(value, rules: [.required, .socialSecurity(.pt)])
        #expect(!errors.isEmpty)
    }

    // MARK: - Social Security: Italy (Codice Fiscale)

    @Test(arguments: ["RSSMRA85M01H501Q", "BNCLRA70A01F205A"])
    func validItalianSocialSecurity(value: String) {
        let errors = Tick.validate(value, rules: [.required, .socialSecurity(.it)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["RSSMRA85M01H501A", "INVALID"])
    func invalidItalianSocialSecurity(value: String) {
        let errors = Tick.validate(value, rules: [.required, .socialSecurity(.it)])
        #expect(!errors.isEmpty)
    }

    // MARK: - Social Security: France (NIR)

    @Test(arguments: ["185057800501890", "254031702400595"])
    func validFrenchSocialSecurity(value: String) {
        let errors = Tick.validate(value, rules: [.required, .socialSecurity(.fr)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["185057800501800", "12345678901234"])
    func invalidFrenchSocialSecurity(value: String) {
        let errors = Tick.validate(value, rules: [.required, .socialSecurity(.fr)])
        #expect(!errors.isEmpty)
    }

    // MARK: - Postal Code: Portugal

    @Test(arguments: ["1000-001", "4000-123", "9999-999"])
    func validPortuguesePostalCode(value: String) {
        let errors = Tick.validate(value, rules: [.required, .postalCode(.pt)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["1000001", "1000-0001", "ABCD-EFG", "100-001", "1000-00"])
    func invalidPortuguesePostalCode(value: String) {
        let errors = Tick.validate(value, rules: [.required, .postalCode(.pt)])
        #expect(!errors.isEmpty)
    }

    // MARK: - Postal Code: Italy

    @Test(arguments: ["00100", "20100", "80100", "90133"])
    func validItalianPostalCode(value: String) {
        let errors = Tick.validate(value, rules: [.required, .postalCode(.it)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["1234", "123456", "ABCDE", "0010A"])
    func invalidItalianPostalCode(value: String) {
        let errors = Tick.validate(value, rules: [.required, .postalCode(.it)])
        #expect(!errors.isEmpty)
    }

    // MARK: - Postal Code: France

    @Test(arguments: ["75001", "13001", "69001", "97100"])
    func validFrenchPostalCode(value: String) {
        let errors = Tick.validate(value, rules: [.required, .postalCode(.fr)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["7500", "750011", "ABCDE", "7500A"])
    func invalidFrenchPostalCode(value: String) {
        let errors = Tick.validate(value, rules: [.required, .postalCode(.fr)])
        #expect(!errors.isEmpty)
    }

    // MARK: - Postal Code: Andorra

    @Test(arguments: ["AD100", "AD500", "AD700"])
    func validAndorranPostalCode(value: String) {
        let errors = Tick.validate(value, rules: [.required, .postalCode(.ad)])
        #expect(errors.isEmpty)
    }

    @Test(arguments: ["AD10", "AD1000", "12345", "ADABC"])
    func invalidAndorranPostalCode(value: String) {
        let errors = Tick.validate(value, rules: [.required, .postalCode(.ad)])
        #expect(!errors.isEmpty)
    }

    // MARK: - Postal Code: Spain with province matching

    @Test func spanishPostalCode_matchesProvince() {
        let errors = Tick.validate("28001", rules: [.required, .postalCode(.es, province: "28")])
        #expect(errors.isEmpty)
    }

    @Test func spanishPostalCode_wrongProvince() {
        let errors = Tick.validate("28001", rules: [.required, .postalCode(.es, province: "08")])
        #expect(!errors.isEmpty)
    }
}
