import Testing
@testable import Tick

struct CollectionRuleTests {

    // MARK: - required

    @Test func required_nonEmpty_passes() {
        let errors = Tick.validate(collection: [1, 2, 3], rules: [.required])
        #expect(errors.isEmpty)
    }

    @Test func required_empty_fails() {
        let errors = Tick.validate(collection: [Int](), rules: [.required])
        #expect(!errors.isEmpty)
    }

    // MARK: - skip-if-empty logic

    @Test func notRequired_empty_skips() {
        let errors = Tick.validate(collection: [Int](), rules: [.min(2)])
        #expect(errors.isEmpty)
    }

    @Test func required_empty_onlyReturnsRequired() {
        let errors = Tick.validate(collection: [Int](), rules: [.required, .min(2), .max(5)])
        #expect(errors.count == 1)
        #expect(errors.first.map { if case .required = $0 { true } else { false } } == true)
    }

    // MARK: - min

    @Test(arguments: [(3, 2, true), (2, 2, true), (1, 2, false)])
    func min(count: Int, min: Int, shouldPass: Bool) {
        let collection = Array(repeating: "x", count: count)
        let errors = Tick.validate(collection: collection, rules: [.required, .min(min)])
        #expect(errors.isEmpty == shouldPass)
    }

    // MARK: - max

    @Test(arguments: [(3, 5, true), (5, 5, true), (6, 5, false)])
    func max(count: Int, max: Int, shouldPass: Bool) {
        let collection = Array(repeating: "x", count: count)
        let errors = Tick.validate(collection: collection, rules: [.required, .max(max)])
        #expect(errors.isEmpty == shouldPass)
    }

    // MARK: - count (exact)

    @Test(arguments: [(3, 3, true), (2, 3, false), (4, 3, false)])
    func count(count: Int, exact: Int, shouldPass: Bool) {
        let collection = Array(repeating: "x", count: count)
        let errors = Tick.validate(collection: collection, rules: [.required, .count(exact)])
        #expect(errors.isEmpty == shouldPass)
    }

    // MARK: - check (receives full collection)

    @Test func check_passing_passes() {
        let collection = [2, 4, 6, 8]
        let rules: [CollectionRule<Int>] = [.required, .check({ $0.allSatisfy { $0 % 2 == 0 } }, "all must be even")]
        let errors = Tick.validate(collection: collection, rules: rules)
        #expect(errors.isEmpty)
    }

    @Test func check_failing_fails() {
        let collection = [2, 3, 6, 8]
        let rules: [CollectionRule<Int>] = [.required, .check({ $0.allSatisfy { $0 % 2 == 0 } }, "all must be even")]
        let errors = Tick.validate(collection: collection, rules: rules)
        #expect(!errors.isEmpty)
    }

    @Test func check_canInspectElements() {
        let files = [("doc.pdf", 1024), ("img.png", 5000)]
        let maxSize = 3000
        let rules: [CollectionRule<(String, Int)>] = [
            .required,
            .check({ $0.allSatisfy { $0.1 <= maxSize } }, "file too large")
        ]
        let errors = Tick.validate(collection: files, rules: rules)
        #expect(!errors.isEmpty) // img.png exceeds maxSize
    }

    // MARK: - Multiple rules

    @Test func multipleRules_allPass() {
        let errors = Tick.validate(collection: [1, 2, 3], rules: [.required, .min(2), .max(5)])
        #expect(errors.isEmpty)
    }

    @Test func multipleRules_oneFails() {
        let errors = Tick.validate(collection: [1, 2, 3, 4, 5, 6], rules: [.required, .min(2), .max(5)])
        #expect(errors.count == 1)
    }
}
