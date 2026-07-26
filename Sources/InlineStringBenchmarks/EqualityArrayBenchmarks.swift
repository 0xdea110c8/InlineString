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
    name: "Equality array"
) { suite in

    suite.benchmark("InlineString16 search") {
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


    suite.benchmark("String search") {
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
