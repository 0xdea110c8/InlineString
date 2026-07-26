@preconcurrency import Benchmark
import InlineString

nonisolated(unsafe) var sourceString = "Berlin"

let initBenchmarks = BenchmarkSuite(name: "init") { suite in
    suite.benchmark("inline-string-empty") {
        for _ in 0..<1_000_000 {
            let value = InlineString16()
            consumeInline(value)
        }
    }

    suite.benchmark("string-empty") {
        for _ in 0..<1_000_000 {
            let value = ""
            consumeString(value)
        }
    }
    
    suite.benchmark("inline-string-truncating") {
        for _ in 0..<1_000_000 {
            let value = InlineString16(truncating: sourceString)
            consumeInline(value)
        }
    }

    suite.benchmark("string-copy") {
        for _ in 0..<1_000_000 {
            let value = String(sourceString)
            consumeString(value)
        }
    }
}
