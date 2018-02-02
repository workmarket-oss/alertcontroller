# WMAlertController

[![CI Status](http://img.shields.io/travis/workmarket-oss/WMAlertController.svg?style=flat)](https://travis-ci.org/workmarket-oss/WMAlertController)
[![Version](https://img.shields.io/cocoapods/v/WMAlertController.svg?style=flat)](http://cocoapods.org/pods/WMAlertController)
[![License](https://img.shields.io/cocoapods/l/WMAlertController.svg?style=flat)](http://cocoapods.org/pods/WMAlertController)
[![Platform](https://img.shields.io/cocoapods/p/WMAlertController.svg?style=flat)](http://cocoapods.org/pods/WMAlertController)

![Screenshots](https://github.com/workmarket-oss/alertcontroller/blob/master/Screenshots/dark_style.png)
![Screenshots](https://github.com/workmarket-oss/alertcontroller/blob/master/Screenshots/light_style.png)
![Screenshots](https://github.com/workmarket-oss/alertcontroller/blob/master/Screenshots/two_buttons.png)
![Screenshots](https://github.com/workmarket-oss/alertcontroller/blob/master/Screenshots/three_buttons.png)

## Requirement
* iOS 9.0+
* Swift 3.0+

## Installation

WMAlertController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WMAlertController'
```

## About

WMAlertController is a fully customizable alert controller that functions like the familiar UIAlertController.

Using the provided WMAlertStyle, you can modify the following attributes:

- overlayBackgroundColor
- backgroundColor
- cornerRadius
- titleFont
- titleTextColor
- titleNumberOfLines
- messageFont
- messageTextColor
- messageNumberOfLines
- separatorColor
- titleAttributes
- messageAttributes

## Usage

```swift
let alertController = WMAlertController(
    title: "Confirmation",
    message: "Example Alert Controller",
    style: .light,
    decoration: .none
)
alertController.addAction(WMAlertAction(title: "Cancel", handler: { (action) in
    action.alert?.dismiss(animated: true, completion: nil)
}))
alertController.addAction(WMAlertAction(title: "Do the action", handler: { (action) in
    action.alert?.dismiss(animated: true, completion: {
        // Do some work...
    })
}))
self.present(alertController, animated: true, completion: nil)
```

## License

WMAlertController is available under the ASLv2 license. See the LICENSE file for more info.
