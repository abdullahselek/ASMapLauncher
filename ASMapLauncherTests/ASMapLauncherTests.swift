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
        describe("ASMapLauncher Tests") {
            var mapLauncher: ASMapLauncher!

            beforeEach {
                mapLauncher = ASMapLauncher()
            }

            context(".init()") {
                it("should return a map launcher") {
                    expect(mapLauncher).notTo(beNil())
                }
            }

            describe(".urlPrefixForMapApp(_:)") {
                context("for Apple Maps") {
                    var urlPrefix: String!

                    beforeEach {
                        urlPrefix = mapLauncher.urlPrefixForMapApp(.apple)
                    }

                    it("should return empty prefix") {
                        expect(urlPrefix).to(equal(""))
                    }
                }

                context("for HERE Maps") {
                    var urlPrefix: String!

                    beforeEach {
                        urlPrefix = mapLauncher.urlPrefixForMapApp(.here)
                    }

                    it("should return a valid prefix") {
                        expect(urlPrefix).to(equal("here-route://"))
                    }
                }

                context("for Google Maps") {
                    var urlPrefix: String!

                    beforeEach {
                        urlPrefix = mapLauncher.urlPrefixForMapApp(.google)
                    }

                    it("should return a valid prefix") {
                        expect(urlPrefix).to(equal("comgooglemaps://"))
                    }
                }

                context("for Yandex Navigator") {
                    var urlPrefix: String!

                    beforeEach {
                        urlPrefix = mapLauncher.urlPrefixForMapApp(.yandex)
                    }

                    it("should return a valid prefix") {
                        expect(urlPrefix).to(equal("yandexnavi://"))
                    }
                }

                context("for CityMapper") {
                    var urlPrefix: String!

                    beforeEach {
                        urlPrefix = mapLauncher.urlPrefixForMapApp(.citymapper)
                    }

                    it("should return a valid prefix") {
                        expect(urlPrefix).to(equal("citymapper://"))
                    }
                }

                context("for Navigon") {
                    var urlPrefix: String!

                    beforeEach {
                        urlPrefix = mapLauncher.urlPrefixForMapApp(.navigon)
                    }

                    it("should return a valid prefix") {
                        expect(urlPrefix).to(equal("navigon://"))
                    }
                }

                context("for Transit") {
                    var urlPrefix: String!

                    beforeEach {
                        urlPrefix = mapLauncher.urlPrefixForMapApp(.transit)
                    }

                    it("should return a valid prefix") {
                        expect(urlPrefix).to(equal("transit://"))
                    }
                }

                context("for Waze") {
                    var urlPrefix: String!

                    beforeEach {
                        urlPrefix = mapLauncher.urlPrefixForMapApp(.waze)
                    }

                    it("should return a valid prefix") {
                        expect(urlPrefix).to(equal("waze://"))
                    }
                }

                context("for Moovit") {
                    var urlPrefix: String!

                    beforeEach {
                        urlPrefix = mapLauncher.urlPrefixForMapApp(.moovit)
                    }

                    it("should return a valid prefix") {
                        expect(urlPrefix).to(equal("moovit://"))
                    }
                }
            }

            describe(".isMapAppInstalled(_:)") {
                context("for Apple Maps") {
                    it("it should return true") {
                        expect(mapLauncher.isMapAppInstalled(.apple)).to(equal(true))
                    }
                }

                context("for HERE Maps") {
                    it("it should return true") {
                        expect(mapLauncher.isMapAppInstalled(.here)).to(equal(false))
                    }
                }
            }

            describe(".googleMapsString(_:)") {
                context("when all params are filled") {
                    var deeplinkingString: String!

                    beforeEach {
                        let mapPoint = MapPoint(location: CLLocation(latitude: 10.0, longitude: 10.0),
                                                name: "TestName",
                                                address: "TestAddress")
                        deeplinkingString = mapLauncher.googleMapsString(mapPoint) as String
                    }

                    it("should return a non nil string") {
                        expect(deeplinkingString).to(equal(("10.000000,10.000000+(TestName)")))
                    }
                }

                context("when location is not valid") {
                    var deeplinkingString: String!

                    beforeEach {
                        let mapPoint = MapPoint(location: CLLocation(latitude: -9999.99, longitude: -9999.00),
                                                name: "TestName",
                                                address: "TestAddress")
                        deeplinkingString = mapLauncher.googleMapsString(mapPoint) as String
                    }

                    it("should return a empty string") {
                        expect(deeplinkingString).to(equal(("")))
                    }
                }

                context("when name is empty") {
                    var deeplinkingString: String!

                    beforeEach {
                        let mapPoint = MapPoint(location: CLLocation(latitude: 10.0, longitude: 10.0),
                                                name: "",
                                                address: "TestAddress")
                        deeplinkingString = mapLauncher.googleMapsString(mapPoint) as String
                    }

                    it("should return a string containts lat long") {
                        expect(deeplinkingString).to(equal(("10.000000,10.000000")))
                    }
                }
            }

            context(".urlEncode(_:)") {
                var encodedUrl: String!

                beforeEach {
                    encodedUrl = mapLauncher.urlEncode("http://github.com/abdullahselek") as String
                }

                it("should return a valid url string") {
                    expect(encodedUrl).to(equal("http://github.com/abdullahselek"))
                }
            }

            context(".getMapApps()") {
                var apps = [String]()

                beforeEach {
                    apps = mapLauncher.getMapApps()
                }

                it("should return an array") {
                    expect(apps).to(haveCount(1))
                }
            }

            describe(".launchMapApp(_:fromDirections:toDirection:)") {
                var fromPoint: MapPoint!
                var toPoint: MapPoint!
                var isOpened = false

                beforeEach {
                    fromPoint = MapPoint(location: CLLocation(latitude: 10.0, longitude: 10.0), name: "FromName", address: "fromAddress")
                    toPoint = MapPoint(location: CLLocation(latitude: 20.0, longitude: 20.0), name: "ToName", address: "ToAddress")
                    isOpened = false
                }

                context("for Apple Maps") {
                    beforeEach {
                        isOpened = mapLauncher.launchMapApp(.apple, fromDirections: fromPoint, toDirection: toPoint)
                    }

                    it("should launch given map app") {
                        expect(isOpened).to(equal(true))
                    }
                }

                context("for HERE Maps") {
                    beforeEach {
                        mapLauncher.application = ApplicationFake(openUrl: true)
                        isOpened = mapLauncher.launchMapApp(.here, fromDirections: fromPoint, toDirection: toPoint)
                    }

                    it("should launch given map app") {
                        expect(isOpened).to(equal(true))
                    }
                }

                context("for Google Maps") {
                    beforeEach {
                        mapLauncher.application = ApplicationFake(openUrl: true)
                        isOpened = mapLauncher.launchMapApp(.google, fromDirections: fromPoint, toDirection: toPoint)
                    }

                    it("should launch given map app") {
                        expect(isOpened).to(equal(true))
                    }
                }

                context("for Yandex Navigator") {
                    beforeEach {
                        mapLauncher.application = ApplicationFake(openUrl: true)
                        isOpened = mapLauncher.launchMapApp(.yandex, fromDirections: fromPoint, toDirection: toPoint)
                    }

                    it("should launch given map app") {
                        expect(isOpened).to(equal(true))
                    }
                }

                context("for CityMapper") {
                    beforeEach {
                        mapLauncher.application = ApplicationFake(openUrl: true)
                        isOpened = mapLauncher.launchMapApp(.citymapper, fromDirections: fromPoint, toDirection: toPoint)
                    }

                    it("should launch given map app") {
                        expect(isOpened).to(equal(true))
                    }
                }

                context("for Navigon") {
                    beforeEach {
                        mapLauncher.application = ApplicationFake(openUrl: true)
                        isOpened = mapLauncher.launchMapApp(.navigon, fromDirections: fromPoint, toDirection: toPoint)
                    }

                    it("should launch given map app") {
                        expect(isOpened).to(equal(true))
                    }
                }

                context("for Transit") {
                    beforeEach {
                        mapLauncher.application = ApplicationFake(openUrl: true)
                        isOpened = mapLauncher.launchMapApp(.transit, fromDirections: fromPoint, toDirection: toPoint)
                    }

                    it("should launch given map app") {
                        expect(isOpened).to(equal(true))
                    }
                }

                context("for Waze") {
                    beforeEach {
                        mapLauncher.application = ApplicationFake(openUrl: true)
                        isOpened = mapLauncher.launchMapApp(.waze, fromDirections: fromPoint, toDirection: toPoint)
                    }

                    it("should launch given map app") {
                        expect(isOpened).to(equal(true))
                    }
                }

                context("for Moovit") {
                    beforeEach {
                        mapLauncher.application = ApplicationFake(openUrl: true)
                        isOpened = mapLauncher.launchMapApp(.moovit, fromDirections: fromPoint, toDirection: toPoint)
                    }

                    it("should launch given map app") {
                        expect(isOpened).to(equal(true))
                    }
                }

                context("for HERE Maps when app is not installed") {
                    beforeEach {
                        let application = ApplicationFake(openUrl: false)
                        mapLauncher.application = application
                        isOpened = mapLauncher.launchMapApp(.waze, fromDirections: fromPoint, toDirection: toPoint)
                    }

                    it("shouldn't launch given map app") {
                        expect(isOpened).to(equal(false))
                    }
                }
            }
        }
    }

}

class ApplicationFake: UIApplicationProtocol {
    
    var openUrl = true

    init(openUrl: Bool) {
        self.openUrl = openUrl
    }
    
    func openUrl(_ url: URL) -> Bool {
        return openUrl
    }
    
    func canOpenUrl(_ url: URL) -> Bool {
        return openUrl
    }

    /**
     * Open given url for iOS 10+
     */
    internal func openURL(_ url: URL,
                          options: [UIApplication.OpenExternalURLOptionsKey: Any],
                          completionHandler completion: ((Bool) -> Void)?) {

    }

}
