@preconcurrency import Benchmark
import InlineString

fileprivate nonisolated(unsafe) var inlineSink: InlineString16 = ""
fileprivate nonisolated(unsafe) var stringSink = ""
fileprivate nonisolated(unsafe) var intSink = 0
fileprivate nonisolated(unsafe) var boolSink = false

@inline(never)
func consumeInline(_ value: InlineString16) {
    inlineSink = value
}

@inline(never)
func consumeString(_ value: String) {
    stringSink = value
}

@inline(never)
func consumeInt(_ value: Int) {
    intSink = value
}

@inline(never)
func consumeBool(_ value: Bool) {
    boolSink = value
}
