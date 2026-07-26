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
    public enum InlineString16Error: Error {
        /// The UTF-8 representation of a string exceeds the inline capacity.
        case capacityExceeded
    }
    
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
            let lastByte = _storage.15

            if lastByte < Self.capacity {
                return Int(lastByte)
            } else {
                return Self.capacity
            }
        }
        set {
            if newValue < Self.capacity { _storage.15 = UInt8(newValue) }
        }
    }
    
    /// A Boolean value indicating whether the inline string is empty.
    public var isEmpty: Bool {
        count == 0
    }
    
    /// The number of remaining UTF-8 bytes available for writing.
    public var remainingCapacity: Int {
        Self.capacity - count
    }
    
    /// The contents of the inline storage as a `String`.
    public var string: String {
        withUnsafeBytes(of: _storage) { buffer in
            let bytes = buffer.prefix(count)
            return String(decoding: bytes, as: UTF8.self)
        }
    }
    
    // MARK: - Private properties
    
    private var low: UInt64
    private var high: UInt64
    
    // MARK: - Initializers
    
    /// Creates an empty `InlineString16`.
    public init() {
        low = 0
        high = 0
    }
    
    /// Creates an `InlineString16` by copying UTF-8 bytes from `string`,
    /// truncating the input to the fixed `capacity` if necessary.
    /// - Parameter string: The source string to copy into the inline storage.
    /// - Note: Truncation occurs at UTF-8 byte boundaries (not character/scalar boundaries).
    ///         If `string` exceeds `capacity` in UTF-8 bytes, only the first `capacity` bytes are stored.
    public init(truncating string: String) {
        self.init()
        append(truncating: string)
    }
    
    /// Creates an `InlineString16` from a decoded string.
    /// - Parameter value: The decoded string.
    /// - Throws: ``InlineString16Error/capacityExceeded``
    ///           if the UTF-8 representation exceeds ``capacity`` bytes.
    init(decoding value: String) throws {
        self.init()
        guard append(value) else {
            throw InlineString16Error.capacityExceeded
        }
    }
    
    // MARK: - Public methods
    
    /// Appends the UTF-8 contents of a string.
    /// - Parameter string: The string to append.
    /// - Returns: `true` if the string was appended successfully;
    ///            otherwise `false` if there is insufficient remaining capacity.
    @discardableResult
    public mutating func append(_ string: String) -> Bool {
        let offset = self.count
        let remainingCapacity = self.remainingCapacity
        let utf8 = string.utf8
        let count = utf8.count
        
        guard count <= remainingCapacity else {
            return false
        }
        
        withUnsafeMutableBytes(of: &_storage) {
            $0[offset..<offset + count].copyBytes(from: utf8)
        }
        
        self.count += count
        return true
    }
    
    /// Appends the UTF-8 bytes of `string`, truncating to the remaining capacity if needed.
    /// - Parameter string: The source string to append.
    /// - Returns: The number of UTF-8 bytes actually appended.
    /// - Note: Truncation occurs at UTF-8 byte boundaries (not character/scalar boundaries).
    @discardableResult
    public mutating func append(truncating string: String) -> Int {
        let offset = self.count
        let remainingCapacity = self.remainingCapacity
        let utf8 = string.utf8
        let count = utf8.count
        
        guard remainingCapacity > 0 else {
            return 0
        }
        
        let toCopy = min(count, remainingCapacity)
        let stringToCopy = utf8.prefix(toCopy)
        
        withUnsafeMutableBytes(of: &_storage) {
            $0[offset..<offset + toCopy].copyBytes(from: stringToCopy)
        }
        
        self.count += toCopy
        return toCopy
    }
    
    /// Removes all stored bytes.
    /// - Note: The allocated inline storage is preserved.
    public mutating func clear() {
        count = 0
    }
    
    /// Provides temporary access to the stored UTF-8 bytes.
    /// The buffer is valid only for the duration of `body`.
    /// - Parameter body: A closure that receives a buffer containing the stored UTF-8 bytes.
    /// - Returns: The value returned by `body`.
    /// - Throws: Rethrows any error thrown by `body`.
    public func withUTF8<R>(_ body: (UnsafeBufferPointer<UInt8>) throws -> R) rethrows -> R {
        try withUnsafeBytes(of: _storage) { rawBuffer in
            let buffer = rawBuffer.bindMemory(to: UInt8.self)
            return try body(UnsafeBufferPointer(rebasing: buffer[..<count]))
        }
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

// MARK: - Decodable

extension InlineString16: Decodable {
    /// Creates an instance by decoding a string.
    /// - Parameter decoder: The decoder to read from.
    /// - Throws: A decoding error if the decoded string exceeds ``capacity`` bytes.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        try self.init(decoding: value)
    }
}

// MARK: - Encodable

extension InlineString16: Encodable {
    /// Encodes this value as a single string.
    /// - Parameter encoder: The encoder to write to.
    /// - Throws: An error if encoding fails.
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(string)
    }
}

// MARK: - Equatable

extension InlineString16: Equatable {
    /// Returns a Boolean value indicating whether two inline strings contain the same UTF-8 bytes.
    public static func == (lhs: InlineString16, rhs: InlineString16) -> Bool {
        guard lhs.count == rhs.count else {
            return false
        }
        
        if lhs.count == 0 {
            return true
        }
        
        return withUnsafeBytes(of: lhs._storage) { lhsBuffer in
            withUnsafeBytes(of: rhs._storage) { rhsBuffer in
                for index in 0..<lhs.count {
                    if lhsBuffer[index] != rhsBuffer[index] {
                        return false
                    }
                }
                return true
            }
        }
    }
}

// MARK: - ExpressibleByStringLiteral

extension InlineString16: ExpressibleByStringLiteral {
    /// Creates an `InlineString16` from a string literal.
    /// - Parameter value: The string literal.
    /// - Note: Truncation occurs at UTF-8 byte boundaries (not character/scalar boundaries).
    ///         If `string` exceeds `capacity` in UTF-8 bytes, only the first `capacity` bytes are stored.
    public init(stringLiteral value: StringLiteralType) {
        self.init(truncating: value)
    }
}

// MARK: - String + InlineString

extension String {
    /// Creates a `String` from an `InlineString16`.
    /// - Parameter value: The inline string to convert.
    public init(_ value: InlineString16) {
        self = value.string
    }
}
