//
//  CreateTaskTest.swift
//  WeekPlaner
//
//  Created by Seydi Ahmet Kiyak on 05.07.16.
//  Copyright © 2016 Seydi Ahmet Kiyak. All rights reserved.
//

import XCTest

class CreateTaskTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        EarlGrey().selectElementWithMatcher(grey_accessibilityLabel("tabBarAufgaben"))
            .performAction(grey_tap())
            .assertWithMatcher(grey_accessibilityTrait(UIAccessibilityTraitSelected))
        
        
        EarlGrey().selectElementWithMatcher(grey_accessibilityLabel("addTask"))
            .performAction(grey_tap())
        
        
        /*
        EarlGrey().selectElementWithMatcher(grey_accessibilityLabel("add"))
            .performAction(grey_tap())
*/
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
