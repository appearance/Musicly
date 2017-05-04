//
//  MusiclyTests.swift
//  MusiclyTests
//
//  Created by Christopher Webb-Orenstein on 4/12/17.
//  Copyright © 2017 Christopher Webb-Orenstein. All rights reserved.
//

import XCTest
import AVFoundation
@testable import Musicly

class MusiclyTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPerformanceExample() {
        let splashVC = SplashViewController()
        splashVC.viewDidLoad()
        self.measure {
            //splashVC.splashView.zoomAnimation()
        }
    }
    
    
    func testDataStore() {
        let dataStore = iTrackDataStore()
        dataStore.setSearch(string: "new")
        let expect = expectation(description: "Data store calls APIClient to access server data and returns iTrack data array.")
        dataStore.searchForTracks { playlist, error in
            XCTAssert(playlist?.itemCount == 50)
            expect.fulfill()
        }
        waitForExpectations(timeout: 4) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }

    }

    func testTracklistViewController() {
        
    }
    
}
