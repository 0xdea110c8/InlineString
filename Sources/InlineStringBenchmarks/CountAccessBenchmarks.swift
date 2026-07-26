@preconcurrency import Benchmark
import InlineString

nonisolated(unsafe) var inlineValue: InlineString16 = "Berlin"
nonisolated(unsafe) var stringValue = "Berlin"

let countAccessBenchmarks = BenchmarkSuite(name: "access") { suite in
    suite.benchmark("inline-string-count") {
        var count = 0
        for _ in 0..<1000000 {
            count += inlineValue.count
            consumeInt(count)
        }
        
    }

    suite.benchmark("string-count") {
        var count = 0
        for _ in 0..<1000000 {
            count += stringValue.utf8.count
            consumeInt(count)
        }
    }
}
