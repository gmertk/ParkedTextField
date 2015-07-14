# ParkedTextField
[![Version](https://img.shields.io/cocoapods/v/ParkedTextField.svg?style=flat)](http://cocoapods.org/pods/ParkedTextField)
[![License](https://img.shields.io/cocoapods/l/ParkedTextField.svg?style=flat)](http://cocoapods.org/pods/ParkedTextField)
[![Platform](https://img.shields.io/cocoapods/p/ParkedTextField.svg?style=flat)](http://cocoapods.org/pods/ParkedTextField)

A text field subclass with a constant text in the end. 

Main functionality works. It is still under development.

## Screenshot

![ParkedTextField.gif](https://raw.githubusercontent.com/gmertk/ParkedTextField/master/Screenshots/ParkedTextField.gif)


## Usage

ParkedTextField is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following lines to your Podfile:

```ruby
use_frameworks!
pod "ParkedTextField"
```
	
## Setup

If you want to use storyboards, just drop a TextField into your storyboard and set its class to `ParkedTextField`. Then customize through the attributes inspector. Otherwise, you can write the code to initialize with frame and set the properties.

## Properties
```swift
/// Constant text in the end of text field. Defaults to "".
var parkedText: String = ".slack.com" 

/// Font of parkedText. Defaults the text field's font or its bold version if it exists. 
var parkedTextFont: UIFont!

/// Color of parkedText. Defaults the font's color.
var parkedTextColor: UIColor! 


```

## Author

Günay Mert Karadoğan, mertkaradogan@gmail.com

## License

ParkedTextField is available under the MIT license. See the LICENSE file for more info.


