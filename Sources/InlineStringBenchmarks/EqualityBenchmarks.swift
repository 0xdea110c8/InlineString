@preconcurrency import Benchmark
import InlineString

nonisolated(unsafe) var inlineEqualLeft: InlineString16 = "Berlin"
nonisolated(unsafe) var inlineEqualRight: InlineString16 = "Berlin"
nonisolated(unsafe) var inlineDifferent: InlineString16 = "London"
nonisolated(unsafe) var stringEqualLeft = "Berlin"
nonisolated(unsafe) var stringEqualRight = "Berlin"
nonisolated(unsafe) var stringDifferent = "London"

let equalityBenchmarks = BenchmarkSuite(
    name: "equality"
) { suite in

    suite.benchmark("inline-string-equal") {
        for _ in 0..<1_000_000 {
            let result = inlineEqualLeft == inlineEqualRight
            consumeBool(result)
        }
    }

    suite.benchmark("string-equal") {
        for _ in 0..<1_000_000 {
            let result = stringEqualLeft == stringEqualRight
            consumeBool(result)
        }
    }


    suite.benchmark("inline-string-different") {
        for _ in 0..<1_000_000 {
            let result = inlineEqualLeft == inlineDifferent
            consumeBool(result)
        }
    }

    suite.benchmark("string-different") {
        for _ in 0..<1_000_000 {
            let result = stringEqualLeft == stringDifferent
            consumeBool(result)
        }
    }
}

