import Testing
import Foundation
@testable import Tick

struct DateRuleTests {

    private let now = Date.now
    private var yesterday: Date { Calendar.current.date(byAdding: .day, value: -1, to: now)! }
    private var tomorrow: Date { Calendar.current.date(byAdding: .day, value: 1, to: now)! }
    private var lastYear: Date { Calendar.current.date(byAdding: .year, value: -1, to: now)! }

    // MARK: - min (date must be >= given date)

    @Test func min_dateAfterMin_passes() {
        let rules: [DateRule] = [.min(yesterday)]
        let errors = Tick.validate(tomorrow, rules: rules)
        #expect(errors.isEmpty)
    }

    @Test func min_dateEqualToMin_passes() {
        let date = yesterday
        let rules: [DateRule] = [.min(date)]
        let errors = Tick.validate(date, rules: rules)
        #expect(errors.isEmpty)
    }

    @Test func min_dateBeforeMin_fails() {
        let rules: [DateRule] = [.min(tomorrow)]
        let errors = Tick.validate(yesterday, rules: rules)
        #expect(!errors.isEmpty)
    }

    // MARK: - max (date must be <= given date)

    @Test func max_dateBeforeMax_passes() {
        let rules: [DateRule] = [.max(tomorrow)]
        let errors = Tick.validate(yesterday, rules: rules)
        #expect(errors.isEmpty)
    }

    @Test func max_dateEqualToMax_passes() {
        let date = tomorrow
        let rules: [DateRule] = [.max(date)]
        let errors = Tick.validate(date, rules: rules)
        #expect(errors.isEmpty)
    }

    @Test func max_dateAfterMax_fails() {
        let rules: [DateRule] = [.max(yesterday)]
        let errors = Tick.validate(tomorrow, rules: rules)
        #expect(!errors.isEmpty)
    }

    // MARK: - between

    @Test func between_dateInRange_passes() {
        let rules: [DateRule] = [.between(yesterday...tomorrow)]
        let errors = Tick.validate(now, rules: rules)
        #expect(errors.isEmpty)
    }

    @Test func between_dateOutOfRange_fails() {
        let rules: [DateRule] = [.between(yesterday...tomorrow)]
        let errors = Tick.validate(lastYear, rules: rules)
        #expect(!errors.isEmpty)
    }

    @Test func between_dateAtBounds_passes() {
        let rules: [DateRule] = [.between(yesterday...tomorrow)]
        #expect(Tick.validate(yesterday, rules: rules).isEmpty)
        #expect(Tick.validate(tomorrow, rules: rules).isEmpty)
    }

    // MARK: - custom

    @Test func custom_passing_passes() {
        let rules: [DateRule] = [.check({ $0 < Date.distantFuture }, "error")]
        let errors = Tick.validate(now, rules: rules)
        #expect(errors.isEmpty)
    }

    @Test func custom_failing_fails() {
        let rules: [DateRule] = [.check({ $0 > Date.distantFuture }, "error")]
        let errors = Tick.validate(now, rules: rules)
        #expect(!errors.isEmpty)
    }

    // MARK: - Optional handling

    @Test func optional_nil_skips() {
        let date: Date? = nil
        let rules: [DateRule] = [.min(now)]
        let errors = Tick.validate(date, rules: rules)
        #expect(errors.isEmpty)
    }

    @Test func optional_nonNil_validates() {
        let date: Date? = yesterday
        let rules: [DateRule] = [.min(tomorrow)]
        let errors = Tick.validate(date, rules: rules)
        #expect(!errors.isEmpty)
    }

    // MARK: - Multiple rules

    @Test func multipleRules_allPassing() {
        let rules: [DateRule] = [.min(yesterday), .max(tomorrow)]
        let errors = Tick.validate(now, rules: rules)
        #expect(errors.isEmpty)
    }

    @Test func multipleRules_oneFailing() {
        let rules: [DateRule] = [.min(yesterday), .max(tomorrow)]
        let errors = Tick.validate(lastYear, rules: rules)
        #expect(errors.count == 1)
    }
}
