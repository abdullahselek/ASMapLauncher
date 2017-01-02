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
    ASMapAppWaze = "Waze",
    ASMapAppMoovit = "Moovit"
    
    static let allValues = [ASMapAppAppleMaps, ASMapAppHEREMaps, ASMapAppGoogleMaps, ASMapAppYandexNavigator, ASMapAppCitymapper, ASMapAppNavigon, ASMapAppTheTransitApp, ASMapAppWaze, ASMapAppMoovit]
}

/**
  * Launcher class
 */
open class ASMapLauncher {
    
    /**
      * UIApplication used for deep linking
     */
    var application: UIApplicationProtocol = UIApplication.shared
    
    /**
      * Holds available map applications
     */
    fileprivate var availableMapApps: NSMutableArray! = NSMutableArray()
    
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
    fileprivate func getAvailableNavigationApps() {
        for type in ASMapApp.allValues {
            if isMapAppInstalled(type) {
                availableMapApps.add(type.rawValue)
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
    open func urlPrefixForMapApp(_ mapApp: ASMapApp) -> String {
        switch(mapApp) {
        case .ASMapAppHEREMaps:
            return "here-route:share.here.com"
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
        case .ASMapAppMoovit:
            return "moovit://"
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
    open func isMapAppInstalled(_ mapApp: ASMapApp) -> Bool {
        if mapApp == .ASMapAppAppleMaps {
            return true
        }
        
        let urlPrefix: String = urlPrefixForMapApp(mapApp)
        return application.canOpenURL(URL(string: urlPrefix)!)
    }

    /**
      * Launch navigation application with given app and directions
      *
      * @param mapApp ASMapApp
      * @param fromDirections ASMapPoint
      * @param toDirection ASMapPoint
     */
    open func launchMapApp(_ mapApp: ASMapApp, fromDirections: ASMapPoint!, toDirection: ASMapPoint!) -> Bool {
        if !isMapAppInstalled(mapApp) {
            return false
        }
        var url: String!
        switch(mapApp) {
        case .ASMapAppAppleMaps:
            url = NSString(format: "http://maps.apple.com/?saddr=%@&daddr=%@&z=14", googleMapsString(fromDirections), googleMapsString(toDirection)) as String
        case .ASMapAppHEREMaps:
            url = NSString(format: "here-route://%f,%f,%@/%f,%f,%@", fromDirections.location.coordinate.latitude, fromDirections.location.coordinate.longitude, fromDirections.name, toDirection.location.coordinate.latitude, toDirection.location.coordinate.longitude, toDirection.name) as String
        case .ASMapAppGoogleMaps:
            url = NSString(format: "comgooglemaps://?saddr=%@&daddr=%@", googleMapsString(fromDirections), googleMapsString(toDirection)) as String
        case .ASMapAppYandexNavigator:
            url = NSString(format: "yandexnavi://build_route_on_map?lat_to=%f&lon_to=%f&lat_from=%f&lon_from=%f",
                toDirection.location.coordinate.latitude, toDirection.location.coordinate.longitude, fromDirections.location.coordinate.latitude, fromDirections.location.coordinate.longitude) as String
        case .ASMapAppCitymapper:
            let params: NSMutableArray! = NSMutableArray(capacity: 10)
            if CLLocationCoordinate2DIsValid(fromDirections.location.coordinate) {
                params.add(NSString(format: "startcoord=%f,%f", fromDirections.location.coordinate.latitude, fromDirections.location.coordinate.longitude))
                if !fromDirections.name.isEmpty {
                    params.add(NSString(format: "startname=%@", urlEncode(fromDirections.name as NSString)))
                }
                if !fromDirections.address.isEmpty {
                    params.add(NSString(format: "startaddress=%@", urlEncode(fromDirections.address as NSString)))
                }
            }
            if CLLocationCoordinate2DIsValid(toDirection.location.coordinate) {
                params.add(NSString(format: "endcoord=%f,%f", toDirection.location.coordinate.latitude, toDirection.location.coordinate.longitude))
                if !toDirection.name.isEmpty {
                    params.add(NSString(format: "endname=%@", urlEncode(toDirection.name as NSString)))
                }
                if !toDirection.address.isEmpty {
                    params.add(NSString(format: "endaddress=%@", urlEncode(toDirection.address as NSString)))
                }
            }
            
            url = NSString(format: "citymapper://directions?%@", params.componentsJoined(by: "&")) as String
        case .ASMapAppNavigon:
            var name: String = "Destination"
            if !toDirection.name.isEmpty {
                name = toDirection.name
            }
            
            url = NSString(format: "navigon://coordinate/%@/%f/%f", urlEncode(name as NSString), toDirection.location.coordinate.longitude, toDirection.location.coordinate.latitude) as String
        case .ASMapAppTheTransitApp:
            let params = NSMutableArray(capacity: 2)
            if fromDirections != nil {
                params.add(NSString(format: "from=%f,%f", fromDirections.location.coordinate.latitude, fromDirections.location.coordinate.longitude))
            }
            if toDirection != nil {
                params.add(NSString(format: "to=%f,%f", toDirection.location.coordinate.latitude, toDirection.location.coordinate.longitude))
            }
            url = NSString(format: "transit://directions?%@", params.componentsJoined(by: "&")) as String
        case .ASMapAppWaze:
            url = NSString(format: "waze://?ll=%f,%f&navigate=yes", toDirection.location.coordinate.latitude, toDirection.location.coordinate.longitude) as String
        case .ASMapAppMoovit:
            url = NSString(format: "moovit://directions?dest_lat=%f&dest_lon=%f&dest_name%@=&orig_lat=%f&orig_lon=%f&orig_name=%@&auto_run=true&partner_id=%@", toDirection.location.coordinate.latitude, toDirection.location.coordinate.longitude, urlEncode(toDirection.name as NSString), fromDirections.location.coordinate.latitude, fromDirections.location.coordinate.longitude, urlEncode(fromDirections.name as NSString), Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "") as String
        }
        if #available(iOS 10.0, *) {
            application.open(URL(string: url)!, options: [:], completionHandler: nil)
            return true
        } else {
            let isOpened = application.openURL(URL(string: url)!)
            return isOpened
        }
    }
    
    /**
      * Prepares deep linking url with given point
      *
      * @param mapPoint ASMapPoint
      *
      * @return Deeplink url
     */
    func googleMapsString(_ mapPoint: ASMapPoint) -> NSString {
        if !CLLocationCoordinate2DIsValid(mapPoint.location.coordinate) {
            return ""
        }
        
        if !mapPoint.name.isEmpty {
            let encodedName = mapPoint.name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
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
    func urlEncode(_ name: NSString) -> NSString {
        return name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)! as NSString
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
open class ASMapPoint: NSObject {
    
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
    func openURL(_ url: URL) -> Bool
    
    /**
      * Checks if given url can be opened
     */
    func canOpenURL(_ url: URL) -> Bool
    
    /**
      * Open given url for iOS 10+
     */
    @available(iOS 10.0, *)
    func open(_ url: URL, options: [String : Any], completionHandler completion: ((Bool) -> Swift.Void)?)
}

/**
  * Extension for UIApplication
 */
extension UIApplication: UIApplicationProtocol {}
