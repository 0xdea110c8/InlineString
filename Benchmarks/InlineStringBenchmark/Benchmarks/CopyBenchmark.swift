import Benchmark
import Foundation
import InlineString

let copyEscapingEmpty: @Sendable () -> Void = {
    let emptyString: String = ""
    let emptyInlineString: InlineString16 = ""

    Benchmark(
        "copy/escaping/empty/string",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let copy = emptyString
                consumeEscapingString(copy)
            }
        }
    }

    Benchmark(
        "copy/escaping/empty/inlinestring16",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let copy = emptyInlineString
                consumeEscapingInline(copy)
            }
        }
    }
}

let copyEmpty: @Sendable () -> Void = {
    let emptyString: String = ""
    let emptyInlineString: InlineString16 = ""

    Benchmark(
        "copy/non-escaping/empty/string",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let copy = emptyString
                consumeString(copy)
            }
        }
    }

    Benchmark(
        "copy/non-escaping/empty/inlinestring16",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let copy = emptyInlineString
                consumeInline(copy)
            }
        }
    }
}

let copyEscaping15Byte: @Sendable () -> Void = {
    let string15: String = "123456789012345"
    let inlineString15: InlineString16 = "123456789012345"

    Benchmark(
        "copy/escaping/15-byte/string",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let copy = string15
                consumeEscapingString(copy)
            }
        }
    }

    Benchmark(
        "copy/escaping/15-byte/inlinestring16",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let copy = inlineString15
                consumeEscapingInline(copy)
            }
        }
    }
}

let copy15Byte: @Sendable () -> Void = {
    let string15: String = "123456789012345"
    let inlineString15: InlineString16 = "123456789012345"

    Benchmark(
        "copy/non-escaping/15-byte/string",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let copy = string15
                consumeString(copy)
            }
        }
    }

    Benchmark(
        "copy/non-escaping/15-byte/inlinestring16",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let copy = inlineString15
                consumeInline(copy)
            }
        }
    }
}

let copyEscaping16Byte: @Sendable () -> Void = {
    let string16: String = "1234567890123456"
    let inlinestring16: InlineString16 = "1234567890123456"

    Benchmark(
        "copy/escaping/16-byte/string",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let copy = string16
                consumeEscapingString(copy)
            }
        }
    }

    Benchmark(
        "copy/escaping/16-byte/inlinestring16",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let copy = inlinestring16
                consumeEscapingInline(copy)
            }
        }
    }
}

let copy16Byte: @Sendable () -> Void = {

    let string16: String = "1234567890123456"
    let inlinestring16: InlineString16 = "1234567890123456"

    Benchmark(
        "copy/non-escaping/16-byte/string",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let copy = string16
                consumeString(copy)
            }
        }
    }

    Benchmark(
        "copy/non-escaping/16-byte/inlinestring16",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let copy = inlinestring16
                consumeInline(copy)
            }
        }
    }
}
