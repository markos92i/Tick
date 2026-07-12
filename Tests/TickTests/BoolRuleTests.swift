import Testing
@testable import Tick

struct BoolRuleTests {

    // MARK: - mustBeTrue

    @Test func mustBeTrue_true_passes() {
        let rules: [BoolRule] = [.mustBeTrue]
        let errors = Tick.validate(true, rules: rules)
        #expect(errors.isEmpty)
    }

    @Test func mustBeTrue_false_fails() {
        let rules: [BoolRule] = [.mustBeTrue]
        let errors = Tick.validate(false, rules: rules)
        #expect(!errors.isEmpty)
    }

    // MARK: - custom

    @Test func custom_passing_passes() {
        let rules: [BoolRule] = [.check({ $0 }, "must be true")]
        let errors = Tick.validate(true, rules: rules)
        #expect(errors.isEmpty)
    }

    @Test func custom_failing_fails() {
        let rules: [BoolRule] = [.check({ $0 }, "must be true")]
        let errors = Tick.validate(false, rules: rules)
        #expect(!errors.isEmpty)
    }

    // MARK: - isRequired is always false

    @Test func isRequired_alwaysFalse() {
        #expect(BoolRule.mustBeTrue.isRequired == false)
        #expect(BoolRule.check({ _ in true }, "x").isRequired == false)
    }
}
