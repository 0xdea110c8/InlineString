@preconcurrency import Benchmark
import InlineString

private nonisolated(unsafe) var emptyString = ""
private nonisolated(unsafe) var sourceString = "Berlin"
private nonisolated(unsafe) var sourceString15 = "123456789012345"
private nonisolated(unsafe) var sourceString16 = "1234567890123456"

let initEmptyComparison = BenchmarkSuite(name: "init-empty") { suite in
    suite.benchmark("string") {
        for _ in 0..<1_000_000 {
            let value = String()
            consumeString(value)
        }
    }

    suite.benchmark("string-string-literal") {
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
    suite.benchmark("string") {
        for _ in 0..<1_000_000 {
            let value = sourceString
            consumeString(value)
        }
    }

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

let init15Comparison = BenchmarkSuite(name: "init-15-bytes") { suite in
    suite.benchmark("string") {
        for _ in 0..<1_000_000 {
            let value = sourceString15
            consumeString(value)
        }
    }

    suite.benchmark("string-copy") {
        for _ in 0..<1_000_000 {
            let value = String(sourceString15)
            consumeString(value)
        }
    }

    suite.benchmark("inline-string") {
        for _ in 0..<1_000_000 {
            let value = InlineString16(sourceString15)
            consumeInline(value)
        }
    }

    suite.benchmark("inline-string-validating") {
        for _ in 0..<1_000_000 {
            let value = InlineString16(validating: sourceString15)!
            consumeInline(value)
        }
    }

    suite.benchmark("inline-string-string-literal") {
        for _ in 0..<1_000_000 {
            let value: InlineString16 = "123456789012345"
            consumeInline(value)
        }
    }
}

let init16Comparison = BenchmarkSuite(name: "init-16-bytes") { suite in
    suite.benchmark("string") {
        for _ in 0..<1_000_000 {
            let value = sourceString16
            consumeString(value)
        }
    }

    suite.benchmark("string-copy") {
        for _ in 0..<1_000_000 {
            let value = String(sourceString16)
            consumeString(value)
        }
    }

    suite.benchmark("inline-string") {
        for _ in 0..<1_000_000 {
            let value = InlineString16(sourceString16)
            consumeInline(value)
        }
    }

    suite.benchmark("inline-string-validating") {
        for _ in 0..<1_000_000 {
            let value = InlineString16(validating: sourceString16)!
            consumeInline(value)
        }
    }

    suite.benchmark("inline-string-string-literal") {
        for _ in 0..<1_000_000 {
            let value: InlineString16 = "1234567890123456"
            consumeInline(value)
        }
    }
}
