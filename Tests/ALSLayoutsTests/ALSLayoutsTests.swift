import XCTest
@testable import ALSLayouts

class ALSLayoutsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(ALSLayouts().text, "Hello, World!")
    }


    static var allTests : [(String, (ALSLayoutsTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
