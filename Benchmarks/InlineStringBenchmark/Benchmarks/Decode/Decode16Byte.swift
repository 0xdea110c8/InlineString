import Benchmark
import Foundation
import InlineString

let decode16Byte: @Sendable () -> Void = {
    let data: Data = try! JSONEncoder().encode("1234567890123456")

    Benchmark(
        "decode/16-byte/string",
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
        "decode/16-byte/inlinestring16",
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
