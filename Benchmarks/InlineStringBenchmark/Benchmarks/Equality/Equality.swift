import Benchmark
import InlineString

let equality: @Sendable () -> Void = {
    let lhsInline: InlineString16 = "Berlin"
    let rhsEqualInline: InlineString16 = "Berlin"
    let rhsDifferentInline: InlineString16 = "London"
    let lhsString: InlineString16 = "Berlin"
    let rhsEqualString: InlineString16 = "Berlin"
    let rhsDifferentString: InlineString16 = "London"

    Benchmark(
        "equality/equal/string",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let result = lhsString == rhsEqualString
                consumeBool(result)
            }
        }
    }

    Benchmark(
        "equality/different/string",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let result = lhsString == rhsDifferentString
                consumeBool(result)
            }
        }
    }

    Benchmark(
        "equality/equal/inlinestring16",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let result = lhsInline == rhsEqualInline
                consumeBool(result)
            }
        }
    }

    Benchmark(
        "equality/different/inlinestring16",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let result = lhsInline == rhsDifferentInline
                consumeBool(result)
            }
        }
    }
}
