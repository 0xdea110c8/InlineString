@preconcurrency import Benchmark
import InlineString

nonisolated(unsafe) var inlineString: InlineString16 = "London"
nonisolated(unsafe) var string: String = "London"

let copyBenchmarks = BenchmarkSuite(name: "Copy-x1_000_000") { suite in
    suite.benchmark("InlineString16") {
        for _ in 0..<1_000_000 {
            let value: InlineString16 = inlineString
            let copy = value
            consumeInline(copy)
        }
    }
    
    suite.benchmark("String") {
        for _ in 0..<1_000_000 {
            let value: String = string
            let copy = value
            consumeString(copy)
        }
    }
}
