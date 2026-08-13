import Benchmark
import InlineString

let init15Byte: @Sendable () -> Void = {

    let input = "123456789012345"

    Benchmark(
        "init/15byte/string",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                consumeString(String(input))
            }
        }
    }

    Benchmark(
        "init/15byte/inlinestring16",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                consumeInline(InlineString16(input))
            }
        }
    }

    Benchmark(
        "init/15byte/inlinestring16-string-literal",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let result: InlineString16 = "123456789012345"
                consumeInline(result)
            }
        }
    }
}
