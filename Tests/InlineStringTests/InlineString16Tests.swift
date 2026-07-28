import Foundation
import Testing
@testable import InlineString

// NOTE:
// This test suite contains exit tests.
// These tests should only be run on macOS.
struct InlineString16Tests {
    @Test(
        arguments: [
            TestData.stringFitsCapacity,
            TestData.stringEqualsCapacity,
            TestData.emptyString,
            "",
            "abc123",
            "London",
            "Текст",
            "USA 🇺🇸"
        ]
    )
    func `canStore(_:) returns true when the string fits within the capacity`(
        _ string: String
    ) {
        // then
        #expect(InlineString16.canStore(string))
    }
    
    @Test(
        arguments: [
            TestData.stringExceedingCapacity,
            "12345678901234567890"
        ]
    )
    func `canStore(_:) returns false when the string exceeds the capacity`(
        _ string: String
    ) {
        // then
        #expect(!InlineString16.canStore(string))
    }
    
    @Test(
        arguments: [
            InlineString16(),
            InlineString16(TestData.stringFitsCapacity),
            InlineString16(TestData.stringEqualsCapacity),
            "1234567890"
        ]
    )
    func `capacity matches type constant`(
        _ inlineString: InlineString16
    ) {
        // then
        #expect(inlineString.capacity == InlineString16.Constant.capacity)
    }
    
    @Test(
        arguments: [
            InlineString16(TestData.stringFitsCapacity),
            InlineString16(validating: TestData.stringFitsCapacity)!,
            "1234567890"
        ]
    )
    func `count uses the last byte of the lower word as metadata below capacity`(
        _ inlineString: InlineString16
    ) {
        // then
        #expect(inlineString.count == UInt8(truncatingIfNeeded: inlineString.low))
    }
    
    @Test(
        arguments: [
            InlineString16(TestData.stringEqualsCapacity),
            InlineString16(validating: TestData.stringEqualsCapacity)!,
            "1234567890123456"
        ]
    )
    func `count uses capacity when storage is fully occupied`(
        _ inlineString: InlineString16
    ) {
        // then
        #expect(inlineString.count != UInt8(truncatingIfNeeded: inlineString.low))
        #expect(inlineString.count == inlineString.capacity)
    }
    
    @Test(
        arguments: [
            InlineString16(),
            InlineString16(TestData.emptyString),
            ""
        ]
    )
    func `isEmpty returns true when the count is zero`(
        _ inlineString: InlineString16
    ) {
        // then
        #expect(inlineString.count == 0)
        #expect(inlineString.isEmpty)
    }
    
    @Test(
        arguments: [
            InlineString16(TestData.nonEmptyString),
            "1234567890"
        ]
    )
    func `isEmpty returns false when the count is not zero`(
        _ inlineString: InlineString16
    ) {
        // then
        #expect(inlineString.count != 0)
        #expect(!inlineString.isEmpty)
    }
    
    @Test(
        arguments: [
            InlineString16(),
            InlineString16(TestData.stringFitsCapacity),
            InlineString16(TestData.stringEqualsCapacity),
            InlineString16(TestData.emptyString),
            InlineString16(TestData.nonEmptyString),
            "",
            "abc123",
            "London",
            "Текст",
            "USA 🇺🇸"
        ]
    )
    func `string matches the decoded UTF-8 bytes`(
        _ inlineString: InlineString16
    ) {
        // given
        let storage = (inlineString.high.bigEndian, inlineString.low.bigEndian)
        let decodedUTF8 = withUnsafeBytes(of: storage) { buffer in
            let bytes = buffer.prefix(inlineString.count)
            return String(decoding: bytes, as: UTF8.self)
        }
        // then
        #expect(inlineString.string == decodedUTF8)
    }
    
    @Test
    func `init() creates empty inline string with zeroed storage`() {
        // given
        let inlineString = InlineString16()
        // then
        #expect(inlineString.high == 0)
        #expect(inlineString.low == 0)
    }
    
#if os(macOS)
    // NOTE: This test intentionally terminates the current process and should only be run on macOS.
    @Test
    func `init(_:) traps when string exceeds the capacity`() async {
        // then
        await #expect(processExitsWith: .failure) {
            let _ = InlineString16(TestData.stringExceedingCapacity)
        }
    }
