@preconcurrency import Benchmark
import InlineString

fileprivate nonisolated(unsafe) var emptyString = ""
fileprivate nonisolated(unsafe) var sourceString = "Berlin"

let initEmptyComparison = BenchmarkSuite(name: "init-empty") { suite in
    suite.benchmark("string") {
        for _ in 0..<1_000_000 {
            let value = ""
            consumeString(value)
        }
    }
    
    suite.benchmark("inline-string") {
        for _ in 0..<1_000_000 {
            let value = InlineString16()
            consumeInline(value)
        }
    }
    
    suite.benchmark("inline-string-validating") {
        for _ in 0..<1_000_000 {
            let value = InlineString16(validating: emptyString)!
            consumeInline(value)
        }
    }
    
    suite.benchmark("inline-string-string-literal") {
        for _ in 0..<1_000_000 {
            let value: InlineString16 = ""
            consumeInline(value)
        }
    }
}

let initComparison = BenchmarkSuite(name: "init") { suite in
    suite.benchmark("string-copy") {
        for _ in 0..<1_000_000 {
            let value = String(sourceString)
            consumeString(value)
        }
    }
    
    suite.benchmark("inline-string") {
        for _ in 0..<1_000_000 {
            let value = InlineString16(sourceString)
            consumeInline(value)
        }
    }
    
    suite.benchmark("inline-string-validating") {
        for _ in 0..<1_000_000 {
            let value = InlineString16(validating: sourceString)!
            consumeInline(value)
        }
    }
    
    suite.benchmark("inline-string-string-literal") {
        for _ in 0..<1_000_000 {
            let value: InlineString16 = "Berlin"
            consumeInline(value)
        }
    }
}
