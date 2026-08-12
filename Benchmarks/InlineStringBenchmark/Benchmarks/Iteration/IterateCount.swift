import Benchmark
import InlineString

let iterateCount: @Sendable () -> Void = {
    let stringArray: [String] = .init(repeating: "Berlin", count: 1_000_000)
    let inlineArray: [InlineString16] = .init(repeating: "Berlin", count: 1_000_000)

    Benchmark(
        "iterate/count(utf8)/string",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for index in 0..<1_000_000 {
                consumeInt(stringArray[index].utf8.count)
            }
        }
    }

    Benchmark(
        "iterate/count/inlinestring16",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for index in 0..<1_000_000 {
                consumeInt(inlineArray[index].count)
            }
        }
    }
}
