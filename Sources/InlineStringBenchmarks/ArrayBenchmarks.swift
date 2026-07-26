@preconcurrency import Benchmark
import InlineString

nonisolated(unsafe) var inlineArray: [InlineString16] = Array(
    repeating: "Berlin",
    count: 1_000_000
)

nonisolated(unsafe) var stringArray: [String] = Array(
    repeating: "Berlin",
    count: 1_000_000
)

let arrayBenchmarks = BenchmarkSuite(name: "array-traversal") { suite in
    suite.benchmark("inline-string-iterate") {
        var result = 0

        for value in inlineArray {
            consumeInline(value)
        }
    }

    suite.benchmark("string-iterate") {
        var result = 0

        for value in stringArray {
            consumeString(value)
        }
    }
    
    suite.benchmark("inline-string-count") {
        var result = 0
        
        for value in inlineArray {
            result += value.count
        }
        
        consumeInt(result)
    }
    
    suite.benchmark("string-count") {
        var result = 0
        
        for value in stringArray {
            result += value.utf8.count
        }
        
        consumeInt(result)
    }
}
