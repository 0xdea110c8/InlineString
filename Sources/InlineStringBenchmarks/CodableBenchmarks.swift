@preconcurrency import Benchmark
import InlineString
import Foundation

fileprivate nonisolated(unsafe) var data15Bytes = try! JSONEncoder().encode("123456789012345")
fileprivate nonisolated(unsafe) var data16Bytes = try! JSONEncoder().encode("1234567890123456")
fileprivate let inlineString15Bytes = InlineString16("123456789012345")
fileprivate let inlineString16Bytes = InlineString16("1234567890123456")
fileprivate let string15Bytes = String("123456789012345")
fileprivate let string16Bytes = String("1234567890123456")


let decode15Comparison = BenchmarkSuite(name: "decode-15-bytes") { suite in
    suite.benchmark("string") {
        for _ in 0..<1_000_000 {
            let string = try JSONDecoder().decode(String.self, from: data15Bytes)
            consumeString(string)
        }
    }
    
    suite.benchmark("inline-string") {
        for _ in 0..<1_000_000 {
            let inlineString = try JSONDecoder().decode(InlineString16.self, from: data15Bytes)
            consumeInline(inlineString)
        }
    }
}

let decode16Comparison = BenchmarkSuite(name: "decode-16-bytes") { suite in
    suite.benchmark("string") {
        for _ in 0..<1_000_000 {
            let string = try JSONDecoder().decode(String.self, from: data16Bytes)
            consumeString(string)
        }
    }
    
    suite.benchmark("inline-string") {
        for _ in 0..<1_000_000 {
            let inlineString = try JSONDecoder().decode(InlineString16.self, from: data16Bytes)
            consumeInline(inlineString)
        }
    }
}

let encode15Comparison = BenchmarkSuite(name: "encode-15-bytes") { suite in
    suite.benchmark("string") {
        for _ in 0..<1_000_000 {
            let data = try JSONEncoder().encode(string15Bytes)
            consumeData(data)
        }
    }
    
    suite.benchmark("inline-string") {
        for _ in 0..<1_000_000 {
            let data = try JSONEncoder().encode(inlineString15Bytes)
            consumeData(data)
        }
    }
}

let encode16Comparison = BenchmarkSuite(name: "encode-16-bytes") { suite in
    suite.benchmark("string") {
        for _ in 0..<1_000_000 {
            let data = try JSONEncoder().encode(string16Bytes)
            consumeData(data)
        }
    }
    
    suite.benchmark("inline-string") {
        for _ in 0..<1_000_000 {
            let data = try JSONEncoder().encode(inlineString16Bytes)
            consumeData(data)
        }
    }
}
