import Benchmark
import InlineString

print("String size:", MemoryLayout<String>.size)
print("String stride:", MemoryLayout<String>.stride)
print("InlineString16 size:", MemoryLayout<InlineString16>.size)
print("InlineString16 stride:", MemoryLayout<InlineString16>.stride)

let initEmptySuite = [initEmptyComparison]
let initSuite = [initComparison]
let init15Suite = [init15Comparison]
let init16Suite = [init16Comparison]

let copyEmptySuite = [copyEmptyComparison]
let copySuite = [copyComparison]
let copy15ByteSuite = [copy15ByteComparison]

let accessCountSuite = [accessCountComparison]
let accessStringSuite = [accessStringComparison]

let equalitySuite = [equalityComparison]

let arrayIterationSuite = [arrayIterationComparison]

let arraySearchSuite = [arraySearchComparison]


Benchmark.main(initEmptySuite)
Benchmark.main(initSuite)
Benchmark.main(init15Suite)
Benchmark.main(init16Suite)

Benchmark.main(copyEmptySuite)
Benchmark.main(copySuite)
Benchmark.main(copy15ByteSuite)

Benchmark.main(accessCountSuite)
Benchmark.main(accessStringSuite)

Benchmark.main(equalitySuite)

Benchmark.main(arrayIterationSuite)

Benchmark.main(arraySearchSuite)
