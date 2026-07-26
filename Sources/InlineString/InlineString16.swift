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
    
    /// Internal constants
    enum Constant {
        /// Total number of UTF-8 bytes the inline buffer can hold.
        static let capacity = 16
        /// Number of bits in a single byte; used for shift calculations.
        static let bitsPerByte = 8
        /// Number of bytes in a 64-bit word (UInt64).
        static let wordByteCapacity = 8
        /// Index of the last addressable byte within the high 64-bit word.
        static let highLastByteIndex = wordByteCapacity - 1
        /// Index of the last addressable byte within the combined 16-byte storage.
        static let lowLastByteIndex = capacity - 1
    }
    
    // MARK: - Static methods
    
    /// Returns a Boolean value indicating whether a string representation
    /// can be stored in an `InlineString16` value.
    ///
    /// A string can be stored if its UTF-8 representation fits within the
    /// available inline capacity.
    ///
    /// - Parameter string: A string representation to check.
    /// - Returns: `true` if the string fits; otherwise, `false`.
    public static func canStore<StringRepresentation: StringProtocol>(_ string: StringRepresentation) -> Bool {
        return string.utf8.count <= Constant.capacity
    }
    
    // MARK: - Public properties
    
    /// The maximum number of UTF-8 bytes this instance can store.
    public var capacity: Int {
        Constant.capacity
    }
    
    /// The number of UTF-8 bytes currently stored in the buffer.
    public private(set) var count: Int {
        get {
            let lastByte = UInt8(truncatingIfNeeded: low)

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
    
    /// A Boolean value indicating whether the inline string contains zero bytes.
    public var isEmpty: Bool {
        count == 0
    }
    
    /// The contents of the inline storage as a `String` decoded from UTF-8.
    public var string: String {
        var bytes: [UInt8] = []
        bytes.reserveCapacity(count)

        for index in 0..<count {
            bytes.append(_rawByte(at: index))
        }

        return String(decoding: bytes, as: UTF8.self)
    }
    
    // MARK: - Private properties
    
    /// The upper 8 bytes of the 16-byte inline storage.
    var high: UInt64
    /// The lower 8 bytes of the 16-byte inline storage.
    var low: UInt64
    
    // MARK: - Initializers
    
    /// Creates an empty InlineString16 with zeroed storage.
    public init() {
        high = 0
        low = 0
    }
    
    /// Creates an `InlineString16`instance from a string.
    ///
    /// - Parameter string: A string to store.
    ///
    /// - Important: The UTF-8 representation of `string` must fit within the
    ///   capacity of `InlineString16`. If it does not, initialization terminates
    ///   with a fatal error. Use `canStore(_:)` to check whether initialization
    ///   can succeed before creating a value.
    public init(_ string: String) {
        self.init()
        
        var index = 0
        
        for byte in string.utf8 {
            if index < Constant.capacity {
                _setZeroRawByte(byte, at: index)
            } else {
                fatalError("InlineString16 capacity exceeded")
            }
            index += 1
        }
        
        count = index
    }
    
    /// Creates an `InlineString16` instance from a string if it fits within the available inline storage.
    ///
    /// - Parameter string: A string to store.
    /// - Returns: An initialized `InlineString16` value, or `nil` if the
    ///   string does not fit within the capacity of `InlineString16`.
    public init?(validating string: String) {
        guard Self.canStore(string) else {
            return nil
        }
        
        self.init(string)
    }
    
    // MARK: - Private methods
    
    /// Reads a raw byte from the inline storage without interpreting string semantics.
    /// - Parameter index: A zero-based index into the 16-byte buffer.
    /// - Returns: The byte value at the specified index.
    /// - Precondition: `index` must be within 0..<16.
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
    
    /// Writes a raw byte into the inline storage without interpreting string semantics.
    /// - Parameters:
    ///   - byte: The byte value to write.
    ///   - index: A zero-based index into the 16-byte buffer.
    /// - Precondition: `index` must be within 0..<16.
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
    
    mutating func _setZeroRawByte(_ byte: UInt8, at index: Int) {
        precondition(index >= 0, "Index must be non-negative")
        precondition(index < Constant.capacity, "Index must be in bounds")

        if index < Constant.wordByteCapacity {
            let shift = (Constant.highLastByteIndex - index) * Constant.bitsPerByte
            high |= UInt64(byte) << shift
        } else {
            let shift = (Constant.lowLastByteIndex - index) * Constant.bitsPerByte
            low |= UInt64(byte) << shift
        }
    }
}

// MARK: - ExpressibleByStringLiteral

extension InlineString16: ExpressibleByStringLiteral {
    /// Creates an `InlineString16` instance from a string literal.
    ///
    /// - Important: The UTF-8 representation of `string` must fit within the
    ///   capacity of `InlineString16`. If it does not, initialization terminates
    ///   with a fatal error. Use `canStore(_:)` to check whether initialization
    ///   can succeed before creating a value.
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}

// MARK: - Equatable

extension InlineString16: Equatable {
    /// Returns a Boolean value indicating whether two inline strings contain the same UTF-8 bytes.
    public static func == (lhs: InlineString16, rhs: InlineString16) -> Bool {
        lhs.high == rhs.high && lhs.low == rhs.low
    }
}

// MARK: - CustomStringConvertible

extension InlineString16: CustomStringConvertible {
    /// A textual representation of this value.
    public var description: String {
        string
    }
}

// MARK: - CustomDebugStringConvertible

extension InlineString16: CustomDebugStringConvertible {
    /// A debug representation of this value.
    public var debugDescription: String {
        "InlineString16(\"\(string)\")"
    }
}

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
//// MARK: - String + InlineString
//
//extension String {
//    /// Creates a `String` from an `InlineString16`.
//    /// - Parameter value: The inline string to convert.
//    public init(_ value: InlineString16) {
//        self = value.string
//    }
//}
