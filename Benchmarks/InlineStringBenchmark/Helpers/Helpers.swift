import Benchmark
import Foundation
import InlineString

nonisolated(unsafe) private var inlineSink: InlineString16 = ""
nonisolated(unsafe) private var stringSink: String = ""
nonisolated(unsafe) private var dataSink = Data()

@inline(never)
func consumeEscapingInline(_ value: InlineString16) {
    inlineSink = value
}

@inline(never)
func consumeInline(_ value: InlineString16) {
    blackHole(value)
}

@inline(never)
func consumeEscapingString(_ value: String) {
    stringSink = value
}

@inline(never)
func consumeString(_ value: String) {
    blackHole(value)
}

@inline(never)
func consumeEscapingData(_ value: Data) {
    dataSink = value
}

@inline(never)
func consumeData(_ value: Data) {
    blackHole(value)
}

@inline(never)
func consumeInt(_ value: Int) {
    blackHole(value)
}

@inline(never)
func consumeBool(_ value: Bool) {
    blackHole(value)
}
