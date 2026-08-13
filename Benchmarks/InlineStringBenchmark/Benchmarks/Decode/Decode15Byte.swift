import Benchmark
import Foundation
import InlineString

let decode15Byte: @Sendable () -> Void = {
    let data: Data = try! JSONEncoder().encode("123456789012345")

    Benchmark(
        "decode/15-byte/string",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let string = try JSONDecoder().decode(String.self, from: data)
                consumeString(string)
            }
        }
    }

    Benchmark(
        "decode/15-byte/inlinestring16",
        configuration: .init(
            metrics: [.wallClock, .instructions],
            timeUnits: .nanoseconds
        )
    ) { benchmark in
        for _ in benchmark.scaledIterations {
            for _ in 0..<1_000_000 {
                let inlineString = try JSONDecoder().decode(InlineString16.self, from: data)
                consumeInline(inlineString)
            }
        }
    }
}
