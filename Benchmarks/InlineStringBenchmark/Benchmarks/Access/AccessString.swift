import Benchmark
import InlineString

let accessString: @Sendable () -> Void = {
    let string: String = "1234567890"
    let inlineString: InlineString16 = "1234567890"

    Benchmark(
        "access/string/string",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let value = string
                consumeString(value)
            }
        }
    }

    Benchmark(
        "access/string/inlinestring16",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let value = inlineString.string
                consumeString(value)
            }
        }
    }
}
