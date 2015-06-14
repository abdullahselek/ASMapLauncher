//
//  ASMapLauncherTests.swift
//  ASMapLauncherTests
//
//  Created by Abdullah Selek on 06/06/15.
//  Copyright (c) 2015 Abdullah Selek. All rights reserved.
//

import UIKit
import XCTest
import MapKit

class ASMapLauncherTests: XCTestCase {
    
    private var mapLauncher: ASMapLauncher!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        mapLauncher = ASMapLauncher()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        mapLauncher = nil
        
        super.tearDown()
    }
    
    func testUrlPrefixForMapApp() {
        var mapAppType: ASMapApp! = ASMapApp.ASMapAppAppleMaps
        XCTAssertNotNil(mapAppType.rawValue, "Map app value can not be nil")
        
        let urlPrefix = mapLauncher.urlPrefixForMapApp(mapAppType)
        XCTAssertNotNil(urlPrefix, "Url prefix can not be nil")
    }
    
    func testIsMapAppInstalled() {
        var mapAppType: ASMapApp! = ASMapApp.ASMapAppAppleMaps
        XCTAssertNotNil(mapAppType.rawValue, "Map app value can not be nil")
        
        let isMapAppInstalled = mapLauncher.isMapAppInstalled(mapAppType)
        XCTAssertTrue(isMapAppInstalled, "Map is not installed")
    }
    
    func testGoogleMapsString() {
        var mapAppType: ASMapApp! = ASMapApp.ASMapAppAppleMaps
        XCTAssertNotNil(mapAppType.rawValue, "Map app value can not be nil")
        
        var location: CLLocation! = CLLocation(latitude: 41.0053215, longitude: 29.0121795)
        var mapPoint: ASMapPoint! = ASMapPoint(location: location, name: "", address: "")
        
        let googleMapsString = mapLauncher.googleMapsString(mapPoint)
        XCTAssertNotNil(googleMapsString, "Google map string failed")
    }
    
    func testUrlEncode() {
        let stringToEncode = "stringToEncode"
        XCTAssertNotNil(stringToEncode, "Url Encode needs not nil string value")
        
        let encodedString  = mapLauncher.urlEncode(stringToEncode)
        XCTAssertNotNil(encodedString, "Encoded string failed")
    }
    
    func testGetMapApps() {
        XCTAssertNotNil(mapLauncher.getMapApps(), "Getting map apps failed")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
