//
//  ViewController.swift
//  ASMapLauncher
//
//  Created by Abdullah Selek on 06/06/15.
//  Copyright (c) 2015 Abdullah Selek. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UIActionSheetDelegate, CLLocationManagerDelegate {

    // map launcher
    fileprivate var mapLauncher: ASMapLauncher!
    fileprivate var mapApps = [String]()

    // location manager
    fileprivate var locationManager: CLLocationManager = CLLocationManager()
    // current coordinate
    fileprivate var currenctCoordinate: CLLocationCoordinate2D!

    // ui compononents
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var navigationBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        locationManager.delegate = self
        mapLauncher = ASMapLauncher()

        // get current location
        getLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showNavigationSheet() {
        self.mapApps = mapLauncher.getMapApps()
        let actionSheet = UIActionSheet(title: "Choose your app for navigation", delegate: self, cancelButtonTitle: nil, destructiveButtonTitle: nil)
        for mapApp in self.mapApps {
            actionSheet.addButton(withTitle: mapApp)
        }
        actionSheet.addButton(withTitle: "Cancel")
        actionSheet.cancelButtonIndex = mapApps.count
        actionSheet.show(in: self.view)
    }

    // MARK: ActionSheet Delegates

    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == actionSheet.numberOfButtons - 1 {
            return
        }

        let mapApp: String! = self.mapApps[buttonIndex]
        let destination: CLLocation! = CLLocation(latitude: 41.0053215, longitude: 29.0121795)

        let fromMapPoint: MapPoint! = MapPoint(location: CLLocation(latitude: currenctCoordinate.latitude, longitude: currenctCoordinate.longitude), name: "", address: "")
        let toMapPoint: MapPoint! = MapPoint(location: CLLocation(latitude: destination.coordinate.latitude, longitude: destination.coordinate.longitude), name: "", address: "")

        mapLauncher.launchMapApp(MapApp(rawValue: mapApp)!, fromDirections: fromMapPoint, toDirection: toMapPoint)
    }

    // MARK: Location Manager methods

    func getLocation() {
        enableIndicator(true)

        /**
         * - parameter for desiredAccuracy
         *   kCLLocationAccuracyBestForNavigation
         *   kCLLocationAccuracyBest
         *   kCLLocationAccuracyNearestTenMeters
         *   kCLLocationAccuracyHundredMeters
         *   kCLLocationAccuracyKilometer
         *   kCLLocationAccuracyThreeKilometers
         **/
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.locationManager.requestWhenInUseAuthorization()

        startUpdatingLocation()
    }

    // MARK: Location Manager delegates

    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case CLAuthorizationStatus.restricted, CLAuthorizationStatus.denied, CLAuthorizationStatus.notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case CLAuthorizationStatus.authorizedAlways, CLAuthorizationStatus.authorizedWhenInUse:
            startUpdatingLocation()
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject as! CLLocation
        let coordinate = locationObj.coordinate
        self.currenctCoordinate = coordinate

        locationManager.stopUpdatingLocation()
        self.enableIndicator(false)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()

    }

    func startUpdatingLocation() {
        if (CLLocationManager.locationServicesEnabled()) {
            if #available(iOS 9.0, *) {
                locationManager.requestLocation()
            } else {
                // Fallback on earlier versions
                locationManager.startUpdatingLocation()
            }
        }
    }

    // MARK: Button Action

    @IBAction func navigationBtnTapped(_ sender: AnyObject) {
        /*** show all available mapping actions ***/
        showNavigationSheet()

        /*** navigation for only selected map app type
         var isInstalled = mapLauncher.isMapAppInstalled(ASMapApp.ASMapAppGoogleMaps)
         if isInstalled {
         var destination: CLLocation! = CLLocation(latitude: 41.0053215, longitude: 29.0121795)
         var fromMapPoint: MapPoint! = MapPoint(location: CLLocation(latitude: currenctCoordinate.latitude, longitude: currenctCoordinate.longitude), name: "", address: "")
         var toMapPoint: MapPoint! = MapPoint(location: CLLocation(latitude: destination.coordinate.latitude, longitude: destination.coordinate.longitude), name: "", address: "")
         mapLauncher.launchMapApp(ASMapApp.ASMapAppGoogleMaps, fromDirections: fromMapPoint, toDirection: toMapPoint)
         }
         ***/
    }

    // MARK: Activity Indicator

    func enableIndicator(_ enable: Bool) {
        DispatchQueue.main.async(execute: { () -> Void in
            if enable {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()

                self.navigationBtn.isHidden = false
            }
        })
    }
}
