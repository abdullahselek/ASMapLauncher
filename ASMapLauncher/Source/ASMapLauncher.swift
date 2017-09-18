//
//  ASMapLauncher.swift
//  ASMapLauncher
//
//  Copyright (c) 2015 Abdullah Selek. All rights reserved.
//
//  The MIT License (MIT)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation
import MapKit

/**
  Supported map applications
 */
public enum MapApp : String {
    case apple = "Apple Maps",
    here = "HERE Maps",
    google = "Google Maps",
    yandex = "Yandex Navigator",
    citymapper = "Citymapper",
    navigon = "Navigon",
    transit = "The Transit App",
    waze = "Waze",
    moovit = "Moovit"

    static let allValues = [apple, here, google, yandex, citymapper, navigon, transit, waze, moovit]
}

/**
  Launcher class
 */
open class ASMapLauncher {
    
    /**
      UIApplication used for deep linking
     */
    open var application: UIApplicationProtocol = UIApplication.shared
    
    /**
      Holds available map applications
     */
    private var availableMapApps = [String]()
    
    /**
      Initiliaze Map Launcher
     */
    public init() {
        getAvailableNavigationApps()
    }
    
    // MARK: Get Available Navigation Apps
    
    /**
      Prepares available navigation apps installed on device
     */
    internal func getAvailableNavigationApps() {
        for type in MapApp.allValues {
            if isMapAppInstalled(type) {
                availableMapApps.append(type.rawValue)
            }
        }
    }
    
    /**
      Prepares url scheme prefix used to open app with given app type
      - parameter mapApp: MapApp type
      - returns: Url Prefix
     */
    internal func urlPrefixForMapApp(_ mapApp: MapApp) -> String {
        switch(mapApp) {
        case .here:
            return "here-route://"
        case .google:
            return "comgooglemaps://"
        case .yandex:
            return "yandexnavi://"
        case .citymapper:
            return "citymapper://"
        case .navigon:
            return "navigon://"
        case .transit:
            return "transit://"
        case .waze:
            return "waze://"
        case .moovit:
            return "moovit://"
        default:
            return ""
        }
    }
    
    /**
      Checks if app installed with given app type
      - parameter mapApp: MapApp
      - returns: Bool installed or not
     */
    open func isMapAppInstalled(_ mapApp: MapApp) -> Bool {
        if mapApp == .apple {
            return true
        }
        
        let urlPrefix: String = urlPrefixForMapApp(mapApp)
        guard let url = URL(string: urlPrefix) else {
            return false
        }
        return application.canOpenURL(url)
    }

