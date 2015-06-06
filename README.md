# ASMapLauncher
ASMapLauncher is a library for iOS written in Swift that helps navigation with various mapping applications.

First initiate ASMapLauncher and check for a selected mapping application that installed on device

	mapLauncher = ASMapLauncher()
	var isInstalled = mapLauncher.isMapAppInstalled(ASMapApp.ASMapAppGoogleMaps)
	
Then, launch selected mapping application

	if isInstalled {
		var destination: CLLocation! = CLLocation(latitude: 41.0053215, longitude: 29.0121795)
    	var fromMapPoint: ASMapPoint! = ASMapPoint(location: CLLocation(latitude: currenctCoordinate.latitude, longitude: currenctCoordinate.longitude), name: "", address: "")
        var toMapPoint: ASMapPoint! = ASMapPoint(location: CLLocation(latitude: destination.coordinate.latitude, longitude: destination.coordinate.longitude), name: "", address: "")
        mapLauncher.launchMapApp(ASMapApp.ASMapAppGoogleMaps, fromDirections: fromMapPoint, toDirection: toMapPoint)
    }

Supported mapping applications

	- Apple Maps
	- Google Maps
	- Yandex Navigator
	- Citymapper
	- Navigon
	- The Transit App
	- Waze