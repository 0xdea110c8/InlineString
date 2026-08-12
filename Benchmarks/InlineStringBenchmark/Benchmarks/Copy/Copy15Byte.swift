import Benchmark
import Foundation
import InlineString

let copy15Byte: @Sendable () -> Void = {
    let string15: String = "123456789012345"
    let inlineString15: InlineString16 = "123456789012345"

    Benchmark(
        "copy/15-byte/string",
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
        "copy/15-byte/inlinestring16",
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
