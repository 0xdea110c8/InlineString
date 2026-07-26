import Benchmark
import InlineString

print("InlineString16 size:", MemoryLayout<InlineString16>.size)
print("InlineString16 stride:", MemoryLayout<InlineString16>.stride)

Benchmark.main()
