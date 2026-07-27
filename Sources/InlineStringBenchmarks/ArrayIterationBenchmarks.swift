@preconcurrency import Benchmark
import InlineString

fileprivate nonisolated(unsafe) var inlineArray: [InlineString16] = Array(
    repeating: "Berlin",
    count: 1_000_000
)

fileprivate nonisolated(unsafe) var stringArray: [String] = Array(
    repeating: "Berlin",
    count: 1_000_000
)

let arrayIterationComparison = BenchmarkSuite(name: "array-iteration") { suite in
    suite.benchmark("string") {
        var result = 0

        for value in stringArray {
            consumeString(value)
        }
    }
    
    suite.benchmark("inline-string") {
        var result = 0

        for value in inlineArray {
            consumeInline(value)
        }
    }
    
    suite.benchmark("string-count") {
        var result = 0
        
        for value in stringArray {
            result += value.utf8.count
        }
        
        consumeInt(result)
    }
    
    suite.benchmark("inline-string-count") {
        var result = 0
        
        for value in inlineArray {
            result += value.count
        }
        
        consumeInt(result)
    }
}
