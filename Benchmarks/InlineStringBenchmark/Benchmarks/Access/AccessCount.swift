import Benchmark
import InlineString

let accessCount: @Sendable () -> Void = {
    let string: String = "1234567890"
    let inlineString: InlineString16 = "1234567890"
    var count = 0

    Benchmark(
        "access/count(utf8)/string",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                count += string.utf8.count
                consumeInt(count)
            }
        }
    }

    Benchmark(
        "access/count/inlinestring16",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                count += inlineString.count
                consumeInt(count)
            }
        }
    }
}
