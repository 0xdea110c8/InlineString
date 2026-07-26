@preconcurrency import Benchmark
import InlineString

let inlineValues: [InlineString16] = [
    "Berlin",
    "London",
    "Tokyo",
    "Paris",
    "Moscow"
]

let stringValues: [String] = [
    "Berlin",
    "London",
    "Tokyo",
    "Paris",
    "Moscow"
]


let equalityArrayBenchmarks = BenchmarkSuite(
    name: "equality-array"
) { suite in

    suite.benchmark("inline-string-search") {
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


    suite.benchmark("string-search") {
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
}
