import Benchmark
import InlineString

print("String size:", MemoryLayout<String>.size)
print("String stride:", MemoryLayout<String>.stride)
print("InlineString16 size:", MemoryLayout<InlineString16>.size)
print("InlineString16 stride:", MemoryLayout<InlineString16>.stride)

let suites = [
    copyBenchmarks,
    countAccessBenchmarks,
    arrayBenchmarks,
    equalityBenchmarks,
    equalityArrayBenchmarks,
    initBenchmarks,
    appendBenchmarks
]

Benchmark.main(suites)
