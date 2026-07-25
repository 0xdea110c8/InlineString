import Testing
@testable import InlineString

struct StringTests {
    @Test("init(_: InlineString16) returns the contents of InlineString16")
    func stringInitFromInlineStringFull() {
        // given
        let inlineString = InlineString16(truncating: TestData.string)

        // when
        let result = String(inlineString)

        // then
        #expect(result == inlineString.string)
    }
}

extension StringTests {
    private enum TestData {
        static let string = "Hello, world!"
    }
}
