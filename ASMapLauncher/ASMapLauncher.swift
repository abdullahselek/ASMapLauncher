//
//  ASMapLauncher.swift
//  ASMapLauncher
//
//  Created by Abdullah Selek on 06/06/15.
//  Copyright (c) 2015 Abdullah Selek. All rights reserved.
//

// The MIT License (MIT)

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation
import MapKit

enum ASMapApp : String {
    case ASMapAppAppleMaps = "Apple Maps",
    ASMapAppGoogleMaps = "Google Maps",
    ASMapAppYandexNavigator = "Yandex Navigator",
    ASMapAppCitymapper = "Citymapper",
    ASMapAppNavigon = "Navigon",
    ASMapAppTheTransitApp = "The Transit App",
    ASMapAppWaze = "Waze"
    
    static let allValues = [ASMapAppAppleMaps, ASMapAppGoogleMaps, ASMapAppYandexNavigator, ASMapAppCitymapper, ASMapAppNavigon, ASMapAppTheTransitApp, ASMapAppWaze]
}

class ASMapLauncher {
    
    private var availableMapApps: NSMutableArray!
    
    init() {
        getAvailableNavigationApps()
    }
    
    // MARK: Get Available Navigation Apps
    
    func getAvailableNavigationApps() {
        self.availableMapApps = NSMutableArray()
        for type in ASMapApp.allValues {
            if isMapAppInstalled(type) {
                self.availableMapApps.addObject(type.rawValue)
            }
        }
    }
    
    func urlPrefixForMapApp(mapApp: ASMapApp) -> String {
        switch(mapApp) {
        case .ASMapAppGoogleMaps:
            return "comgooglemaps://"
        case .ASMapAppYandexNavigator:
            return "yandexnavi://"
        case .ASMapAppCitymapper:
            return "citymapper://"
        case .ASMapAppNavigon:
            return "navigon://"
        case .ASMapAppTheTransitApp:
            return "transit://"
        case .ASMapAppWaze:
            return "waze://"
        default:
            return ""
        }
    }
    
    func isMapAppInstalled(mapApp: ASMapApp) -> Bool {
        if mapApp == .ASMapAppAppleMaps {
            return true
        }
        
        var urlPrefix: String = urlPrefixForMapApp(mapApp)
        if urlPrefix.isEmpty {
            return false
        }
        
        return UIApplication.sharedApplication().canOpenURL(NSURL(string: urlPrefix)!)
    }

    func launchMapApp(mapApp: ASMapApp, fromDirections: ASMapPoint!, toDirection: ASMapPoint!) -> Bool {
        if !isMapAppInstalled(mapApp) {
            return false
        }
        
        switch(mapApp) {
        case .ASMapAppAppleMaps:
            var url: String = NSString(format: "http://maps.apple.com/?saddr=%@&daddr=%@&z=14", googleMapsString(fromDirections), googleMapsString(toDirection)) as String
            return UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        case .ASMapAppGoogleMaps:
            var url: String = NSString(format: "comgooglemaps://?saddr=%@&daddr=%@", googleMapsString(fromDirections), googleMapsString(toDirection)) as String
            return UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        case .ASMapAppYandexNavigator:
            var url: String = NSString(format: "yandexnavi://build_route_on_map?lat_to=%f&lon_to=%f&lat_from=%f&lon_from=%f",
                toDirection.location.coordinate.latitude, toDirection.location.coordinate.longitude, fromDirections.location.coordinate.latitude, fromDirections.location.coordinate.longitude) as String
            return UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        case .ASMapAppCitymapper:
            var params: NSMutableArray! = NSMutableArray(capacity: 10)
            if CLLocationCoordinate2DIsValid(fromDirections.location.coordinate) {
                params.addObject(NSString(format: "startcoord=%f,%f", fromDirections.location.coordinate.latitude, fromDirections.location.coordinate.longitude))
                if !fromDirections.name.isEmpty {
                    params.addObject(NSString(format: "startname=%@", urlEncode(fromDirections.name)))
                }
                if !fromDirections.address.isEmpty {
                    params.addObject(NSString(format: "startaddress=%@", urlEncode(fromDirections.address)))
                }
            }
            if CLLocationCoordinate2DIsValid(toDirection.location.coordinate) {
                params.addObject(NSString(format: "endcoord=%f,%f", toDirection.location.coordinate.latitude, toDirection.location.coordinate.longitude))
                if !toDirection.name.isEmpty {
                    params.addObject(NSString(format: "endname=%@", urlEncode(toDirection.name)))
                }
                if !toDirection.address.isEmpty {
                    params.addObject(NSString(format: "endaddress=%@", urlEncode(toDirection.address)))
                }
            }
            
            var url: String = NSString(format: "citymapper://directions?%@", params.componentsJoinedByString("&")) as String
            return UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        case .ASMapAppNavigon:
            var name: String = "Destination"
            if !toDirection.name.isEmpty {
                name = toDirection.name
            }
            
            var url: String = NSString(format: "navigon://coordinate/%@/%f/%f", urlEncode(name), toDirection.location.coordinate.longitude, toDirection.location.coordinate.latitude) as String
            return UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        case .ASMapAppTheTransitApp:
            var params = NSMutableArray(capacity: 2)
            if fromDirections != nil {
                params.addObject(NSString(format: "from=%f,%f", fromDirections.location.coordinate.latitude, fromDirections.location.coordinate.longitude))
            }
            if toDirection != nil {
                params.addObject(NSString(format: "to=%f,%f", toDirection.location.coordinate.latitude, toDirection.location.coordinate.longitude))
            }
            var url: String = NSString(format: "transit://directions?%@", params.componentsJoinedByString("&")) as String
            return UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        case .ASMapAppWaze:
            var url: String = NSString(format: "waze://?ll=%f,%f&navigate=yes", toDirection.location.coordinate.latitude, toDirection.location.coordinate.longitude) as String
            return UIApplication.sharedApplication().openURL(NSURL(string: url)!)
        default:
            return false
        }
    }
    
    func googleMapsString(mapPoint: ASMapPoint) -> NSString {
        if !CLLocationCoordinate2DIsValid(mapPoint.location.coordinate) {
            return ""
        }
        
        if !mapPoint.name.isEmpty {
            var encodedName = mapPoint.name.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            return NSString(format: "%f,%f+(%@)", mapPoint.location.coordinate.latitude, mapPoint.location.coordinate.longitude, encodedName!)
        }
        
        return NSString(format: "%f,%f", mapPoint.location.coordinate.latitude, mapPoint.location.coordinate.longitude)
    }
    
    func urlEncode(name: NSString) -> NSString {
        return name.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }
    
    // MARK: Map Apps Getter
    
    func getMapApps() -> NSMutableArray! {
        if self.availableMapApps == nil {
            self.availableMapApps = NSMutableArray()
        }
        
        return self.availableMapApps
    }
    
}

class ASMapPoint: NSObject {
    
    var location: CLLocation!
    var name: String!
    var address: String!
    
    init(location: CLLocation!, name: String!, address: String!) {
        self.location = location
        self.name = name
        self.address = address
        
        super.init()
    }
    
}
