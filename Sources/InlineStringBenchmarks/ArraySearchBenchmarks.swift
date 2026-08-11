@preconcurrency import Benchmark
import InlineString

private nonisolated(unsafe) var inlineValues: [InlineString16] = [
    "Berlin",
    "London",
    "Tokyo",
    "Paris",
    "Moscow",
]

private nonisolated(unsafe) var stringValues: [String] = [
    "Berlin",
    "London",
    "Tokyo",
    "Paris",
    "Moscow",
]

private nonisolated(unsafe) var inlineTarget: InlineString16 = "Tokyo"
private nonisolated(unsafe) var stringTarget = "Tokyo"

let arraySearchComparison = BenchmarkSuite(name: "array-search") { suite in
    suite.benchmark("string") {
        var found = false

        for _ in 0..<1_000_000 {
            for value in stringValues {
                if value == stringTarget {
                    found = true
                    break
                }
            }
        }

        consumeBool(found)
    }

    suite.benchmark("inline-string") {
        var found = false

        for _ in 0..<1_000_000 {
            for value in inlineValues {
                if value == inlineTarget {
                    found = true
                    break
                }
            }
        }

        consumeBool(found)
    }
}
