@preconcurrency import Benchmark
import InlineString

nonisolated(unsafe) var inlineEqualLeft: InlineString16 = "Berlin"
nonisolated(unsafe) var inlineEqualRight: InlineString16 = "Berlin"
nonisolated(unsafe) var inlineDifferent: InlineString16 = "London"
nonisolated(unsafe) var stringEqualLeft = "Berlin"
nonisolated(unsafe) var stringEqualRight = "Berlin"
nonisolated(unsafe) var stringDifferent = "London"

let equalityBenchmarks = BenchmarkSuite(
    name: "Equality"
) { suite in

    suite.benchmark("InlineString16 equal") {
        for _ in 0..<1_000_000 {
            let result = inlineEqualLeft == inlineEqualRight
            consumeBool(result)
        }
    }

    suite.benchmark("String equal") {
        for _ in 0..<1_000_000 {
            let result = stringEqualLeft == stringEqualRight
            consumeBool(result)
        }
    }


    suite.benchmark("InlineString16 different") {
        for _ in 0..<1_000_000 {
            let result = inlineEqualLeft == inlineDifferent
            consumeBool(result)
        }
    }

    suite.benchmark("String different") {
        for _ in 0..<1_000_000 {
            let result = stringEqualLeft == stringDifferent
            consumeBool(result)
        }
    }
}

