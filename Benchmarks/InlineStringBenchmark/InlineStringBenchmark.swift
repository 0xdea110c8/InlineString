import Benchmark
import InlineString

let benchmarks: @Sendable () -> Void = {
    accessBenchmarks()
    copyBenchmarks()
    decodingBenchmarks()
    encodingBenchmarks()
    equalityBenchmarks()
    hashBenchmarks()
    initBenchmarks()
    iterationBenchmarks()
    searchBenchmarks()
}

let accessBenchmarks: @Sendable () -> Void = {
    accessCount()
    accessString()
    accessEscapingString()
}

let copyBenchmarks: @Sendable () -> Void = {
    copyEmpty()
    copy15Byte()
    copy16Byte()
    copyEscapingEmpty()
    copyEscaping15Byte()
    copyEscaping16Byte()
}

let decodingBenchmarks: @Sendable () -> Void = {
    decode15Byte()
    decode16Byte()
    decodeEscaping15Byte()
    decodeEscaping16Byte()
}

let encodingBenchmarks: @Sendable () -> Void = {
    encode15Byte()
    encode16Byte()
    encodeEscaping15Byte()
    encodeEscaping16Byte()
}

let equalityBenchmarks: @Sendable () -> Void = {
    equality()
}

let hashBenchmarks: @Sendable () -> Void = {
    hash()
}

let initBenchmarks: @Sendable () -> Void = {
    initEmpty()
    init15Byte()
    init16Byte()
}

let iterationBenchmarks: @Sendable () -> Void = {
    iterate()
    iterateCount()
}

let searchBenchmarks: @Sendable () -> Void = {
    search()
}
