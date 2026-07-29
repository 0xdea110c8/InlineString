import Testing
@testable import InlineString

struct StringTests {
    @Test(
          arguments: [
            TestData.stringFitsCapacity,
            TestData.anotherStringFitsCapacity,
            TestData.stringEqualsCapacity,
            TestData.emptyString
          ]
    )
    func `init(_:) returns the contents of InlineString16`(_ string: String) {
        // given
        let inlineString = InlineString16(string)
        // when
        let result = String(inlineString)
        // then
        #expect(result == inlineString.string)
    }
}

extension StringTests {
    private enum TestData {
        static let stringFitsCapacity: String = "1234567890"
        static let anotherStringFitsCapacity: String = "0123456789"
        static let stringEqualsCapacity: String = "1234567890123456"
        static let emptyString: String = ""
    }
}
