/// A 16-byte, fixed-capacity UTF-8 string stored entirely inline.
///
/// `InlineString16` keeps its UTF-8 bytes directly within the value without heap allocation,
/// providing a predictable memory layout and value semantics for performance‑critical code.
///
/// - Important:
///   For values occupying the full 16-byte capacity, the last UTF-8 byte
///   must not be in the range `0x00...0x0F`.
///   These byte values are reserved internally to encode the string length
///   for shorter values. Strings containing one of these bytes as the final
///   byte cannot be represented in the 16-byte inline storage.
public struct InlineString16: BitwiseCopyable, Sendable {
    
    // MARK: - Types
    
    /// Errors thrown by `InlineString16`.
//    public enum InlineString16Error: Error {
//        /// The UTF-8 representation of a string exceeds the inline capacity.
//        case capacityExceeded
//    }
    
    // MARK: - Constants
    
    enum Constant {
        static let capacity = 16
        static let bitsPerByte = 8
        static let wordByteCapacity = 8
        static let highLastByteIndex = wordByteCapacity - 1
        static let lowLastByteIndex = capacity - 1
    }
    
    // MARK: - Public properties
    
    /// The maximum number of UTF-8 bytes that can be stored.
    public var capacity: Int {
        Constant.capacity
    }
    
    /// The number of UTF-8 bytes currently stored.
    public private(set) var count: Int {
        get {
            let lastByte = _rawByte(at: Constant.lowLastByteIndex)

            if lastByte < Constant.capacity {
                return Int(lastByte)
            } else {
                return Constant.capacity
            }
        }
        set {
            if newValue < Constant.capacity {
                _setRawByte(UInt8(newValue), at: Constant.lowLastByteIndex)
            }
        }
    }
    
    /// A Boolean value indicating whether the inline string is empty.
    public var isEmpty: Bool {
        count == 0
    }
    
    /// The contents of the inline storage as a `String`.
//    public var string: String {
//        withUnsafeBytes(of: _storage) { buffer in
//            let bytes = buffer.prefix(count)
//            return String(decoding: bytes, as: UTF8.self)
//        }
//    }
    
    // MARK: - Private properties
    
    var high: UInt64
    var low: UInt64
    
    // MARK: - Initializers
    
    /// Creates an empty `InlineString16`.
    public init() {
        high = 0
        low = 0
    }
    
    // MARK: - Private methods
    
    func _rawByte(at index: Int) -> UInt8 {
        precondition(index >= 0, "Index must be non-negative")
        precondition(index < Constant.capacity, "Index must be in bounds")
        
        if index < Constant.wordByteCapacity {
            let shift = (Constant.highLastByteIndex - index) * Constant.bitsPerByte
            return UInt8(truncatingIfNeeded: high >> shift)
        } else {
            let shift = (Constant.lowLastByteIndex - index) * Constant.bitsPerByte
            return UInt8(truncatingIfNeeded: low >> shift)
        }
    }
    
    mutating func _setRawByte(_ byte: UInt8, at index: Int) {
        precondition(index >= 0, "Index must be non-negative")
        precondition(index < Constant.capacity, "Index must be in bounds")

        if index < Constant.wordByteCapacity {
            let shift = (Constant.highLastByteIndex - index) * Constant.bitsPerByte
            let mask = UInt64(0xFF) << shift
            high = (high & ~mask) | (UInt64(byte) << shift)
        } else {
            let shift = (Constant.lowLastByteIndex - index) * Constant.bitsPerByte
            let mask = UInt64(0xFF) << shift
            low = (low & ~mask) | (UInt64(byte) << shift)
        }
    }
}

//// MARK: - CustomStringConvertible
//
//extension InlineString16: CustomStringConvertible {
//    /// A textual representation of this value.
//    public var description: String {
//        string
//    }
//}
//
//// MARK: - CustomDebugStringConvertible
//
//extension InlineString16: CustomDebugStringConvertible {
//    /// A debug representation of this value.
//    public var debugDescription: String {
//        "InlineString16(\"\(string)\")"
//    }
//}
//
//// MARK: - Decodable
//
//extension InlineString16: Decodable {
//    /// Creates an instance by decoding a string.
//    /// - Parameter decoder: The decoder to read from.
//    /// - Throws: A decoding error if the decoded string exceeds ``capacity`` bytes.
//    public init(from decoder: any Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        let value = try container.decode(String.self)
//        try self.init(decoding: value)
//    }
//}
//
//// MARK: - Encodable
//
//extension InlineString16: Encodable {
//    /// Encodes this value as a single string.
//    /// - Parameter encoder: The encoder to write to.
//    /// - Throws: An error if encoding fails.
//    public func encode(to encoder: any Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encode(string)
//    }
//}
//
//// MARK: - Equatable
//
//extension InlineString16: Equatable {
//    /// Returns a Boolean value indicating whether two inline strings contain the same UTF-8 bytes.
//    public static func == (lhs: InlineString16, rhs: InlineString16) -> Bool {
//        lhs.high == rhs.high && lhs.low == rhs.low
//    }
//}
//
//// MARK: - ExpressibleByStringLiteral
//
//extension InlineString16: ExpressibleByStringLiteral {
//    /// Creates an `InlineString16` from a string literal.
//    /// - Parameter value: The string literal.
//    /// - Note: Truncation occurs at UTF-8 byte boundaries (not character/scalar boundaries).
//    ///         If `string` exceeds `capacity` in UTF-8 bytes, only the first `capacity` bytes are stored.
//    public init(stringLiteral value: StringLiteralType) {
//        self.init(truncating: value)
//    }
//}
//
//// MARK: - String + InlineString
//
//extension String {
//    /// Creates a `String` from an `InlineString16`.
//    /// - Parameter value: The inline string to convert.
//    public init(_ value: InlineString16) {
//        self = value.string
//    }
//}
