# Benchmark results

Results are based on p50 wall-clock time and normalized to nanoseconds per operation over 1,000,000 iterations.  
Differences within 1.00×–1.10× are treated as comparable performance.

| Method | String (ns/op) | InlineString16 (ns/op) | Result |
|---|---|---|---|
| `copy/escaping/empty` | 1.778 | 0.666 | **2.67× faster** |
| `copy/escaping/15-byte` | 1.778 | 0.669 | **2.66× faster** |
| `copy/escaping/16-byte` | 1.778 | 0.669 | **2.66× faster** |
| `search` | 3.865 | 1.601 | **2.41× faster** |
| `iterate` | 2.445 | 1.113 | **2.20× faster** |
| `init/15-byte/string-literal` | 4.366 | 2.916 | **1.49× faster** |
| `init/15-byte` | 4.366 | 3.569 | **1.22× faster** |
| `access/count(utf8)` | 1.334 | 1.112 | **1.20× faster** |
| `decode/escaping/16-byte` | 403 | 398 | **comparable performance** |
| `copy/empty` | 1.112 | 1.112 | **comparable performance** |
| `copy/15-byte` | 1.112 | 1.112 | **comparable performance** |
| `copy/16-byte` | 1.112 | 1.112 | **comparable performance** |
| `equality/equal` | 1.112 | 1.112 | **comparable performance** |
| `equality/different` | 1.112 | 1.112 | **comparable performance** |
| `hash` | 7.545 | 7.557 | **comparable performance** |
| `init/empty` | 1.112 | 1.112 | **comparable performance** |
| `iterate/count` | 1.136 | 1.134 | **comparable performance** |
| `decode/15-byte` | 374 | 376 | **comparable performance** |
| `decode/16-byte` | 406 | 412 | **comparable performance** |
| `encode/15-byte` | 370 | 374 | **comparable performance** |
| `encode/escaping/15-byte` | 370 | 375 | **comparable performance** |
| `encode/escaping/16-byte` | 393 | 399 | **comparable performance** |
| `decode/escaping/15-byte` | 378 | 403 | **comparable performance** |
| `encode/16-byte` | 367 | 394 | **comparable performance** |
| `init/16-byte` | 4.444 | 4.734 | **comparable performance** |
| `init/16-byte/string-literal` | 4.444 | 4.268 | **comparable performance** |
| `init/empty/string-literal` | 1.112 | 2.902| **2.60× slower** |
| `access/escaping/string` | 1.778 | 7.823 | **4.40× slower** |
| `access/string` | 1.112 | 7.172 | **6.45× slower** |