#endif // os(macOS)
    
    @Test(
        arguments: [
            TestData.stringFitsCapacity,
            TestData.stringEqualsCapacity,
            TestData.emptyString,
            "",
            "abc123",
            "London",
            "Текст",
            "USA 🇺🇸"
        ]
    )
    func `init(_:) stores a string when it fits within the capacity`(
        _ string: String
    ) {
        // given
        let inlineString = InlineString16(string)
        // then
        #expect(inlineString.count == string.utf8.count)
        #expect(inlineString.string == string)
    }
    
    @Test(
        arguments: [
            TestData.stringExceedingCapacity
        ]
    )
    func `init(validating:) fails when string exceeds the capacity`(
        _ string: String
    ) {
        // given
        let inlineString = InlineString16(validating: string)
        // then
        #expect(inlineString == nil)
    }
    
    @Test(
        arguments: [
            TestData.stringFitsCapacity,
            TestData.stringEqualsCapacity,
            TestData.emptyString,
            "",
            "abc123",
            "London",
            "Текст",
            "USA 🇺🇸"
        ]
    )
    func `init(validating:) stores a string when it fits within the capacity`(
        _ string: String
    ) {
        // given
        let inlineString = InlineString16(validating: string)
        // then
        #expect(inlineString?.count == string.utf8.count)
        #expect(inlineString?.string == string)
    }
    
    @Test(
        arguments: [
            InlineString16(TestData.stringFitsCapacity),
            InlineString16(TestData.stringEqualsCapacity),
            InlineString16(TestData.emptyString),
            "",
            "abc123",
            "London",
            "Текст",
            "USA 🇺🇸"
        ]
    )
    func `withUnsafeUTF8Bytes(_:) passes a buffer matching stored bytes and count`(
        _ inlineString: InlineString16
    ) {
        // given
        let storage = (inlineString.high.bigEndian, inlineString.low.bigEndian)
        // when
        inlineString.withUnsafeUTF8Bytes { buffer in
            let stored = withUnsafeBytes(of: storage) { bytes in
                Array(bytes.prefix(inlineString.count))
            }
            // then
            #expect(buffer.count == inlineString.count)
            #expect(Array(buffer) == stored)
        }
    }
    
    @Test(
        arguments: [
            InlineString16(TestData.stringFitsCapacity),
            InlineString16(TestData.stringEqualsCapacity),
            InlineString16(TestData.emptyString),
            "",
            "abc123",
            "London",
            "Текст",
            "USA 🇺🇸"
        ]
    )
    func `withUnsafeUTF8Bytes(_:) rethrows errors from the closure`(
        _ inlineString: InlineString16
    ) {
        // when
        do {
            _ = try inlineString.withUnsafeUTF8Bytes { _ in
                throw TestData.TestError.withUTF8Error
            }
        } catch {
            // then
            #expect(error is TestData.TestError)
        }
    }
    
    @Test(
        arguments: [
            TestData.emptyString,
            ""
        ]
    )
    func `_initialize(from:validating:) returns true when string is empty`(
        _ string: String
    ) {
        // given
        var inlineString = InlineString16()
        // when
        let resultWithoutValidation = inlineString._initialize(from: string, validating: false)
        let resultWithValidation = inlineString._initialize(from: string, validating: true)
        // then
        #expect(resultWithoutValidation == true)
        #expect(resultWithValidation == true)
    }
    
#if os(macOS)
    // NOTE: This test intentionally terminates the current process and should only be run on macOS.
    @Test
    func `_initialize(from:validating:) traps when string exceeds the capacity and validation disabled`() async {
        // then
        await #expect(processExitsWith: .failure) {
            var inlineString = InlineString16()
            inlineString._initialize(from: TestData.stringExceedingCapacity, validating: false)
        }
    }
#endif // os(macOS)
    
    @Test(
        arguments: [
            TestData.stringExceedingCapacity
        ]
    )
    func `_initialize(from:validating:) returns false when string exceeds the capacity and validation enabled`(
        _ string: String
    ) {
        // given
        var inlineString = InlineString16()
        // when
        let result = inlineString._initialize(from: string, validating: true)
        // then
        #expect(result == false)
    }
    
    @Test(
        arguments: [
            TestData.stringFitsCapacity,
            TestData.stringEqualsCapacity,
            "abc123",
            "London",
            "Текст",
            "USA 🇺🇸"
        ]
    )
    func `_initialize(from:validating:) stores a string and returns true when string fits within the capacity`(
        _ string: String
    ) {
        // given
        var inlineString = InlineString16()
        var secondInlineString = InlineString16()
        // when
        let result = inlineString._initialize(from: string, validating: true)
        let secondResult = secondInlineString._initialize(from: string, validating: false)
        // then
        #expect(result == true)
        #expect(inlineString.count == string.utf8.count)
        #expect(inlineString.string == string)
        #expect(secondResult == true)
        #expect(secondInlineString.count == string.utf8.count)
        #expect(secondInlineString.string == string)
    }
}

