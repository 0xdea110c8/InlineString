import Benchmark
import Foundation
import InlineString

let copyEmpty: @Sendable () -> Void = {
    let emptyString: String = ""
    let emptyInlineString: InlineString16 = ""

    Benchmark(
        "copy/empty/string",
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
        "copy/empty/inlinestring16",
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
