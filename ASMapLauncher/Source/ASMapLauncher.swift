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

/**
  * Supported map applications
 */
public enum ASMapApp : String {
    case ASMapAppAppleMaps = "Apple Maps",
    ASMapAppHEREMaps = "HERE Maps",
    ASMapAppGoogleMaps = "Google Maps",
    ASMapAppYandexNavigator = "Yandex Navigator",
    ASMapAppCitymapper = "Citymapper",
    ASMapAppNavigon = "Navigon",
    ASMapAppTheTransitApp = "The Transit App",
    ASMapAppWaze = "Waze"
    
    static let allValues = [ASMapAppAppleMaps, ASMapAppHEREMaps, ASMapAppGoogleMaps, ASMapAppYandexNavigator, ASMapAppCitymapper, ASMapAppNavigon, ASMapAppTheTransitApp, ASMapAppWaze]
}

/**
  * Launcher class
 */
public class ASMapLauncher {
    
    /**
      * UIApplication used for deep linking
     */
    var application: UIApplicationProtocol = UIApplication.sharedApplication()
    
    /**
      * Holds available map applications
     */
    private var availableMapApps: NSMutableArray! = NSMutableArray()
    
    /**
      * Initiliaze Map Launcher
     */
    public init() {
        getAvailableNavigationApps()
    }
    
    // MARK: Get Available Navigation Apps
    
    /**
      * Prepares available navigation apps installed on device
     */
    private func getAvailableNavigationApps() {
        for type in ASMapApp.allValues {
            if isMapAppInstalled(type) {
                availableMapApps.addObject(type.rawValue)
            }
        }
    }
    
