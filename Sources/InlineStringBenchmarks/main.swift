import Benchmark
import InlineString

print("String size:", MemoryLayout<String>.size)
print("String stride:", MemoryLayout<String>.stride)
print("InlineString16 size:", MemoryLayout<InlineString16>.size)
print("InlineString16 stride:", MemoryLayout<InlineString16>.stride)

let initSuite = [
    initEmptyComparison,
    initComparison,
    init15Comparison,
    init16Comparison
]

let copySuite = [
    copyEmptyComparison,
    copyComparison,
    copy15ByteComparison
]

let accessSuite = [
    accessCountComparison,
    accessStringComparison
]

let equalitySuite = [
    equalityComparison
]

let hashSuite = [
    hashComparison
]

let decodeSuite = [
    decode15Comparison,
    decode16Comparison
]

let encodeSuite = [
    encode15Comparison,
    encode16Comparison
]

let arrayIterationSuite = [
    arrayIterationComparison
]

let arraySearchSuite = [
    arraySearchComparison
]

Benchmark.main(initSuite)
Benchmark.main(copySuite)
Benchmark.main(accessSuite)
Benchmark.main(equalitySuite)
Benchmark.main(hashSuite)
Benchmark.main(decodeSuite)
Benchmark.main(encodeSuite)
Benchmark.main(arrayIterationSuite)
Benchmark.main(arraySearchSuite)
