![](http://juanpecatalan.com/JDAnimationKit/JDAnimationKit_header_2.jpg)

[![Version](https://img.shields.io/cocoapods/v/JDAnimationKit.svg?style=flat)](http://cocoapods.org/pods/JDAnimationKit)
[![License](https://img.shields.io/cocoapods/l/JDAnimationKit.svg?style=flat)](http://cocoapods.org/pods/JDAnimationKit)
[![Platform](https://img.shields.io/cocoapods/p/JDAnimationKit.svg?style=flat)](http://cocoapods.org/pods/JDAnimationKit)

**JDAnimationKit** is designed to be extremely easy to use. You can animate your UI withe less lines of code. This library use internally [POP](https://github.com/facebook/pop) framework, an extensible iOS and OS X animation library, useful for physics-based interactions.

### Supported OS & SDK Versions

* Supported build target - iOS 8.3 (Xcode 7)

### Demo

![Preview](http://juanpecatalan.com/JDAnimationKit/beetripper_1.gif)
![Preview](http://juanpecatalan.com/JDAnimationKit/beetripper_2.gif)
######
*[Beetripper App's screenshots](http://beetripper.com)*

####

<table>
<tr>
<td width="75%">
<img src="http://juanpecatalan.com/JDAnimationKit/general_2.png"></img>
</td>
<td width="25%">
<img src="http://juanpecatalan.com/JDAnimationKit/general_2.gif"></img>
</td>
</tr
<tr>
<td width="75%">
<img src="http://juanpecatalan.com/JDAnimationKit/general.png"></img>
</td>
<td width="25%">
<img src="http://juanpecatalan.com/JDAnimationKit/general.gif"></img>
</td>
</tr>
</table>

## Installation

JDAnimationKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "JDAnimationKit"
```

Note: Due to [CocoaPods/CocoaPods#4420 issue](https://github.com/CocoaPods/CocoaPods/issues/4420) there is problem with compiling project with Xcode 7.1 and CocoaPods v0.39.0. However there is a temporary workaround for this:
Add next lines to the end of your Podfile
```ruby
post_install do |installer|
  `find Pods -regex 'Pods/pop.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)pop\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`
end
```
To install manually the JDAnimationKit class in an app, just drag the ``` JDAnimationKit.swift``` class file (demo files and assets are not needed) into your project. Also you need to install facebook-pop. Or add bridging header if you are using CocoaPods.

## Usage

Import JDAnimationKit in proper place.
```swift
import JDAnimationKit
```

You can animate **CALayers** and **UIViews** (and subclasses). Only you add the animation you want after element.
```swift
self.squareView.rotateTo(90)
```

If you want mutiple animation at one time.
```swift
self.squareView.rotateTo(90).moveXBy(50).opacityTo(0)
```

All methods have got more arguments with default values. You don't need indicate all, only the params that your need.

```swift
self.squareView.rotateTo(90).moveXBy(50, delay: 2.0, timing: .EaseIn)
```

## Configure your animations

You can adjust the parameters of your animations:
#### -> duration : *Double*
Indicate the duration of animation *(Default: 0.5)*

#### -> spring : *Bool*
Indicate if apply physics effects to animate *(Default: false)*

#### -> springConfig : *JDSpringConfig (struct)*
If ```spring``` property is ```true```, configure the physics params (```bounciness``` and ```speed```) *(Default: bounciness: 10, speed: 10)*

#### -> timing : *JDTimingFunction (enum)*
The animation-timing-function specifies the speed curve of an animation *(Default: .None)*

**Values:**
* EaseIn
* EaseOut
* EaseInOut
* Linear
* None

#### -> delay : *Double*
You can execute the animation after X seconds. *(Default: 0)*

#### -> key : *String*
Identify the animation

## Anchoring

The anchor point represents the point from which certain coordinates originate. The anchor point is one of several properties that you specify using the unit coordinate system. Core Animation uses unit coordinates to represent properties whose values might change when the layer’s size changes. You can think of the unit coordinates as specifying a percentage of the total possible value. Every coordinate in the unit coordinate space has a range of 0.0 to 1.0. For example, along the x-axis, the left edge is at the coordinate 0.0 and the right edge is at the coordinate 1.0.

![Preview](https://c1.staticflickr.com/9/8164/7525485756_6782ed8ce6.jpg)

You can set the anchor point with this code:

```swift
self.squareView.changeAnchorPoint(0, y: 0)  
```

## Callback

If you want to get animations callbacks or if you want to run code after an animation finishes, you are supposed to call didStopAnimation or didStartAnimation block.
```swift
self.squareView.scaleTo(2, scaleY: 2).didStartAnimation { (node, key, finished, error) -> Void in

}
```
```swift
self.squareView.scaleTo(2, scaleY: 2).didStopAnimation { (node, key, finished, error) -> Void in

}
```

## Chainable Animations

<table>

<tr>
<td width="20%">
<img src="http://juanpecatalan.com/JDAnimationKit/moveXTo.gif"></img>
</td>
<td width="80%">
<code>self.squareView.moveXTo(100)</code>
</td>
</tr>

<tr>
<td width="20%">
<img src="http://juanpecatalan.com/JDAnimationKit/moveYTo.gif"></img>
</td>
<td width="80%">
<code>self.squareView.moveYTo(100)</code>
</td>
</tr>

<tr>
<td width="20%">
<img src="http://juanpecatalan.com/JDAnimationKit/moveTo.gif"></img>
</td>
<td width="80%">
<code>self.squareView.moveTo(100, y: 100)</code>
</td>
</tr>

<tr>
<td width="20%">
<img src="http://juanpecatalan.com/JDAnimationKit/moveXBy.gif"></img>
</td>
<td width="80%">
<code>self.squareView.moveXBy(100)</code>
</td>
</tr>

<tr>
<td width="20%">
<img src="http://juanpecatalan.com/JDAnimationKit/moveYBy.gif"></img>
</td>
<td width="80%">
<code>self.squareView.moveYBy(50)</code>
</td>
</tr>

<tr>
<td width="20%">
<img src="http://juanpecatalan.com/JDAnimationKit/moveBy.gif"></img>
</td>
<td width="80%">
<code>self.squareView.moveBy(100, deltaY: 50)</code>
</td>
</tr>

<tr>
<td width="20%">
<img src="http://juanpecatalan.com/JDAnimationKit/scaleXTo.gif"></img>
</td>
<td width="80%">
<code>self.squareView.scaleXTo(2)</code>
</td>
</tr>

<tr>
<td width="20%">
<img src="http://juanpecatalan.com/JDAnimationKit/scaleYTo.gif"></img>
</td>
<td width="80%">
<code>self.squareView.scaleYTo(2)</code>
</td>
</tr>

<tr>
<td width="20%">
<img src="http://juanpecatalan.com/JDAnimationKit/scaleTo.gif"></img>
</td>
<td width="80%">
<code>self.squareView.scaleTo(2, scaleY: 2)</code>
</td>
</tr>

<tr>
<td width="20%">
<img src="http://juanpecatalan.com/JDAnimationKit/opacityTo.gif"></img>
</td>
<td width="80%">
<code>self.squareView.opacityTo(0)</code>
</td>
</tr>

<tr>
<td width="20%">
<img src="http://juanpecatalan.com/JDAnimationKit/rotateTo.gif"></img>
</td>
<td width="80%">
<code>self.squareView.rotateTo(90)</code>
</td>
</tr>

<tr>
<td width="20%">
<img src="http://juanpecatalan.com/JDAnimationKit/changeBounds.gif"></img>
</td>
<td width="80%">
<code>self.squareView.changeBounds(bounds) //let bounds: CGRect</code>
</td>
</tr>

<tr>
<td width="20%">
<img src="http://juanpecatalan.com/JDAnimationKit/changeBgColor.gif"></img>
</td>
<td width="80%">
<code>self.squareView.changeBgColor(green) //let green: UIColor</code>
</td>
</tr>

</table>

## Author

* [Jelly Development](https://github.com/JellyDevelopment)
* Juanpe Catalán, juanpecm@gmail.com
* David López Carrascal, davidlcarrascal@gmail.com

## License

JDAnimationKit is available under the MIT license. See the LICENSE file for more info.
