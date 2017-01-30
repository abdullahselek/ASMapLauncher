//
//  ASMapLauncherTests.swift
//  ASMapLauncherTests
//
//  Created by Abdullah Selek on 06/06/15.
//  Copyright (c) 2015 Abdullah Selek. All rights reserved.
//

import UIKit
import MapKit
import Quick
import Nimble

class ASMapLauncherTests: QuickSpec {
    
    override func spec() {
        describe("Map Launcher") {
            var mapLauncher: ASMapLauncher!
            beforeEach {
                mapLauncher = ASMapLauncher()
            }
            context("Check initialization") {
                it("if success") {
                    expect(mapLauncher).notTo(beNil())
                }
            }
            context("Check url prefix") {
                it("for Apple Maps") {
                    let mapAppType: MapApp! = .apple
                    expect(mapAppType).notTo(beNil())
                    let urlPrefix = mapLauncher.urlPrefixForMapApp(mapAppType)
                    expect(urlPrefix).notTo(beNil())
                    expect(urlPrefix).to(equal(""))
                }
                it("for HERE Maps") {
                    let mapAppType: MapApp! = .here
                    expect(mapAppType).notTo(beNil())
                    let urlPrefix = mapLauncher.urlPrefixForMapApp(mapAppType)
                    expect(urlPrefix).notTo(beNil())
                    expect(urlPrefix).to(equal("here-route:share.here.com"))
                }
                it("for Google Maps") {
                    let mapAppType: MapApp! = .google
                    expect(mapAppType).notTo(beNil())
                    let urlPrefix = mapLauncher.urlPrefixForMapApp(mapAppType)
                    expect(urlPrefix).notTo(beNil())
                    expect(urlPrefix).to(equal("comgooglemaps://"))
                }
                it("for Yandex Navigator") {
                    let mapAppType: MapApp! = .yandex
                    expect(mapAppType).notTo(beNil())
                    let urlPrefix = mapLauncher.urlPrefixForMapApp(mapAppType)
                    expect(urlPrefix).notTo(beNil())
                    expect(urlPrefix).to(equal("yandexnavi://"))
                }
                it("for CityMapper") {
                    let mapAppType: MapApp! = .citymapper
                    expect(mapAppType).notTo(beNil())
                    let urlPrefix = mapLauncher.urlPrefixForMapApp(mapAppType)
                    expect(urlPrefix).notTo(beNil())
                    expect(urlPrefix).to(equal("citymapper://"))
                }
                it("for Navigon") {
                    let mapAppType: MapApp! = .navigon
                    expect(mapAppType).notTo(beNil())
                    let urlPrefix = mapLauncher.urlPrefixForMapApp(mapAppType)
                    expect(urlPrefix).notTo(beNil())
                    expect(urlPrefix).to(equal("navigon://"))
                }
                it("for Transit") {
                    let mapAppType: MapApp! = .transit
                    expect(mapAppType).notTo(beNil())
                    let urlPrefix = mapLauncher.urlPrefixForMapApp(mapAppType)
                    expect(urlPrefix).notTo(beNil())
                    expect(urlPrefix).to(equal("transit://"))
                }
                it("for Wazer") {
                    let mapAppType: MapApp! = .waze
                    expect(mapAppType).notTo(beNil())
                    let urlPrefix = mapLauncher.urlPrefixForMapApp(mapAppType)
                    expect(urlPrefix).notTo(beNil())
                    expect(urlPrefix).to(equal("waze://"))
                }
                it("for Moovit") {
                    let mapAppType: MapApp! = .moovit
                    expect(mapAppType).notTo(beNil())
                    let urlPrefix = mapLauncher.urlPrefixForMapApp(mapAppType)
                    expect(urlPrefix).notTo(beNil())
                    expect(urlPrefix).to(equal("moovit://"))
                }
            }
            context("Check if Map installed") {
                it("for Apple Maps") {
                    expect(mapLauncher.isMapAppInstalled(.apple)).to(equal(true))
                }
                it("for unavailable map") {
                    expect(mapLauncher.isMapAppInstalled(.here)).to(equal(false))
                }
            }
            context("Check prepared string") {
                it("for Google Maps when all params are valid") {
                    let mapPoint = MapPoint(location: CLLocation(latitude: 10.0, longitude: 10.0), name: "TestName", address: "TestAddress")
                    let preparedString = mapLauncher.googleMapsString(mapPoint)
                    expect(preparedString).to(equal(("10.000000,10.000000+(TestName)")))
                }
                it("for Google Maps when location is not valid") {
                    let mapPoint = MapPoint(location: CLLocation(latitude: -9999.99, longitude: -9999.00), name: "TestName", address: "TestAddress")
                    let preparedString = mapLauncher.googleMapsString(mapPoint)
                    expect(preparedString).to(equal(("")))
                }
                it("for Google Maps when name is empty") {
                    let mapPoint = MapPoint(location: CLLocation(latitude: 10.0, longitude: 10.0), name: "", address: "TestAddress")
                    let preparedString = mapLauncher.googleMapsString(mapPoint)
                    expect(preparedString).to(equal(("10.000000,10.000000")))
                }
            }
            context("Check url encode") {
                it("for simple url") {
                    let encodedUrl = mapLauncher.urlEncode("http://github.com/abdullahselek")
                    expect(encodedUrl).to(equal("http://github.com/abdullahselek"))
                }
            }
            context("Check available maps") {
                it("for Simulator") {
                    let apps = mapLauncher.getMapApps()
                    expect(apps).notTo(beNil())
                    expect(apps).to(haveCount(1))
                }
            }
            context("Check launch map app") {
                var fromPoint: MapPoint!
                var toPoint: MapPoint!
                beforeEach {
                    fromPoint = MapPoint(location: CLLocation(latitude: 10.0, longitude: 10.0), name: "FromName", address: "fromAddress")
                    toPoint = MapPoint(location: CLLocation(latitude: 20.0, longitude: 20.0), name: "ToName", address: "ToAddress")
                }
                it("for Apple Maps") {
                    let mapApp: MapApp = .apple
                    expect(mapLauncher.launchMapApp(mapApp, fromDirections: fromPoint, toDirection: toPoint)).to(equal(true))
                }
                it("for HERE Maps") {
                    mapLauncher.application = MockApplication()
                    let mapApp: MapApp = .here
                    expect(mapLauncher.isMapAppInstalled(mapApp)).to(beTrue())
                    expect(mapLauncher.launchMapApp(mapApp, fromDirections: fromPoint, toDirection: toPoint)).to(equal(true))
                }
                it("for Google Maps") {
                    mapLauncher.application = MockApplication()
                    let mapApp: MapApp = .google
                    expect(mapLauncher.isMapAppInstalled(mapApp)).to(beTrue())
                    expect(mapLauncher.launchMapApp(mapApp, fromDirections: fromPoint, toDirection: toPoint)).to(equal(true))
                }
                it("for Yandex Navigator") {
                    mapLauncher.application = MockApplication()
                    let mapApp: MapApp = .yandex
                    expect(mapLauncher.isMapAppInstalled(mapApp)).to(beTrue())
                    expect(mapLauncher.launchMapApp(mapApp, fromDirections: fromPoint, toDirection: toPoint)).to(equal(true))
                }
                it("for City Mapper") {
                    mapLauncher.application = MockApplication()
                    let mapApp: MapApp = .citymapper
                    expect(mapLauncher.isMapAppInstalled(mapApp)).to(beTrue())
                    expect(mapLauncher.launchMapApp(mapApp, fromDirections: fromPoint, toDirection: toPoint)).to(equal(true))
                }
                it("for Navigon") {
                    mapLauncher.application = MockApplication()
                    let mapApp: MapApp = .navigon
                    expect(mapLauncher.isMapAppInstalled(mapApp)).to(beTrue())
                    expect(mapLauncher.launchMapApp(mapApp, fromDirections: fromPoint, toDirection: toPoint)).to(equal(true))
                }
                it("for Transit") {
                    mapLauncher.application = MockApplication()
                    let mapApp: MapApp = .transit
                    expect(mapLauncher.isMapAppInstalled(mapApp)).to(beTrue())
                    expect(mapLauncher.launchMapApp(mapApp, fromDirections: fromPoint, toDirection: toPoint)).to(equal(true))
                }
                it("for Waze") {
                    mapLauncher.application = MockApplication()
                    let mapApp: MapApp = .waze
                    expect(mapLauncher.isMapAppInstalled(mapApp)).to(beTrue())
                    expect(mapLauncher.launchMapApp(mapApp, fromDirections: fromPoint, toDirection: toPoint)).to(equal(true))
                }
                it("for Moovit") {
                    mapLauncher.application = MockApplication()
                    let mapApp: MapApp = .moovit
                    expect(mapLauncher.isMapAppInstalled(mapApp)).to(beTrue())
                    expect(mapLauncher.launchMapApp(mapApp, fromDirections: fromPoint, toDirection: toPoint)).to(equal(true))
                }
                it("for HERE Maps when not installed") {
                    let mapApp: MapApp = .here
                    expect(mapLauncher.isMapAppInstalled(mapApp)).to(beFalse())
                    expect(mapLauncher.launchMapApp(mapApp, fromDirections: fromPoint, toDirection: toPoint)).to(equal(false))
                }
            }
        }
    }
    
    class MockApplication: UIApplicationProtocol {
        /**
          * Open given url for iOS 10+
         */
        internal func open(_ url: URL, options: [String : Any], completionHandler completion: ((Bool) -> Void)?) {
            
        }

        func openURL(_ url: URL) -> Bool {
            return true
        }
        
        func canOpenURL(_ url: URL) -> Bool {
            return true
        }
    }
    
}
