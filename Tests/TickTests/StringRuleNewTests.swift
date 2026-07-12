import Testing
@testable import Tick

struct StringRuleNewTests {

    // MARK: - count (exact length)

    @Test(arguments: [("12345", 5, true), ("1234", 5, false), ("123456", 5, false)])
    func count(value: String, count: Int, shouldPass: Bool) {
        let errors = Tick.validate(value, rules: [.required, .count(count)])
        #expect(errors.isEmpty == shouldPass)
    }

    @Test func count_optionalEmpty_passes() {
        let errors = Tick.validate("", rules: [.count(5)])
        #expect(errors.isEmpty)
    }

    // MARK: - passes(_:) direct method

    @Test func passes_required_emptyFails() {
        #expect(!StringRule.required.passes(""))
    }

    @Test func passes_required_spacesOnlyFails() {
        #expect(!StringRule.required.passes("   "))
    }

    @Test func passes_required_filledPasses() {
        #expect(StringRule.required.passes("hello"))
    }

    @Test func passes_min_correct() {
        #expect(StringRule.min(3).passes("abc"))
        #expect(!StringRule.min(3).passes("ab"))
    }

    @Test func passes_max_correct() {
        #expect(StringRule.max(3).passes("abc"))
        #expect(!StringRule.max(3).passes("abcd"))
    }

    @Test func passes_count_correct() {
        #expect(StringRule.count(4).passes("abcd"))
        #expect(!StringRule.count(4).passes("abc"))
        #expect(!StringRule.count(4).passes("abcde"))
    }

    // MARK: - isRequired

    @Test func isRequired_correct() {
        #expect(StringRule.required.isRequired == true)
        #expect(StringRule.requiredIf({ true }).isRequired == true)
        #expect(StringRule.min(3).isRequired == false)
        #expect(StringRule.matches(.email).isRequired == false)
        #expect(StringRule.check({ _ in true }, "x").isRequired == false)
    }


}
