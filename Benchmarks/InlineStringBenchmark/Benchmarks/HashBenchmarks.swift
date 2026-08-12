import Benchmark
import InlineString

let hash: @Sendable () -> Void = {
    let string: String = "Berlin"
    let inlineString: String = "Berlin"

    Benchmark(
        "hash/string",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let result = string.hashValue
                consumeInt(result)
            }
        }
    }

    Benchmark(
        "hash/inlineString16",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let result = inlineString.hashValue
                consumeInt(result)
            }
        }
    }
}
