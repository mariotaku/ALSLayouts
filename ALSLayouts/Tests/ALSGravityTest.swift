//
//  ALSGravityTest.swift
//  ALSLayouts
//
//  Created by Mariotaku Lee on 16/9/15.
//
//

import XCTest
@testable import ALSLayouts

class ALSGravityTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParse() {
        XCTAssertEqual(ALSGravity.parse("Center"), ALSGravity.CENTER)
        XCTAssertEqual(ALSGravity.parse("Left|Top"), ALSGravity.LEFT | ALSGravity.TOP)
    }
    
    func testFormat() {
        XCTAssertEqual(ALSGravity.format(ALSGravity.FILL), "Fill")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            XCTAssertEqual(ALSGravity.parse("Fill"), ALSGravity.FILL)
        }
    }
    
}
