import Benchmark
import Foundation
import InlineString

let encode15Byte: @Sendable () -> Void = {
    let string: String = "123456789012345"
    let inlineString: InlineString16 = "123456789012345"

    Benchmark(
        "encode/15-byte/string",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let data = try JSONEncoder().encode(string)
                consumeData(data)
            }
        }
    }

    Benchmark(
        "encode/15-byte/inlinestring16",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let data = try JSONEncoder().encode(inlineString)
                consumeData(data)
            }
        }
    }
}
