@preconcurrency import Benchmark
import InlineString

private nonisolated(unsafe) var inlineEqualLeft: InlineString16 = "Berlin"
private nonisolated(unsafe) var inlineEqualRight: InlineString16 = "Berlin"
private nonisolated(unsafe) var inlineDifferent: InlineString16 = "London"
private nonisolated(unsafe) var stringEqualLeft = "Berlin"
private nonisolated(unsafe) var stringEqualRight = "Berlin"
private nonisolated(unsafe) var stringDifferent = "London"

let equalityComparison = BenchmarkSuite(name: "equality") { suite in
    suite.benchmark("equal-strings") {
        for _ in 0..<1_000_000 {
            let result = stringEqualLeft == stringEqualRight
            consumeBool(result)
        }
    }

    suite.benchmark("equal-inline-strings") {
        for _ in 0..<1_000_000 {
            let result = inlineEqualLeft == inlineEqualRight
            consumeBool(result)
        }
    }

    suite.benchmark("different-strings") {
        for _ in 0..<1_000_000 {
            let result = stringEqualLeft == stringDifferent
            consumeBool(result)
        }
    }

    suite.benchmark("different-inline-strings") {
        for _ in 0..<1_000_000 {
            let result = inlineEqualLeft == inlineDifferent
            consumeBool(result)
        }
    }
}
