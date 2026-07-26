import Foundation
import Testing
@testable import InlineString

struct InlineString16Tests {
    
    @Test("capacity matches type constant")
    func capacityEqualsGenericParameter() {
        // given
        let inlineString = InlineString16()
        // then
        #expect(inlineString.capacity == InlineString16.capacity)
    }
    
    @Test("count uses the last byte as metadata below capacity")
    func countReturnsLastByteForDataSmallerThanCapacity() {
        // given
        let inlineString = InlineString16(truncating: TestData.string)
        // then
        #expect(inlineString.count == inlineString._storage.15)
    }
    
    @Test("count uses capacity when storage is fully occupied")
    func countReturnsCapacityForExactCapacity() {
        // given
        let inlineString = InlineString16(truncating: TestData.stringFitsCapacity)
        // then
        #expect(inlineString.count == inlineString.capacity)
        #expect(inlineString._storage.15 == TestData.stringFitsCapacity.utf8.last)
    }
    
    @Test("isEmpty reflects whether the count is zero")
    func isEmptyReflectsCountIsZero() {
        // given
        let inlineString = InlineString16(truncating: TestData.string)
        let emptyInlineString = InlineString16()
        // then
        #expect(inlineString.count != 0)
        #expect(!inlineString.isEmpty)
        #expect(emptyInlineString.count == 0)
        #expect(emptyInlineString.isEmpty)
    }
    
    @Test("remainingCapacity reflects remaining space in bytes")
    func remainingCapacityReflectsRemainingSpace() {
        // given
        let inlineString = InlineString16()
        // then
        #expect(inlineString.remainingCapacity == inlineString.capacity - inlineString.count)
            
    }
    
    @Test("string matches the decoded UTF-8 bytes")
    func stringMatchesDecodedUTF8() {
        // given
        let inlineString = InlineString16(truncating: TestData.string)
        let string = inlineString.string
        let decodedUTF8 = withUnsafeBytes(of: inlineString._storage) { buffer in
            let bytes = buffer.prefix(inlineString.count)
            return String(decoding: bytes, as: UTF8.self)
        }
        // then
        #expect(string == decodedUTF8)
    }
    
    @Test("init() creates empty inline string with zeroed storage")
    func initCreatesZeroedStorage() {
        let inlineString = InlineString16()
        withUnsafeBytes(of: inlineString._storage) { bytes in
            #expect(bytes.count == InlineString16.capacity)
            #expect(bytes.allSatisfy { $0 == 0 })
        }
        #expect(inlineString.count == 0)
    }
    
    @Test("init(truncating:) stores full string when it fits capacity")
    func truncatingInitStoresFullStringWhenFits() {
        // given
        let inlineString = InlineString16(truncating: TestData.stringFitsCapacity)
        // then
        #expect(inlineString.count == TestData.stringFitsCapacity.utf8.count)
        withUnsafeBytes(of: inlineString._storage) { bytes in
            let stored = Array(bytes.prefix(inlineString.count))
            #expect(stored == Array(TestData.stringFitsCapacity.utf8))
        }
    }
    
    @Test("init(truncating:) truncates to capacity when source is too long")
    func truncatingInitTruncatesWhenTooLong() {
        // given
        let capacity = 16
        let inlineString = InlineString16(truncating: TestData.stringExceedsCapacity)
        let expectedPrefixBytes = Array(TestData.stringExceedsCapacity.utf8.prefix(capacity))
        // then
        #expect(inlineString.count == capacity)
        withUnsafeBytes(of: inlineString._storage) { bytes in
            let stored = Array(bytes.prefix(inlineString.count))
            #expect(stored == expectedPrefixBytes)
        }
    }
    
