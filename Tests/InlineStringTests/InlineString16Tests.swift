import Foundation
import Testing
@testable import InlineString

struct InlineString16Tests {
    
    @Test(
        "canStore(_:) returns true when the string fits within the capacity",
        arguments: [
            TestData.stringFitsCapacity,
            TestData.stringEqualsCapacity,
            "12345678"
        ]
    )
    func canStoreReturnsTrueForStringSmallerThanCapacity(_ string: String) {
        // then
        #expect(InlineString16.canStore(string))
    }
    
    @Test(
        "canStore(_:) returns false when the string exceeds the capacity",
        arguments: [
            TestData.stringExceedingCapacity,
            "12345678901234567890"
        ]
    )
    func canStoreReturnsFalseForStringLargerThanCapacity(_ string: String) {
        #expect(!InlineString16.canStore(string))
    }
    
    @Test(
        "capacity matches type constant",
        arguments: [
            InlineString16(),
            InlineString16(TestData.stringFitsCapacity),
            InlineString16(TestData.stringEqualsCapacity),
            "1234567890"
        ]
    )
    func capacityEqualsGenericParameter(_ inlineString: InlineString16) {
        // then
        #expect(inlineString.capacity == InlineString16.Constant.capacity)
    }
    
    @Test(
        "count uses the last byte of the lower word as metadata below capacity",
        arguments: [
            InlineString16(TestData.stringFitsCapacity),
            InlineString16(validating: TestData.stringFitsCapacity)!,
            "1234567890"
        ]
    )
    func countReturnsLastByteForDataSmallerThanCapacity(_ inlineString: InlineString16) {
        // then
        #expect(inlineString.count == UInt8(truncatingIfNeeded: inlineString.low))
    }
    
    @Test(
        "count uses capacity when storage is fully occupied",
        arguments: [
            InlineString16(TestData.stringEqualsCapacity),
            InlineString16(validating: TestData.stringEqualsCapacity)!,
            "1234567890123456"
        ]
    )
    func countReturnsCapacityForExactCapacity(_ inlineString: InlineString16) {
        // then
        #expect(inlineString.count != UInt8(truncatingIfNeeded: inlineString.low))
        #expect(inlineString.count == inlineString.capacity)
    }
    
    @Test(
        "isEmpty returns true when the count is zero",
        arguments: [
            InlineString16(),
            InlineString16(TestData.emptyString),
            ""
        ]
    )
    func isEmptyReturnsTrueWhenCountIsZero(_ inlineString: InlineString16) {
        // then
        #expect(inlineString.count == 0)
        #expect(inlineString.isEmpty)
    }
    
    @Test(
        "isEmpty returns false when the count is not zero",
        arguments: [
            InlineString16(TestData.nonEmptyString),
            "1234567890"
        ]
    )
    func isEmptyReturnsFalseWhenCountIsNotZero(_ inlineString: InlineString16) {
        // then
        #expect(inlineString.count != 0)
        #expect(!inlineString.isEmpty)
    }
    