extension InlineString16Tests {
    private enum TestData {
        enum TestError: Error {
            case withUTF8Error
        }
        
        static let stringFitsCapacity: String = "1234567890"
        static let stringEqualsCapacity: String = "1234567890123456"
        static let stringExceedingCapacity: String = "12345678901234567890"
        static let emptyString: String = ""
        static let nonEmptyString: String = "12345678"
    }
}
//
//    @Test("description returns the string representation")
//    func descriptionReturnsStringRepresentation() {
//        // given
//        let inlineString = InlineString16(truncating: TestData.string)
//        // then
//        #expect(String(describing: inlineString) == TestData.string)
//    }
//    
//    @Test("debugDescription returns the expected representation")
//    func debugDescriptionReturnsExpectedRepresentation() {
//        // given
//        let inlineString = InlineString16(truncating: TestData.string)
//        // then
//        #expect(String(reflecting: inlineString) == "InlineString16(\"\(TestData.string)\")")
//    }
//    
//    @Test("init(from:) succeeds and stores full string when it fits capacity")
//    func decodingStoresFullStringWhenFits() throws {
//        // when
//        let inlineString = try JSONDecoder().decode(InlineString16.self, from: TestData.dataFitsCapacity)
//        // then
//        #expect(inlineString.count == TestData.stringFitsCapacity.utf8.count)
//        withUnsafeBytes(of: inlineString._storage) { bytes in
//            let stored = Array(bytes.prefix(inlineString.count))
//            #expect(stored == Array(TestData.stringFitsCapacity.utf8))
//        }
//    }
//    
//    @Test("init(from:) fails when source exceeds capacity")
//    func decodingFailsWhenTooLong() throws {
//        // given
//        let dataExceedsCapacity = TestData.dataExceedsCapacity
//        // when
//        do {
//            _ = try JSONDecoder().decode(InlineString16.self, from: dataExceedsCapacity)
//        } catch _ as InlineString16.InlineString16Error {
//            // then
//            #expect(true)
//        }
//    }
//    
//    @available(iOS 26.0, *)
//    @Test("encode(to:) encodes the string")
//    func encodingEncodesFullStringWhenFits() throws {
//        // given
//        let inlineString = InlineString16(truncating: TestData.stringFitsCapacity)
//        // when
//        let data = try JSONEncoder().encode(inlineString)
//        // then
//        #expect(data == TestData.dataFitsCapacity)
//    }
//    
//    @Test("== returns false when strings have different counts")
//    func equalityReturnsFalseForDifferentCounts() {
//        // given
//        let lhs = InlineString16(truncating: TestData.string)
//        let rhs = InlineString16(truncating: TestData.anotherString)
//        // then
//        #expect(lhs != rhs)
//    }
//    
//    @Test("== returns true when both strings are empty")
//    func equalityReturnsTrueForBothEmpty() {
//        // given
//        let lhs = InlineString16()
//        let rhs = InlineString16()
//        // then
//        #expect(lhs == rhs)
//    }
//    
//    @Test("== returns true when strings have same count and bytes")
//    func equalityReturnsTrueForSameContents() {
//        // given
//        let lhs = InlineString16(truncating: TestData.string)
//        let rhs = InlineString16(truncating: TestData.string)
//        // then
//        #expect(lhs == rhs)
//    }
//    
//    @Test("== returns false when strings have same count but different bytes")
//    func equalityReturnsFalseForDifferentValues() {
//        // given
//        let lhs = InlineString16(truncating: TestData.string)
//        let rhs = InlineString16(truncating: TestData.stringWithSameCount)
//        // then
//        #expect(lhs != rhs)
//    }
//    
//    @Test("init(stringLiteral:) produces the same inline string as init(truncating:)")
//    func stringLiteralMatchesStringInitializer() {
//        // given
//        let fromLiteral: InlineString16 = "Hello, world!"
//        let fromString = InlineString16(truncating: "Hello, world!")
//        // then
//        #expect(fromLiteral == fromString)
//    }