    @Test("append(_:) returns true and updates the inline string when string fits remaining capacity")
    func appendReturnsTrueWhenStringFitsCapacity() {
        // given
        var inlineString = InlineString16()
        // when
        let result = inlineString.append(TestData.stringFitsCapacity)
        // then
        #expect(result == true)
        #expect(inlineString.count == TestData.stringFitsCapacity.utf8.count)
        withUnsafeBytes(of: inlineString._storage) { bytes in
            let storedBytes = bytes.prefix(inlineString.count)
            #expect(Array(storedBytes) == Array(TestData.stringFitsCapacity.utf8))
        }
    }
    
    @Test("append(_:) returns false and does not mutate when string exceeds remaining capacity")
    func appendReturnsFalseWhenStringExceedsCapacity() {
        // given
        var inlineString = InlineString16()
        // when
        let result = inlineString.append(TestData.stringExceedsCapacity)
        // then
        #expect(result == false)
        #expect(inlineString.count == 0)
        withUnsafeBytes(of: inlineString._storage) { bytes in
            #expect(bytes.count == 16)
            #expect(bytes.allSatisfy { $0 == 0 })
        }
    }
    
    @Test("append(truncating:) adds nothing and returns zero when no remaining capacity")
    func appendTruncatingReturnsZeroWhenNoCapacity() {
        // given
        var inlineString = InlineString16()
        inlineString.append(TestData.stringFitsCapacity)
        let remainingCapacity = inlineString.remainingCapacity
        // when
        let result = inlineString.append(truncating: TestData.string)
        // then
        withUnsafeBytes(of: inlineString._storage) { bytes in
            let stored = Array(bytes.prefix(inlineString.count))
            #expect(stored == Array(TestData.stringFitsCapacity.utf8))
        }
        #expect(remainingCapacity == 0)
        #expect(result == remainingCapacity)
    }
    
    @Test("append(truncating:) returns full length and appends all bytes when input fits remaining capacity")
    func appendTruncatingAppendsAllWhenFits() {
        // given
        var inlineString = InlineString16()
        let remainingCapacity = inlineString.remainingCapacity
        // when
        let result = inlineString.append(truncating: TestData.stringFitsCapacity)
        // then
        withUnsafeBytes(of: inlineString._storage) { bytes in
            let stored = Array(bytes.prefix(inlineString.count))
            #expect(stored == Array(TestData.stringFitsCapacity.utf8))
        }
        #expect(result == remainingCapacity)
    }

    @Test("append(truncating:) truncates to remaining capacity and returns appended bytes count when input is too long")
    func appendTruncatingTruncatesWhenTooLong() {
        // given
        var inlineString = InlineString16()
        let remainingCapacity = inlineString.remainingCapacity
        // when
        let result = inlineString.append(truncating: TestData.stringExceedsCapacity)
        // then
        withUnsafeBytes(of: inlineString._storage) { bytes in
            let stored = Array(bytes.prefix(inlineString.count))
            #expect(stored == Array(TestData.stringExceedsCapacity.prefix(remainingCapacity).utf8))
        }
        #expect(result == remainingCapacity)
    }
    
    @Test("clear() sets the count to zero")
    func clearSetsTheCountToZero() {
        // given
        var inlineString = InlineString16(truncating: TestData.string)
        // when
        inlineString.clear()
        // then
        #expect(inlineString.count == 0)
    }
    
    @Test("withUTF8(_:) passes a buffer matching stored bytes and count")
    func withUTF8PassesMatchingBuffer() {
        // given
        let inlineString = InlineString16(truncating: TestData.string)
        // when
        inlineString.withUTF8 { buffer in
            let stored = withUnsafeBytes(of: inlineString._storage) { bytes in
                Array(bytes.prefix(inlineString.count))
            }
            // then
            #expect(buffer.count == inlineString.count)
            #expect(Array(buffer) == stored)
        }
    }
    
    @Test("withUTF8(_:) rethrows errors from the closure")
    func withUTF8RethrowsErrors() {
        // given
        let inlineString = InlineString16(truncating: TestData.string)
        // when
        do {
            _ = try inlineString.withUTF8 { _ in
                throw TestData.TestError.withUTF8Error
            }
        } catch {
            // then
            #expect(error is TestData.TestError)
        }
    }
    