    /**
      Launch navigation application with given app and directions
      - parameter mapApp: MapApp
      - parameter fromDirections: MapPoint
      - parameter toDirection: MapPoint
     */
    open func launchMapApp(_ mapApp: MapApp, fromDirections: MapPoint!, toDirection: MapPoint!) -> Bool {
        if !isMapAppInstalled(mapApp) {
            return false
        }
        var urlString = ""
        switch(mapApp) {
        case .apple:
            urlString = String(format: "http://maps.apple.com/?saddr=%@&daddr=%@&z=14",
                                 googleMapsString(fromDirections),
                                 googleMapsString(toDirection))
        case .here:
            if #available(iOS 9.0, *) {
                urlString = String(format: "https://share.here.com/r/%f,%f,%@/%f,%f,%@",
                               fromDirections.location.coordinate.latitude,
                               fromDirections.location.coordinate.longitude,
                               fromDirections.name,
                               toDirection.location.coordinate.latitude,
                               toDirection.location.coordinate.longitude,
                               toDirection.name)
            } else {
                urlString = String(format: "here-route://%f,%f,%@/%f,%f,%@",
                               fromDirections.location.coordinate.latitude,
                               fromDirections.location.coordinate.longitude,
                               fromDirections.name,
                               toDirection.location.coordinate.latitude,
                               toDirection.location.coordinate.longitude,
                               toDirection.name)
            }
        case .google:
            urlString = String(format: "comgooglemaps://?saddr=%@&daddr=%@",
                           googleMapsString(fromDirections),
                           googleMapsString(toDirection))
        case .yandex:
            urlString = String(format: "yandexnavi://build_route_on_map?lat_to=%f&lon_to=%f&lat_from=%f&lon_from=%f",
                           toDirection.location.coordinate.latitude,
                           toDirection.location.coordinate.longitude,
                           fromDirections.location.coordinate.latitude,
                           fromDirections.location.coordinate.longitude)
        case .citymapper:
            let params: NSMutableArray! = NSMutableArray(capacity: 10)
            if CLLocationCoordinate2DIsValid(fromDirections.location.coordinate) {
                params.add(String(format: "startcoord=%f,%f",
                                    fromDirections.location.coordinate.latitude,
                                    fromDirections.location.coordinate.longitude))
                if !fromDirections.name.isEmpty {
                    params.add(String(format: "startname=%@", urlEncode(fromDirections.name)))
                }
                if !fromDirections.address.isEmpty {
                    params.add(String(format: "startaddress=%@", urlEncode(fromDirections.address)))
                }
            }
            if CLLocationCoordinate2DIsValid(toDirection.location.coordinate) {
                params.add(String(format: "endcoord=%f,%f",
                                    toDirection.location.coordinate.latitude,
                                    toDirection.location.coordinate.longitude))
                if !toDirection.name.isEmpty {
                    params.add(String(format: "endname=%@", urlEncode(toDirection.name)))
                }
                if !toDirection.address.isEmpty {
                    params.add(String(format: "endaddress=%@", urlEncode(toDirection.address)))
                }
            }
            
            urlString = String(format: "citymapper://directions?%@", params.componentsJoined(by: "&"))
        case .navigon:
            var name: String = "Destination"
            if !toDirection.name.isEmpty {
                name = toDirection.name
            }
            
            urlString = String(format: "navigon://coordinate/%@/%f/%f",
                           urlEncode(name),
                           toDirection.location.coordinate.longitude,
                           toDirection.location.coordinate.latitude)
        case .transit:
            let params = NSMutableArray(capacity: 2)
            if fromDirections != nil {
                params.add(String(format: "from=%f,%f",
                                    fromDirections.location.coordinate.latitude,
                                    fromDirections.location.coordinate.longitude))
            }
            if toDirection != nil {
                params.add(String(format: "to=%f,%f",
                                    toDirection.location.coordinate.latitude,
                                    toDirection.location.coordinate.longitude))
            }
            urlString = String(format: "transit://directions?%@", params.componentsJoined(by: "&"))
        case .waze:
            urlString = String(format: "waze://?ll=%f,%f&navigate=yes",
                           toDirection.location.coordinate.latitude,
                           toDirection.location.coordinate.longitude)
        case .moovit:
            urlString = String(format: "moovit://directions?dest_lat=%f&dest_lon=%f&dest_name%@=&orig_lat=%f&orig_lon=%f&orig_name=%@&auto_run=true&partner_id=%@",
                           toDirection.location.coordinate.latitude,
                           toDirection.location.coordinate.longitude,
                           urlEncode(toDirection.name),
                           fromDirections.location.coordinate.latitude,
                           fromDirections.location.coordinate.longitude,
                           urlEncode(fromDirections.name),
                           Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? "")
        }
        guard let url = URL(string: urlString) else {
            return false
        }
        if #available(iOS 10.0, *) {
            application.open(url, options: [:], completionHandler: nil)
            return true
        } else {
            let isOpened = application.openURL(url)
            return isOpened
        }
    }
    
    /**
      Prepares deep linking url with given point
      - parameter mapPoint: MapAppPoint
      - returns: Deeplink url
     */
    internal func googleMapsString(_ mapPoint: MapPoint) -> String {
        if !CLLocationCoordinate2DIsValid(mapPoint.location.coordinate) {
            return ""
        }
        
        if !mapPoint.name.isEmpty {
            let encodedName = mapPoint.name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            return String(format: "%f,%f+(%@)",
                            mapPoint.location.coordinate.latitude,
                            mapPoint.location.coordinate.longitude,
                            encodedName!)
        }
        
        return String(format: "%f,%f",
                        mapPoint.location.coordinate.latitude,
                        mapPoint.location.coordinate.longitude)
    }
    
    /**
      Encodes given string
      - parameter name: String
      - returns: Encoded name
     */
    internal func urlEncode(_ name: String) -> String {
        return name.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    // MARK: Map Apps Getter
    
    /**
      Returns available navigation apps
      - returns: Map Apps
     */
    open func getMapApps() -> [String] {
        return availableMapApps
    }
    
}

/**
  Point class used for deep linking
 */
open class MapPoint {
    
    /**
      Location value for navigation
     */
    internal var location: CLLocation!
    
    /**
      Place name
     */
    internal var name: String!
    
    /**
      Place address
     */
    internal var address: String!
    
    /**
      Initialize point object with given parameters
      - parameter location: Location belongs to place
      - parameter name: Name belongs to place
      - parameter address: Address belongs to place
     */
    public init(location: CLLocation, name: String, address: String) {
        self.location = location
        self.name = name
        self.address = address
    }
    
}

/**
  Protocol that used for UIApplication
 */
public protocol UIApplicationProtocol {
    
    /**
      Open given url
     */
    func openURL(_ url: URL) -> Bool
    
    /**
      Checks if given url can be opened
     */
    func canOpenURL(_ url: URL) -> Bool
    
    /**
      Open given url for iOS 10+
     */
    @available(iOS 10.0, *)
    func open(_ url: URL, options: [String : Any], completionHandler completion: ((Bool) -> Swift.Void)?)
}

/**
  Extension for UIApplication
 */
extension UIApplication: UIApplicationProtocol {}
