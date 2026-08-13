import Benchmark
import Foundation
import InlineString

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
