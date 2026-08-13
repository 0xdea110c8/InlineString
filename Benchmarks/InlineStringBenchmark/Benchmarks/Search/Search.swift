import Benchmark
import InlineString

let search: @Sendable () -> Void = {
    let stringArray: [String] = [
        "Berlin",
        "London",
        "Tokyo",
        "Paris",
        "Moscow",
    ]

    let inlineArray: [InlineString16] = [
        "Berlin",
        "London",
        "Tokyo",
        "Paris",
        "Moscow",
    ]

    let stringTarget: String = "Tokyo"
    let inlineTarget: InlineString16 = "Tokyo"

    Benchmark(
        "search/string",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                for value in stringArray {
                    if value == stringTarget {
                        consumeBool(true)
                        break
                    }
                }
            }
        }
    }

    Benchmark(
        "search/inlinestring16",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                for value in inlineArray {
                    if value == inlineTarget {
                        consumeBool(true)
                        break
                    }
                }
            }
        }
    }
}
