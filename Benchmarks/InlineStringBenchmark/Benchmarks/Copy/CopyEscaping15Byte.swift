import Benchmark
import Foundation
import InlineString

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
