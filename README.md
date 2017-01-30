![Build Status](https://travis-ci.org/abdullahselek/ASMapLauncher.svg?branch=master)
![CocoaPods Compatible](https://img.shields.io/cocoapods/v/ASMapLauncher.svg)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

# ASMapLauncher
ASMapLauncher is a library for iOS written in Swift that helps navigation with various mapping applications.

## Requirements
iOS 8.0+

## CocoaPods

CocoaPods is a dependency manager for Cocoa projects. You can install it with the following command:
```	
$ gem install cocoapods
```
To integrate ASMapLauncher into your Xcode project using CocoaPods, specify it in your Podfile:
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
	pod 'ASMapLauncher', '1.0.5'
end
```
Then, run the following command:
```
$ pod install
```
## Carthage

Carthage is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with Homebrew using the following command:

```
brew update
brew install carthage
```

To integrate ASMapLauncher into your Xcode project using Carthage, specify it in your Cartfile:

```
github "abdullahselek/ASMapLauncher" ~> 1.0.5
```

Run carthage update to build the framework and drag the built ASMapLauncher.framework into your Xcode project.

## Usage

First initiate ASMapLauncher and check for a selected mapping application that installed on device
```
let mapLauncher = ASMapLauncher()
let isInstalled = mapLauncher.isMapAppInstalled(.here)
```

Then, launch selected mapping application
```
if isInstalled {
	let destination: CLLocation! = CLLocation(latitude: 41.0053215, longitude: 29.0121795)
	let fromMapPoint: MapPoint! = MapPoint(location: CLLocation(latitude: currenctCoordinate.latitude,
	longitude: currenctCoordinate.longitude),
										   name: "", 
										   address: "")
    let toMapPoint: MapPoint! = MapPoint(location: CLLocation(latitude: destination.coordinate.latitude, longitude: destination.coordinate.longitude), 
                                         name: "", 
                                         address: "")
    mapLauncher.launchMapApp(.here, 
                             fromDirections: fromMapPoint, 
                             toDirection: toMapPoint)
}

```
Supported mapping applications
```
- Apple Maps
- HERE Maps
- Google Maps
- Yandex Navigator
- Citymapper
- Navigon
- The Transit App
- Waze
- Moovit
```	

## MIT License
```
Copyright (c) 2015 Abdullah Selek

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
