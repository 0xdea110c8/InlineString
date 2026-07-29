@preconcurrency import Benchmark
import InlineString
import Foundation

private nonisolated(unsafe) var inlineSink: InlineString16 = ""
private nonisolated(unsafe) var stringSink = ""
private nonisolated(unsafe) var intSink = 0
private nonisolated(unsafe) var boolSink = false
private nonisolated(unsafe) var dataSink = Data()

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

@inline(never)
func consumeData(_ value: Data) {
    dataSink = value
}
