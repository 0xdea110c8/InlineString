@preconcurrency import Benchmark
import InlineString

fileprivate nonisolated(unsafe) var inlineEqualLeft: InlineString16 = "Berlin"
fileprivate nonisolated(unsafe) var inlineEqualRight: InlineString16 = "Berlin"
fileprivate nonisolated(unsafe) var inlineDifferent: InlineString16 = "London"
fileprivate nonisolated(unsafe) var stringEqualLeft = "Berlin"
fileprivate nonisolated(unsafe) var stringEqualRight = "Berlin"
fileprivate nonisolated(unsafe) var stringDifferent = "London"

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
