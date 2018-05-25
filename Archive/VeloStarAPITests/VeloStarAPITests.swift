//
//  VeloStarAPITests.swift
//  VeloStarAPITests
//
//  Created by Baptiste Alexandre on 25/05/2018.
//  Copyright © 2018 ALXDR. All rights reserved.
//

import XCTest

class VeloStarAPITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testVeloStarAPIReturnsHTTPStatusCode200() {
        let urlString = "https://data.rjjjennesmetropole.fr/api/records/1.0/search/?dataset=etat-des-stations-le-velo-star-en-temps-reel&rows=200&facet=nom&facet=etat&facet=nombreemplacementsactuels&facet=nombreemplacementsdisponibles&facet=nombrevelosdisponibles"

        let promise = expectation(description: "Status code: 200")
        var statusCode: Int?
        var responseError: Error?
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error

            promise.fulfill()
        }.resume()
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
