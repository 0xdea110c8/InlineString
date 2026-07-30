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
        return string.utf8.count <= 16
    }

    // MARK: - Public properties

    /// The maximum number of UTF-8 bytes this instance can store.
    public var capacity: Int {
        16
    }

    /// The number of UTF-8 bytes currently stored in the buffer.
    public private(set) var count: Int {
        get {
            let countByte = UInt8(truncatingIfNeeded: high >> 56)

            if countByte < 16 {
                return Int(countByte)
            } else {
                return 16
            }
        }
        set {
            if newValue < 16 {
                high = (high & 0x00FF_FFFF_FFFF_FFFF) | (UInt64(newValue) << 56)
            }
        }
    }

    /// A Boolean value indicating whether the inline string contains zero bytes.
    public var isEmpty: Bool {
        count == 0
    }

    /// The contents of the inline storage as a `String` decoded from UTF-8.
    public var string: String {
        withUnsafeUTF8Bytes {
            String(decoding: $0, as: UTF8.self)
        }
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
    /// - Important: The UTF-8 representation of `string` must fit within the
    ///   capacity of `InlineString16`. If it does not, initialization terminates
    ///   with a fatal error. Use `canStore(_:)` to check whether initialization
    ///   can succeed before creating a value.
    /// - Important: When the storage is not fully utilized, the last byte is reserved for storing the string length.
    ///   As a result, the final UTF-8 byte of the string cannot be in the range `0x00...0x0F`,
    ///   since those values are reserved for the length encoding.
    /// - Parameter string: A string to store.
    public init(_ string: String) {
        self.init()

        _initialize(from: string, validating: false)
    }

    /// Creates an `InlineString16` instance from a string if it fits within the available inline storage.
    ///
    /// - Important: When the storage is not fully utilized, the last byte is reserved for storing the string length.
    ///   As a result, the final UTF-8 byte of the string cannot be in the range `0x00...0x0F`,
    ///   since those values are reserved for the length encoding.
    /// - Parameter string: A string to store.
    /// - Returns: An initialized `InlineString16` value, or `nil` if the
    ///   string does not fit within the capacity of `InlineString16`.
    public init?(validating string: String) {
        self.init()

        guard _initialize(from: string, validating: true) else {
            return nil
        }
    }

    /// Provides temporary access to the stored UTF-8 bytes.
    ///
    /// The buffer is valid only for the duration of `body`.
    ///
    /// - Parameter body: A closure that receives a buffer containing the stored UTF-8 bytes.
    /// - Returns: The value returned by `body`.
    /// - Throws: Rethrows any error thrown by `body`.
    public func withUnsafeUTF8Bytes<Result>(_ body: (UnsafeBufferPointer<UInt8>) throws -> Result) rethrows -> Result {
        let storage = (low, high)

        return try withUnsafeBytes(of: storage) { rawBuffer in
            let buffer = rawBuffer.bindMemory(to: UInt8.self)
            return try body(UnsafeBufferPointer(rebasing: buffer[..<self.count]))
        }
    }

    // MARK: - Private methods

    /// Initializes the storage with the UTF-8 representation of the given string.
    ///
    /// The string must fit within the inline storage capacity. When `validating` is
    /// enabled, initialization fails instead of trapping if the capacity is exceeded.
    ///
    /// - Parameters:
    ///   - string: The source string used to initialize the storage.
    ///   - validating: A Boolean value indicating whether capacity violations should
    ///     return `false` instead of triggering a runtime trap.
    /// - Returns: `true` if the string was successfully stored; otherwise, `false`
    ///   when validation is enabled and the string exceeds the storage capacity.
    @discardableResult
    mutating func _initialize(from string: String, validating: Bool) -> Bool {
        guard !string.isEmpty else {
            return true
        }

        let utf8 = string.utf8
        let utf8Count = utf8.count

        switch utf8Count {
        case 0..<16:
            _copyUTF8Bytes(from: utf8)
        case 16:
            _copyStringContent(from: string)
        default:
            return _onExceedingCapacity(validating: validating)
        }

        count = utf8Count
        return true
    }

    /// Copies UTF-8 bytes into the provided storage buffer.
    ///
    /// The caller must ensure that the byte count does not exceed the available
    /// inline storage capacity.
    ///
    /// - Parameters:
    ///   - utf8: A UTF-8 view containing the bytes to copy.
    ///   - storage: The destination storage tuple.
    mutating func _copyUTF8Bytes(from utf8: String.UTF8View) {
        precondition(utf8.count <= 15, "String must fit within small string capacity.")

        withUnsafeBytes(of: utf8) { stringBuffer in
            withUnsafeMutableBytes(of: &low) { lowBuffer in
                withUnsafeMutableBytes(of: &high) { highBuffer in
                    let count = stringBuffer.count
                    let firstCount = min(8, count)

                    lowBuffer.copyMemory(
                        from: UnsafeRawBufferPointer(
                            start: stringBuffer.baseAddress,
                            count: firstCount
                        )
                    )

                    if count > 8 {
                        highBuffer.copyMemory(
                            from: UnsafeRawBufferPointer(
                                start: stringBuffer.baseAddress!.advanced(by: 8),
                                count: count - 8
                            )
                        )
                    }
                }
            }
        }
    }

    /// Copies the UTF-8 contents of a string into the provided storage buffer.
    ///
    /// The caller must ensure that the byte count does not exceed the available
    /// inline storage capacity.
    ///
    /// - Parameters:
    ///   - string: The source string.
    ///   - storage: The destination storage tuple.
    mutating func _copyStringContent(from string: String) {
        var string = string

        string.withUTF8 { stringBuffer in
            precondition(stringBuffer.count == 16, "String must contain exactly 16 bytes.")

            withUnsafeMutableBytes(of: &low) { lowBuffer in
                lowBuffer.copyMemory(
                    from: UnsafeRawBufferPointer(
                        start: stringBuffer.baseAddress,
                        count: 8
                    )
                )
            }

            withUnsafeMutableBytes(of: &high) { highBuffer in
                highBuffer.copyMemory(
                    from: UnsafeRawBufferPointer(
                        start: stringBuffer.baseAddress!.advanced(by: 8),
                        count: 8
                    )
                )
            }
        }
    }

    /// Handles an attempt to store a string that exceeds the inline storage capacity.
    /// - Note: This method traps when validation is disabled.
    /// - Parameter validating: A Boolean value indicating whether the operation
    ///   should fail gracefully instead of trapping.
    /// - Returns: `false` when validation is enabled.
    func _onExceedingCapacity(validating: Bool) -> Bool {
        if validating {
            return false
        }

        fatalError("InlineString16 capacity exceeded")
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
    /// - Important: When the storage is not fully utilized, the last byte is reserved for storing the string length.
    ///   As a result, the final UTF-8 byte of the string cannot be in the range `0x00...0x0F`,
    ///   since those values are reserved for the length encoding.
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

// MARK: - Hashable

extension InlineString16: Hashable {
    /// Hashes the essential components of this value by feeding them into the
    /// given hasher.
    /// - Parameter hasher: The hasher to use when combining the components
    ///   of this instance.
    public func hash(into hasher: inout Hasher) {
        let storage = (low, high)

        withUnsafeBytes(of: storage) { buffer in
            hasher.combine(bytes: buffer)
        }
    }
}

// MARK: - Codable

extension InlineString16: Codable {
    /// Creates an instance by decoding a string.
    /// - Parameter decoder: The decoder to read from.
    /// - Throws: A decoding error if the decoded string exceeds ``capacity`` bytes.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)

        self.init()

        guard _initialize(from: string, validating: true) else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "String exceeds InlineString16 capacity."
            )
        }
    }

    /// Encodes this value as a single string.
    /// - Parameter encoder: The encoder to write to.
    /// - Throws: An error if encoding fails.
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(string)
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

// MARK: - String + InlineString

extension String {
    /// Creates a `String` from an `InlineString16`.
    /// - Parameter value: The inline string to convert.
    public init(_ value: InlineString16) {
        self = value.string
    }
}
