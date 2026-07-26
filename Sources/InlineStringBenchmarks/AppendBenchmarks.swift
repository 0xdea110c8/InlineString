@preconcurrency import Benchmark
import InlineString

nonisolated(unsafe) var appendSource = "Berlin"

let appendBenchmarks = BenchmarkSuite(
    name: "Append"
) { suite in

    suite.benchmark("InlineString16") {
        for _ in 0..<1_000_000 {
            var value: InlineString16 = ""
            value.append(appendSource)
            consumeInline(value)
        }
    }
    
    suite.benchmark("String") {
        for _ in 0..<1_000_000 {
            var value = ""
            value.append(appendSource)
            consumeString(value)
        }
    }
}
