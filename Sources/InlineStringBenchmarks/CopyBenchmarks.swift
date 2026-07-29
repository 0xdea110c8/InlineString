@preconcurrency import Benchmark
import InlineString

private nonisolated(unsafe) var emptyInlineString: InlineString16 = ""
private nonisolated(unsafe) var emptyString: String = ""
private nonisolated(unsafe) var inlineString: InlineString16 = "London"
private nonisolated(unsafe) var string: String = "London"
private nonisolated(unsafe) var inlineString15: InlineString16 = "ABCDEFGHIJKLMNO"
private nonisolated(unsafe) var string15: String = "ABCDEFGHIJKLMNO"

let copyEmptyComparison = BenchmarkSuite(name: "copy-empty") { suite in
    suite.benchmark("string") {
        for _ in 0..<1_000_000 {
            let value: String = emptyString
            let copy = value
            consumeString(copy)
        }
    }

    suite.benchmark("inline-string") {
        for _ in 0..<1_000_000 {
            let value: InlineString16 = emptyInlineString
            let copy = value
            consumeInline(copy)
        }
    }
}

let copyComparison = BenchmarkSuite(name: "copy") { suite in
    suite.benchmark("string") {
        for _ in 0..<1_000_000 {
            let value: String = string
            let copy = value
            consumeString(copy)
        }
    }

    suite.benchmark("inline-string") {
        for _ in 0..<1_000_000 {
            let value: InlineString16 = inlineString
            let copy = value
            consumeInline(copy)
        }
    }
}

let copy15ByteComparison = BenchmarkSuite(name: "copy-15-bytes") { suite in
    suite.benchmark("string") {
        for _ in 0..<1_000_000 {
            let value: String = string15
            let copy = value
            consumeString(copy)
        }
    }

    suite.benchmark("inline-string") {
        for _ in 0..<1_000_000 {
            let value: InlineString16 = inlineString15
            let copy = value
            consumeInline(copy)
        }
    }
}
