import Benchmark
import Foundation
import InlineString

let encode16Byte: @Sendable () -> Void = {
    let string: String = "1234567890123456"
    let inlineString: InlineString16 = "1234567890123456"

    Benchmark(
        "encode/16-byte/string",
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
        "encode/16-byte/inlinestring16",
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
