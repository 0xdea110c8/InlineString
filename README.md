[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0xdea110c8%2FInlineString%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/0xdea110c8/InlineString) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2F0xdea110c8%2FInlineString%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/0xdea110c8/InlineString)

# InlineString

`InlineString' is a proof of concept exploring a fixed-capacity UTF-8 string representation optimized for small strings.

The goal of this project is to investigate whether storing short strings directly inside a value type can provide performance and memory-layout benefits compared to Swift's general-purpose `String`.

## InlineString16
Stores up to 16 UTF-8 bytes directly inside the value.

### Usage

Creating from string literal:

```swift
let city: InlineString16 = "Berlin"
```

Creating from `String`:

```swift
let string: String = "Tokyo"
let location = InlineString16(string)
```

Creating from `String` with capacity validation:

```swift
let string: String = "Hanoi"
guard let place = InlineString16(validating: string) else {
    // String exceeds capacity
}
```

### Features

- Bitwise-copyable value type
- No heap allocation for stored content
- Fixed capacity: 16 UTF-8 bytes
- Inline UTF-8 byte storage using two `UInt64` values
- Fast copying and equality checks
- Protocol conformances:
  - `BitwiseCopyable`
  - `Sendable`
  - `Equatable`
  - `Hashable`
  - `Codable`
  - `ExpressibleByStringLiteral`
  - `CustomStringConvertible`
  - `CustomDebugStringConvertible`

### Storage

`InlineString16` stores up to 16 UTF-8 bytes:

```
┌───────────────┬───────────────┐
│    UInt64     │    UInt64     │
│  bytes 0...7  │ bytes 8...15  │
└───────────────┴───────────────┘
```

The string length is stored as metadata inside the representation.
> [!IMPORTANT]
> When the storage is not fully utilized, the last byte is reserved for storing the string length. As a result, the final UTF-8 byte of the string cannot be in the range `0x00...0x0F`, since those values are reserved for the length encoding.

### Performance

Benchmarks were performed against Swift `String`. Each benchmark was executed repeatedly to obtain stable measurements.

| Benchmark | `String` | `InlineString16` | Result |
| --- | ---: | ---: | --- |
| Copy | 3.12 ms | 0.67 ms | ~4.7x faster |
| Array iteration | 3.11 ms | 0.69 ms | ~4.5x faster |
| Equality (different values) | 1.80 ms | 0.70 ms | ~2.6x faster |
| Array search | 6.36 ms | 4.03 ms | ~1.6x faster |
| Accessing count | 0.68 ms | 0.67 ms | Comparable performance |
| Hashing | 15.16 ms | 15.23 ms | Comparable performance |
| Decoding | 379 ms | 373 ms | Comparable performance |
| Encoding | 350 ms | 363 ms | Comparable performance |
| Initialization | 3.10 ms | 4.72 ms | ~1.5x slower |
| Initialization (16-byte strings) | 3.12 ms | 7.12 ms | ~2.3x slower |
| Conversion to `String` | 3.11 ms | 9.02 ms | ~2.9x slower |

### Trade-offs

`InlineString16` is optimized for small fixed-size strings.

- Advantages:
  - Compact storage
  - Predictable memory layout
  - Fast copying
  - Fast comparison
  - Fast iteration
- Limitations:
  - Maximum size is 16 UTF-8 bytes
  - Converting back to `String` requires creating a `String` value
  - Not intended as a replacement for general-purpose `String`
  - Last UTF-8 byte cannot be in the range `0x00...0x0F`, as these values are reserved for encoding the string length

### Intended use cases

Good use cases for `InlineString16`:
- Identifiers
- Keys
- Tags
- Event names
- Small fixed-size values

### Non-goals

`InlineString16` is not intended to:
- replace Swift `String`;
- support arbitrary-length strings;
- provide the full `String` API;
- optimize Unicode processing.

## Installation

Add the following dependency to your `Package.swift`:

```swift
.package(url: "https://github.com/0xdea110c8/InlineString.git", from: "0.1.0")
```

Then add `InlineString` to your target dependencies.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
