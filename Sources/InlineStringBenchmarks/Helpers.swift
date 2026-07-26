@preconcurrency import Benchmark
import InlineString

nonisolated(unsafe) var inlineSink: InlineString16 = ""

@inline(never)
func consumeInline(_ value: InlineString16) {
    inlineSink = value
}

nonisolated(unsafe) var stringSink = ""

@inline(never)
func consumeString(_ value: String) {
    stringSink = value
}

nonisolated(unsafe) var intSink = 0

@inline(never)
func consumeInt(_ value: Int) {
    intSink = value
}

nonisolated(unsafe) var boolSink = false

@inline(never)
func consumeBool(_ value: Bool) {
    boolSink = value
}
