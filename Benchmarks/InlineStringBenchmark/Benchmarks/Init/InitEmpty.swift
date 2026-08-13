import Benchmark
import InlineString

let initEmpty: @Sendable () -> Void = {
    Benchmark(
        "init/empty/string",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                consumeString(String())
            }
        }
    }

    Benchmark(
        "init/empty/inlinestring16",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                consumeInline(InlineString16())
            }
        }
    }

    Benchmark(
        "init/empty/inlinestring16-string-literal",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let result: InlineString16 = ""
                consumeInline(result)
            }
        }
    }
}
