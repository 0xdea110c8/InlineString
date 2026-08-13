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