    @Test("description returns the string representation")
    func descriptionReturnsStringRepresentation() {
        // given
        let inlineString = InlineString16(truncating: TestData.string)
        // then
        #expect(String(describing: inlineString) == TestData.string)
    }
    
    @Test("debugDescription returns the expected representation")
    func debugDescriptionReturnsExpectedRepresentation() {
        // given
        let inlineString = InlineString16(truncating: TestData.string)
        // then
        #expect(String(reflecting: inlineString) == "InlineString16(\"\(TestData.string)\")")
    }
    
    @Test("init(from:) succeeds and stores full string when it fits capacity")
    func decodingStoresFullStringWhenFits() throws {
        // when
        let inlineString = try JSONDecoder().decode(InlineString16.self, from: TestData.dataFitsCapacity)
        // then
        #expect(inlineString.count == TestData.stringFitsCapacity.utf8.count)
        withUnsafeBytes(of: inlineString._storage) { bytes in
            let stored = Array(bytes.prefix(inlineString.count))
            #expect(stored == Array(TestData.stringFitsCapacity.utf8))
        }
    }
    
    @Test("init(from:) fails when source exceeds capacity")
    func decodingFailsWhenTooLong() throws {
        // given
        let dataExceedsCapacity = TestData.dataExceedsCapacity
        // when
        do {
            _ = try JSONDecoder().decode(InlineString16.self, from: dataExceedsCapacity)
        } catch _ as InlineString16.InlineString16Error {
            // then
            #expect(true)
        }
    }
    
    @available(iOS 26.0, *)
    @Test("encode(to:) encodes the string")
    func encodingEncodesFullStringWhenFits() throws {
        // given
        let inlineString = InlineString16(truncating: TestData.stringFitsCapacity)
        // when
        let data = try JSONEncoder().encode(inlineString)
        // then
        #expect(data == TestData.dataFitsCapacity)
    }
    
    @Test("== returns false when strings have different counts")
    func equalityReturnsFalseForDifferentCounts() {
        // given
        let lhs = InlineString16(truncating: TestData.string)
        let rhs = InlineString16(truncating: TestData.anotherString)
        // then
        #expect(lhs != rhs)
    }
    
    @Test("== returns true when both strings are empty")
    func equalityReturnsTrueForBothEmpty() {
        // given
        let lhs = InlineString16()
        let rhs = InlineString16()
        // then
        #expect(lhs == rhs)
    }
    
    @Test("== returns true when strings have same count and bytes")
    func equalityReturnsTrueForSameContents() {
        // given
        let lhs = InlineString16(truncating: TestData.string)
        let rhs = InlineString16(truncating: TestData.string)
        // then
        #expect(lhs == rhs)
    }
    
    @Test("== returns false when strings have same count but different bytes")
    func equalityReturnsFalseForDifferentValues() {
        // given
        let lhs = InlineString16(truncating: TestData.string)
        let rhs = InlineString16(truncating: TestData.stringWithSameCount)
        // then
        #expect(lhs != rhs)
    }
    
    @Test("init(stringLiteral:) produces the same inline string as init(truncating:)")
    func stringLiteralMatchesStringInitializer() {
        // given
        let fromLiteral: InlineString16 = "Hello, world!"
        let fromString = InlineString16(truncating: "Hello, world!")
        // then
        #expect(fromLiteral == fromString)
    }
    
    private enum TestData {
        static let string = "Hello, world!"
        static let stringWithSameCount = "Hello, world?"
        static let anotherString = "Hey!"
        static let stringFitsCapacity = "ABCDEFGHIGJKLMNO"
        static let stringExceedsCapacity = "12345678901234567890"
        static let dataFitsCapacity = Data("\"\(stringFitsCapacity)\"".utf8)
        static let dataExceedsCapacity = Data("\"\(stringExceedsCapacity)\"".utf8)
        
        enum TestError: Error {
            case withUTF8Error
        }
    }
}