    /**
      * Prepares url scheme prefix used to open app with given app type
      *
      * @param mapApp ASMapApp enum
      *
      * @return Url Prefix
     */
    public func urlPrefixForMapApp(mapApp: ASMapApp) -> String {
        switch(mapApp) {
        case .ASMapAppHEREMaps:
            return "here-route://"
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
    
    /**
      * Checks if app installed with given app type
      *
      * @param mapApp ASMapApp
      *
      * @return Bool installed or not
     */
    public func isMapAppInstalled(mapApp: ASMapApp) -> Bool {
        if mapApp == .ASMapAppAppleMaps {
            return true
        }
        
        let urlPrefix: String = urlPrefixForMapApp(mapApp)
        return application.canOpenURL(NSURL(string: urlPrefix)!)
    }

    /**
      * Launch navigation application with given app and directions
      *
      * @param mapApp ASMapApp
      * @param fromDirections ASMapPoint
      * @param toDirection ASMapPoint
      *
      * @return Launched or not
     */
    public func launchMapApp(mapApp: ASMapApp, fromDirections: ASMapPoint!, toDirection: ASMapPoint!) -> Bool {
        if !isMapAppInstalled(mapApp) {
            return false
        }
        
        switch(mapApp) {
        case .ASMapAppAppleMaps:
            let url: String = NSString(format: "http://maps.apple.com/?saddr=%@&daddr=%@&z=14", googleMapsString(fromDirections), googleMapsString(toDirection)) as String
            return application.openURL(NSURL(string: url)!)
        case .ASMapAppHEREMaps:
            let url: String = NSString(format: "here-route://%f,%f,%@/%f,%f,%@", fromDirections.location.coordinate.latitude, fromDirections.location.coordinate.longitude, fromDirections.name, toDirection.location.coordinate.latitude, toDirection.location.coordinate.longitude, toDirection.name) as String
            return application.openURL(NSURL(string: url)!)
        case .ASMapAppGoogleMaps:
            let url: String = NSString(format: "comgooglemaps://?saddr=%@&daddr=%@", googleMapsString(fromDirections), googleMapsString(toDirection)) as String
            return application.openURL(NSURL(string: url)!)
        case .ASMapAppYandexNavigator:
            let url: String = NSString(format: "yandexnavi://build_route_on_map?lat_to=%f&lon_to=%f&lat_from=%f&lon_from=%f",
                toDirection.location.coordinate.latitude, toDirection.location.coordinate.longitude, fromDirections.location.coordinate.latitude, fromDirections.location.coordinate.longitude) as String
            return application.openURL(NSURL(string: url)!)
        case .ASMapAppCitymapper:
            let params: NSMutableArray! = NSMutableArray(capacity: 10)
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
            
            let url: String = NSString(format: "citymapper://directions?%@", params.componentsJoinedByString("&")) as String
            return application.openURL(NSURL(string: url)!)
        case .ASMapAppNavigon:
            var name: String = "Destination"
            if !toDirection.name.isEmpty {
                name = toDirection.name
            }
            
            let url: String = NSString(format: "navigon://coordinate/%@/%f/%f", urlEncode(name), toDirection.location.coordinate.longitude, toDirection.location.coordinate.latitude) as String
            return application.openURL(NSURL(string: url)!)
        case .ASMapAppTheTransitApp:
            let params = NSMutableArray(capacity: 2)
            if fromDirections != nil {
                params.addObject(NSString(format: "from=%f,%f", fromDirections.location.coordinate.latitude, fromDirections.location.coordinate.longitude))
            }
            if toDirection != nil {
                params.addObject(NSString(format: "to=%f,%f", toDirection.location.coordinate.latitude, toDirection.location.coordinate.longitude))
            }
            let url: String = NSString(format: "transit://directions?%@", params.componentsJoinedByString("&")) as String
            return application.openURL(NSURL(string: url)!)
        case .ASMapAppWaze:
            let url: String = NSString(format: "waze://?ll=%f,%f&navigate=yes", toDirection.location.coordinate.latitude, toDirection.location.coordinate.longitude) as String
            return application.openURL(NSURL(string: url)!)
        }
    }
    
    /**
      * Prepares deep linking url with given point
      *
      * @param mapPoint ASMapPoint
      *
      * @return Deeplink url
     */
    func googleMapsString(mapPoint: ASMapPoint) -> NSString {
        if !CLLocationCoordinate2DIsValid(mapPoint.location.coordinate) {
            return ""
        }
        
        if !mapPoint.name.isEmpty {
            let encodedName = mapPoint.name.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            return NSString(format: "%f,%f+(%@)", mapPoint.location.coordinate.latitude, mapPoint.location.coordinate.longitude, encodedName!)
        }
        
        return NSString(format: "%f,%f", mapPoint.location.coordinate.latitude, mapPoint.location.coordinate.longitude)
    }
    
    /**
      * Encodes given string
      *
      * @param name NSString
      *
      * @return Encoded name
     */
    func urlEncode(name: NSString) -> NSString {
        return name.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }
    
    // MARK: Map Apps Getter
    
    /**
      * Returns available navigation apps
      *
      * @return Map Apps
     */
    func getMapApps() -> NSMutableArray! {
        return availableMapApps
    }
    
}

/**
  * Point class used for deep linking
 */
public class ASMapPoint: NSObject {
    
    /**
      * Location value for navigation
     */
    var location: CLLocation!
    
    /**
      * Place name
     */
    var name: String!
    
    /**
      * Place address
     */
    var address: String!
    
    /**
      * Initialize point object with given parameters
      *
      * @param location Location belongs to place
      * @param name Name belongs to place
      * @param address Address belongs to place
     */
    public init(location: CLLocation!, name: String!, address: String!) {
        self.location = location
        self.name = name
        self.address = address
        
        super.init()
    }
    
}

/**
  * Protocol that used for UIApplication
 */
protocol UIApplicationProtocol {
    
    /**
      * Open given url
     */
    func openURL(url: NSURL) -> Bool
    
    /**
      * Checks if given url can be opened
     */
    func canOpenURL(url: NSURL) -> Bool
}

/**
  * Extension for UIApplication
 */
extension UIApplication: UIApplicationProtocol {}
