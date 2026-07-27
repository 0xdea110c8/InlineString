@preconcurrency import Benchmark
import InlineString

fileprivate nonisolated(unsafe) var inlineValue: InlineString16 = "Berlin"
fileprivate nonisolated(unsafe) var stringValue = "Berlin"

let accessCountComparison = BenchmarkSuite(name: "access-count") { suite in
    suite.benchmark("string") {
        var count = 0
        for _ in 0..<1000000 {
            count += stringValue.utf8.count
            consumeInt(count)
        }
    }
    
    suite.benchmark("inline-string") {
        var count = 0
        for _ in 0..<1000000 {
            count += inlineValue.count
            consumeInt(count)
        }
        
    }
}
