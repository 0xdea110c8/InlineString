@preconcurrency import Benchmark
import InlineString
import Foundation

fileprivate let inlineString = InlineString16("1234567890123456")
fileprivate let string = String("123456789012345")

let hashComparison = BenchmarkSuite(name: "hash-value") { suite in
    suite.benchmark("string") {
        for _ in 0..<1_000_000 {
            let hash = string.hashValue
            consumeInt(hash)
        }
    }
    
    suite.benchmark("inline-string") {
        for _ in 0..<1_000_000 {
            let hash = inlineString.hashValue
            consumeInt(hash)
        }
    }
}
