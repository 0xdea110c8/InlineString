import Benchmark
import Foundation
import InlineString

let copy16Byte: @Sendable () -> Void = {
    let string16: String = "1234567890123456"
    let inlinestring16: InlineString16 = "1234567890123456"

    Benchmark(
        "copy/16-byte/string",
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
        "copy/16-byte/inlinestring16",
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
