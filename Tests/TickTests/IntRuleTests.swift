import Testing
@testable import Tick

struct IntRuleTests {

    // MARK: - min

    @Test(arguments: [(5, 3, true), (3, 3, true), (2, 3, false)])
    func min(value: Int, min: Int, shouldPass: Bool) {
        let rules: [IntRule] = [.min(min)]
        let errors = Tick.validate(value, rules: rules)
        #expect(errors.isEmpty == shouldPass)
    }

    // MARK: - max

    @Test(arguments: [(3, 5, true), (5, 5, true), (6, 5, false)])
    func max(value: Int, max: Int, shouldPass: Bool) {
        let rules: [IntRule] = [.max(max)]
        let errors = Tick.validate(value, rules: rules)
        #expect(errors.isEmpty == shouldPass)
    }

    // MARK: - between

    @Test(arguments: [(5, 1...10, true), (1, 1...10, true), (10, 1...10, true), (0, 1...10, false), (11, 1...10, false)])
    func between(value: Int, range: ClosedRange<Int>, shouldPass: Bool) {
        let rules: [IntRule] = [.between(range)]
        let errors = Tick.validate(value, rules: rules)
        #expect(errors.isEmpty == shouldPass)
    }

    // MARK: - custom

    @Test func custom_passing_passes() {
        let rules: [IntRule] = [.check({ $0 % 2 == 0 }, "must be even")]
        let errors = Tick.validate(4, rules: rules)
        #expect(errors.isEmpty)
    }

    @Test func custom_failing_fails() {
        let rules: [IntRule] = [.check({ $0 % 2 == 0 }, "must be even")]
        let errors = Tick.validate(3, rules: rules)
        #expect(!errors.isEmpty)
    }

    // MARK: - Optional handling

    @Test func optional_nil_skips() {
        let value: Int? = nil
        let rules: [IntRule] = [.min(5)]
        let errors = Tick.validate(value, rules: rules)
        #expect(errors.isEmpty)
    }

    @Test func optional_nonNil_validates() {
        let value: Int? = 3
        let rules: [IntRule] = [.min(5)]
        let errors = Tick.validate(value, rules: rules)
        #expect(!errors.isEmpty)
    }

    @Test func optional_nonNil_passes() {
        let value: Int? = 10
        let rules: [IntRule] = [.min(5)]
        let errors = Tick.validate(value, rules: rules)
        #expect(errors.isEmpty)
    }

    // MARK: - Multiple rules

    @Test func multipleRules_allPass() {
        let rules: [IntRule] = [.min(1), .max(10)]
        let errors = Tick.validate(5, rules: rules)
        #expect(errors.isEmpty)
    }

    @Test func multipleRules_oneFails() {
        let rules: [IntRule] = [.min(1), .max(10)]
        let errors = Tick.validate(15, rules: rules)
        #expect(errors.count == 1)
    }

    @Test func multipleRules_allFail() {
        let rules: [IntRule] = [.min(5), .between(10...20)]
        let errors = Tick.validate(0, rules: rules)
        #expect(errors.count == 2)
    }
}
