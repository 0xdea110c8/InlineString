@preconcurrency import Benchmark
import InlineString

fileprivate nonisolated(unsafe) var inlineValues: [InlineString16] = [
    "Berlin",
    "London",
    "Tokyo",
    "Paris",
    "Moscow"
]

fileprivate nonisolated(unsafe) var stringValues: [String] = [
    "Berlin",
    "London",
    "Tokyo",
    "Paris",
    "Moscow"
]

let arraySearchComparison = BenchmarkSuite(name: "array-search") { suite in
    suite.benchmark("string") {
        var found = false

        for _ in 0..<1_000_000 {
            for value in stringValues {
                if value == "Tokyo" {
                    found = true
                }
            }
        }

        consumeBool(found)
    }

    suite.benchmark("inline-string") {
        var found = false

        for _ in 0..<1_000_000 {
            for value in inlineValues {
                if value == "Tokyo" {
                    found = true
                }
            }
        }

        consumeBool(found)
    }
}
