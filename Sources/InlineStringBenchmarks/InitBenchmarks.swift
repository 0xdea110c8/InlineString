@preconcurrency import Benchmark
import InlineString

nonisolated(unsafe) var sourceString = "Berlin"

let initBenchmarks = BenchmarkSuite(name: "Init") { suite in
    suite.benchmark("InlineString16 truncating") {
        for _ in 0..<1_000_000 {
            let value: InlineString16 = "Berlin"
            consumeInline(value)
        }
    }

    suite.benchmark("String copy") {
        for _ in 0..<1_000_000 {
            let value = String(sourceString)
            consumeString(value)
        }
    }
}
