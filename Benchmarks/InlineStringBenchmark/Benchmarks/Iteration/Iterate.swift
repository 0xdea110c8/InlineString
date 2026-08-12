import Benchmark
import InlineString

let iterate: @Sendable () -> Void = {
    let stringArray: [String] = .init(repeating: "Berlin", count: 1_000_000)
    let inlineArray: [InlineString16] = .init(repeating: "Berlin", count: 1_000_000)

    Benchmark(
        "iterate/string",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for index in 0..<1_000_000 {
                consumeString(stringArray[index])
            }
        }
    }

    Benchmark(
        "iterate/inlinestring16",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for index in 0..<1_000_000 {
                consumeInline(inlineArray[index])
            }
        }
    }
}
