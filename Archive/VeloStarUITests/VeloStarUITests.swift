//
//  VeloStarUITests.swift
//  VeloStarUITests
//
//  Created by Baptiste Alexandre on 25/05/2018.
//  Copyright © 2018 ALXDR. All rights reserved.
//

import XCTest
import CoreGraphics

class VeloStarUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMapIsVisibleWhenUsingSegmentedControl() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        
        app/*@START_MENU_TOKEN@*/.buttons["Carte"]/*[[".segmentedControls.buttons[\"Carte\"]",".buttons[\"Carte\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        let window = app.windows.element(boundBy: 0)
        let tableView = app.tables.element
        let mapView = app.maps.element

        print(app.debugDescription)

        XCTAssert(mapView.exists)
        XCTAssert(mapView.isHittable)
        XCTAssert(window.frame.contains(mapView.frame))

        app/*@START_MENU_TOKEN@*/.buttons["Liste"]/*[[".segmentedControls.buttons[\"Liste\"]",".buttons[\"Liste\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        XCTAssert(tableView.exists)
        XCTAssert(tableView.isHittable)
        XCTAssert(window.frame.contains(tableView.frame))
        
    }
    
}