    @Test(
        "string matches the decoded UTF-8 bytes",
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
    func stringMatchesDecodedUTF8(_ inlineString: InlineString16) {
        // given
        let storage = (inlineString.high.bigEndian, inlineString.low.bigEndian)
        let decodedUTF8 = withUnsafeBytes(of: storage) { buffer in
            let bytes = buffer.prefix(inlineString.count)
            return String(decoding: bytes, as: UTF8.self)
        }
        // then
        #expect(inlineString.string == decodedUTF8)
    }
    
    private enum TestData {
        static let stringFitsCapacity: String = "1234567890"
        static let stringEqualsCapacity: String = "1234567890123456"
        static let stringExceedingCapacity: String = "12345678901234567890"
        static let emptyString: String = ""
        static let nonEmptyString: String = "12345678"
    }
}
//    
//    @Test("string matches the decoded UTF-8 bytes")
//    func stringMatchesDecodedUTF8() {
//        // given
//        let inlineString = InlineString16(truncating: TestData.string)
//        let string = inlineString.string
//        let decodedUTF8 = withUnsafeBytes(of: inlineString._storage) { buffer in
//            let bytes = buffer.prefix(inlineString.count)
//            return String(decoding: bytes, as: UTF8.self)
//        }
//        // then
//        #expect(string == decodedUTF8)
//    }
//    
//    @Test("init() creates empty inline string with zeroed storage")
//    func initCreatesZeroedStorage() {
//        let inlineString = InlineString16()
//        withUnsafeBytes(of: inlineString._storage) { bytes in
//            #expect(bytes.count == InlineString16.capacity)
//            #expect(bytes.allSatisfy { $0 == 0 })
//        }
//        #expect(inlineString.count == 0)
//    }
//    
//    @Test("init(truncating:) stores full string when it fits capacity")
//    func truncatingInitStoresFullStringWhenFits() {
//        // given
//        let inlineString = InlineString16(truncating: TestData.stringFitsCapacity)
//        // then
//        #expect(inlineString.count == TestData.stringFitsCapacity.utf8.count)
//        withUnsafeBytes(of: inlineString._storage) { bytes in
//            let stored = Array(bytes.prefix(inlineString.count))
//            #expect(stored == Array(TestData.stringFitsCapacity.utf8))
//        }
//    }
//    
//    @Test("init(truncating:) truncates to capacity when source is too long")
//    func truncatingInitTruncatesWhenTooLong() {
//        // given
//        let inlineString = InlineString16(truncating: TestData.stringExceedsCapacity)
//        let expectedPrefixBytes = Array(TestData.stringExceedsCapacity.utf8.prefix(InlineString16.capacity))
//        // then
//        #expect(inlineString.count == InlineString16.capacity)
//        withUnsafeBytes(of: inlineString._storage) { bytes in
//            let stored = Array(bytes.prefix(inlineString.count))
//            #expect(stored == expectedPrefixBytes)
//        }
//    }
//    
//    @Test("append(_:) returns true and updates the inline string when string fits remaining capacity")
//    func appendReturnsTrueWhenStringFitsCapacity() {
//        // given
//        var inlineString = InlineString16()
//        // when
//        let result = inlineString.append(TestData.stringFitsCapacity)
//        // then
//        #expect(result == true)
//        #expect(inlineString.count == TestData.stringFitsCapacity.utf8.count)
//        withUnsafeBytes(of: inlineString._storage) { bytes in
//            let storedBytes = bytes.prefix(inlineString.count)
//            #expect(Array(storedBytes) == Array(TestData.stringFitsCapacity.utf8))
//        }
//    }
//    
//    @Test("append(_:) returns false and does not mutate when string exceeds remaining capacity")
//    func appendReturnsFalseWhenStringExceedsCapacity() {
//        // given
//        var inlineString = InlineString16()
//        // when
//        let result = inlineString.append(TestData.stringExceedsCapacity)
//        // then
//        #expect(result == false)
//        #expect(inlineString.count == 0)
//        withUnsafeBytes(of: inlineString._storage) { bytes in
//            #expect(bytes.count == InlineString16.capacity)
//            #expect(bytes.allSatisfy { $0 == 0 })
//        }
//    }
//    
//    @Test("append(truncating:) adds nothing and returns zero when no remaining capacity")
//    func appendTruncatingReturnsZeroWhenNoCapacity() {
//        // given
//        var inlineString = InlineString16()
//        inlineString.append(TestData.stringFitsCapacity)
//        let remainingCapacity = inlineString.remainingCapacity
//        // when
//        let result = inlineString.append(truncating: TestData.string)
//        // then
//        withUnsafeBytes(of: inlineString._storage) { bytes in
//            let stored = Array(bytes.prefix(inlineString.count))
//            #expect(stored == Array(TestData.stringFitsCapacity.utf8))
//        }
//        #expect(remainingCapacity == 0)
//        #expect(result == remainingCapacity)
//    }
//    
//    @Test("append(truncating:) returns full length and appends all bytes when input fits remaining capacity")
//    func appendTruncatingAppendsAllWhenFits() {
//        // given
//        var inlineString = InlineString16()
//        let remainingCapacity = inlineString.remainingCapacity
//        // when
//        let result = inlineString.append(truncating: TestData.stringFitsCapacity)
//        // then
//        withUnsafeBytes(of: inlineString._storage) { bytes in
//            let stored = Array(bytes.prefix(inlineString.count))
//            #expect(stored == Array(TestData.stringFitsCapacity.utf8))
//        }
//        #expect(result == remainingCapacity)
//    }
//
//    @Test("append(truncating:) truncates to remaining capacity and returns appended bytes count when input is too long")
//    func appendTruncatingTruncatesWhenTooLong() {
//        // given
//        var inlineString = InlineString16()
//        let remainingCapacity = inlineString.remainingCapacity
//        // when
//        let result = inlineString.append(truncating: TestData.stringExceedsCapacity)
//        // then
//        withUnsafeBytes(of: inlineString._storage) { bytes in
//            let stored = Array(bytes.prefix(inlineString.count))
//            #expect(stored == Array(TestData.stringExceedsCapacity.prefix(remainingCapacity).utf8))
//        }
//        #expect(result == remainingCapacity)
//    }
//    
//    @Test("clear() sets the count to zero")
//    func clearSetsTheCountToZero() {
//        // given
//        var inlineString = InlineString16(truncating: TestData.string)
//        // when
//        inlineString.clear()
//        // then
//        #expect(inlineString.count == 0)
//    }
//    
//    @Test("withUTF8(_:) passes a buffer matching stored bytes and count")
//    func withUTF8PassesMatchingBuffer() {
//        // given
//        let inlineString = InlineString16(truncating: TestData.string)
//        // when
//        inlineString.withUTF8 { buffer in
//            let stored = withUnsafeBytes(of: inlineString._storage) { bytes in
//                Array(bytes.prefix(inlineString.count))
//            }
//            // then
//            #expect(buffer.count == inlineString.count)
//            #expect(Array(buffer) == stored)
//        }
//    }
//    
//    @Test("withUTF8(_:) rethrows errors from the closure")
//    func withUTF8RethrowsErrors() {
//        // given
//        let inlineString = InlineString16(truncating: TestData.string)
//        // when
//        do {
//            _ = try inlineString.withUTF8 { _ in
//                throw TestData.TestError.withUTF8Error
//            }
//        } catch {
//            // then
//            #expect(error is TestData.TestError)
//        }
//    }
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
