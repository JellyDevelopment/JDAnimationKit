//
//  JDAnimationKit.swift
//  TestJDAnimationKit
//
//  Created by Juan Pedro Catalán on 20/02/16.
//  Copyright © 2016 Juanpe Catalán. All rights reserved.
//

import Foundation
import ObjectiveC
import UIKit
import pop

public enum JDTimingFunction {
    case Linear
    case EaseIn
    case EaseOut
    case EaseInOut
    case None
}

struct JDAssociatedKeys {
    static var didStartBlockKey = "JDdidStartBlock"
    static var didStopBlockKey = "JDdidStopBlock"
    static var startedAnimationsKeysAssociated = "JDstartedAnimationsKeys"
    static var waitingToStartAnimationsKeysAssociated = "JDwaitingToStartAnimationsKeys"
}

public struct JDSpringConfig{
    
    public var bounciness: CGFloat
    public var speed: CGFloat
    
    public init(bounciness: CGFloat, speed: CGFloat){
        
        self.bounciness = bounciness
        self.speed = speed
    }
    
    public static func JDSpringConfigDefault() -> JDSpringConfig{
        return JDSpringConfig(bounciness: 5, speed: 10)
    }
}

public struct JDAnimationConfig{

    var duration: Double = 0.5
}

public typealias JDLayerAnimationStartBlock = (node: JDAnimationNode?, key: String?, finished: Bool?, error: NSError?) -> Void

class ClosureLayerWrapper {
    var closure: JDLayerAnimationStartBlock!
    
    init(_ closure: JDLayerAnimationStartBlock!) {
        self.closure = closure
    }
}

// MARK: - Addons -

extension Array where Element: Equatable {
    
    mutating func removeObject(object: Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
    
    mutating func removeObjectsInArray(array: [Element]) {
        for object in array {
            self.removeObject(object)
        }
    }
}

extension Double {
    
    func DegreesToRadians() -> Double {
        return self * M_PI / 180.0
    }
    
    func RadiansToDegrees() -> Double {
        return self * 180.0 / M_PI
    }
}

// MARK: - JDAnimationNode -

public protocol JDAnimationNode : class{
    
    var didStartBlock: JDLayerAnimationStartBlock? { get set }
    var didStopBlock: JDLayerAnimationStartBlock? { get set }
    
    var startedAnimationsKeys: [String]! {get set}
    var waitingToStartAnimationsKeys: [String]! {get set}
    
    func animatableLayer() -> CALayer
    
    func didStartAnimation(startBlock: JDLayerAnimationStartBlock?) -> JDAnimationNode
    func didStopAnimation(stopBlock: JDLayerAnimationStartBlock?) -> JDAnimationNode
    
    func makeGenericAnimation(property: String, toValue: AnyObject, duration: Double, delay: Double, spring: Bool, springConfig: JDSpringConfig, key: String, timing: JDTimingFunction) -> POPAnimation
    
    func makeChangeBounds(bounds: CGRect, duration: Double, spring: Bool, springConfig: JDSpringConfig, delay: Double, key: String, timing: JDTimingFunction) -> POPAnimation
    func changeBounds(bounds: CGRect, duration: Double, spring: Bool, springConfig: JDSpringConfig, delay: Double, key: String, timing: JDTimingFunction) -> JDAnimationNode
    
    func makeScaleTo(scaleX: CGFloat, scaleY: CGFloat, duration: Double, spring: Bool, springConfig: JDSpringConfig, delay: Double , key: String, timing: JDTimingFunction) -> POPAnimation
    func scaleXTo(scaleX: CGFloat, duration: Double , spring: Bool, springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> JDAnimationNode
    func scaleYTo(scaleY: CGFloat, duration: Double , spring: Bool, springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> JDAnimationNode
    func scaleTo(scaleX: CGFloat, scaleY: CGFloat, duration: Double , spring: Bool, springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> JDAnimationNode
    
    func makeRotateTo(angle: Double, duration: Double , spring: Bool, springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> POPAnimation
    func rotateTo(angle: Double, duration: Double , spring: Bool, springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> JDAnimationNode
    
    func makeChangeBgColor(color: UIColor, duration: Double, spring: Bool, springConfig: JDSpringConfig, delay: Double, key: String, timing: JDTimingFunction) -> POPAnimation
    
    func changeBgColor(color: UIColor, duration: Double, spring: Bool, springConfig: JDSpringConfig, delay: Double, key: String, timing: JDTimingFunction) -> JDAnimationNode
    
    func makeOpacity(alpha: Double, duration: Double , spring: Bool, springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> POPAnimation
    func opacityTo(alpha: Double, duration: Double , spring: Bool, springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> JDAnimationNode
    
    func changeAnchorPoint(x: CGFloat, y: CGFloat, delay: Double) -> JDAnimationNode
    
    func moveXTo(x: CGFloat, duration: Double , spring: Bool, springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> JDAnimationNode
    func moveYTo(y: CGFloat, duration: Double , spring: Bool, springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> JDAnimationNode
    func moveTo(x: CGFloat, y: CGFloat, duration: Double , spring: Bool, springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> JDAnimationNode
    
    func moveXBy(deltaX: CGFloat, duration: Double , spring: Bool , springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> JDAnimationNode
    func moveYBy(deltaY: CGFloat, duration: Double , spring: Bool , springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> JDAnimationNode
    func moveBy(deltaX: CGFloat, deltaY: CGFloat, duration: Double , spring: Bool , springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> JDAnimationNode
    func makeMoveBy(deltaX: CGFloat, deltaY: CGFloat, duration: Double , delay: Double , spring: Bool , springConfig: JDSpringConfig , key: String, timing: JDTimingFunction) -> POPAnimation
}

// MARK: - Default implementation -

extension JDAnimationNode{
    
    // MARK: Properties
    
    public var startedAnimationsKeys: [String]! {
        get {
            if let keys = objc_getAssociatedObject(self.animatableLayer(), &JDAssociatedKeys.startedAnimationsKeysAssociated) as? [String] {
                return keys
            }
            
            return [String]()
        }
        set(newValue) {
            objc_setAssociatedObject(self.animatableLayer(), &JDAssociatedKeys.startedAnimationsKeysAssociated, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public var waitingToStartAnimationsKeys: [String]! {
        get {
            if let keys = objc_getAssociatedObject(self.animatableLayer(), &JDAssociatedKeys.waitingToStartAnimationsKeysAssociated) as? [String] {
                return keys
            }
            
            return [String]()
        }
        set(newValue) {
            objc_setAssociatedObject(self.animatableLayer(), &JDAssociatedKeys.waitingToStartAnimationsKeysAssociated, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public var didStartBlock: JDLayerAnimationStartBlock? {
        get {
            
            if let cl = objc_getAssociatedObject(self.animatableLayer(), &JDAssociatedKeys.didStartBlockKey) as? ClosureLayerWrapper {
                return cl.closure
            }
            return nil
        }
        
        set {
            objc_setAssociatedObject(self as? UIView, &JDAssociatedKeys.didStartBlockKey, ClosureLayerWrapper(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var didStopBlock: JDLayerAnimationStartBlock? {
        get {
            
            if let cl = objc_getAssociatedObject(self.animatableLayer(), &JDAssociatedKeys.didStopBlockKey) as? ClosureLayerWrapper {
                return cl.closure
            }
            return nil
        }
        
        set {
            objc_setAssociatedObject(self.animatableLayer(), &JDAssociatedKeys.didStopBlockKey, ClosureLayerWrapper(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: Generic
    
    public func makeGenericAnimation(property: String, toValue: AnyObject, duration: Double, delay: Double = 0, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), key: String, timing: JDTimingFunction) -> POPAnimation {
        
        if spring {
            
            let animation = (POPSpringAnimation(propertyNamed: property) as POPSpringAnimation)
            animation.springBounciness = springConfig.bounciness
            animation.springSpeed = springConfig.speed
            animation.toValue = toValue
            animation.beginTime = (CACurrentMediaTime() + delay)
            animation.delegate = self.animatableLayer()
            animation.name = key
            
            return animation
            
        } else {
            
            let animation = POPBasicAnimation(propertyNamed: property)
            animation.duration = duration
            animation.toValue = toValue
            animation.beginTime = (CACurrentMediaTime() + delay)
            animation.delegate = self.animatableLayer()
            animation.name = key
            animation.timingFunction = self._timingFunctionKey(timing)
            
            return animation
        }
    }
    
    public func animatableLayer() -> CALayer{
        return self as! CALayer
    }
    
    // MARK: Private
    
    internal func _timingFunctionKey(timing: JDTimingFunction) -> CAMediaTimingFunction{
        
        switch timing{
            
        case .EaseIn:
            return CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        case .EaseOut:
            return CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        case .EaseInOut:
            return CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        case .Linear:
            return CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear)
        case .None:
            return CAMediaTimingFunction(name:kCAMediaTimingFunctionDefault)
        }
    }
    
    internal func _executeAfter(delay: Double, closure: ()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(),
            closure
        )
    }
    
    internal func _addAnimation(animation: POPAnimation, key: String) -> JDAnimationNode{
        
        self.waitingToStartAnimationsKeys.append(key)
        self.startedAnimationsKeys.append(key)
        
        self.animatableLayer().pop_addAnimation(animation, forKey: key)
        
        return self
    }
    
    // MARK: Change Bounds
    
    public func makeChangeBounds(bounds: CGRect, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "changeBound", timing: JDTimingFunction = .None) -> POPAnimation {
        
        return self.makeGenericAnimation(kPOPLayerBounds, toValue: NSValue(CGRect: bounds), duration: duration, delay: delay, spring: spring, springConfig: springConfig, key: key, timing: timing)
    }
    
    public func changeBounds(bounds: CGRect, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "changeBound", timing: JDTimingFunction = .None) -> JDAnimationNode {
        
        let frameAnimation = makeChangeBounds(bounds, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
        
        self._addAnimation(frameAnimation, key: frameAnimation.name)
        
        return self
    }
    
    // MARK: ScaleTo
    
    public func makeScaleTo(scaleX: CGFloat, scaleY: CGFloat, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "scaleTo", timing: JDTimingFunction = .None) -> POPAnimation {
        
        return self.makeGenericAnimation(kPOPLayerScaleXY, toValue: NSValue(CGPoint: CGPointMake(scaleX, scaleY)), duration: duration, delay: delay, spring: spring, springConfig: springConfig, key: key, timing: timing)
    }
    
    public func scaleXTo(scaleX: CGFloat, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "scaleXTo", timing: JDTimingFunction = .None) -> JDAnimationNode {
        
        return self.scaleTo(scaleX, scaleY: 1, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
    }
    
    public func scaleYTo(scaleY: CGFloat, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "scaleYTo", timing: JDTimingFunction = .None) -> JDAnimationNode {
        
        return self.scaleTo(1, scaleY: scaleY, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
    }
    
    public func scaleTo(scaleX: CGFloat, scaleY: CGFloat,duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "scaleTo", timing: JDTimingFunction = .None) -> JDAnimationNode {
        
        let scaleAnimation = makeScaleTo(scaleX, scaleY: scaleY, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
        
        self._addAnimation(scaleAnimation, key: scaleAnimation.name)
        
        return self
    }
    
    // MARK: RotateTo
    
    public func makeRotateTo(angle: Double, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "rotateTo", timing: JDTimingFunction = .None) -> POPAnimation {
        
        return self.makeGenericAnimation(kPOPLayerRotation, toValue: CGFloat(angle.DegreesToRadians()), duration: duration, delay: delay, spring: spring, springConfig: springConfig, key: key, timing: timing)
    }
    
    public func rotateTo(angle: Double, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "rotateTo", timing: JDTimingFunction = .None) -> JDAnimationNode {
        
        let rotateAnimation = makeRotateTo(angle, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
        
        self._addAnimation(rotateAnimation, key: rotateAnimation.name)
        
        return self
    }
    
    // MARK: BackgroundColor
    
    public func makeChangeBgColor(color: UIColor, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "backgroundTo", timing: JDTimingFunction = .None) -> POPAnimation {
        return self.makeGenericAnimation(kPOPLayerBackgroundColor, toValue: color, duration: duration, delay: delay, spring: spring, springConfig: springConfig, key: key, timing: timing)
    }
    
    public func changeBgColor(color: UIColor, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "backgroundTo", timing: JDTimingFunction = .None) -> JDAnimationNode {
        
        let backgroundAnimation = makeChangeBgColor(color, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
        
        self._addAnimation(backgroundAnimation, key: backgroundAnimation.name)
        
        return self
    }
    
    // MARK: Opacity
    
    public func makeOpacity(alpha: Double, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "opacityTo", timing: JDTimingFunction = .None) -> POPAnimation {
        return self.makeGenericAnimation(kPOPLayerOpacity, toValue: CGFloat(alpha), duration: duration, delay: delay, spring: spring, springConfig: springConfig, key: key, timing: timing)
    }
    
    public func opacityTo(alpha: Double, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "opacityTo", timing: JDTimingFunction = .None) -> JDAnimationNode {
        
        let alphaAnimation = makeOpacity(alpha, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
        
        self._addAnimation(alphaAnimation, key: alphaAnimation.name)
        
        return self
    }
    
    // MARK: Anchor point
    
    public func changeAnchorPoint(x: CGFloat, y: CGFloat, delay: Double = 0) -> JDAnimationNode{
        
        self._executeAfter(delay) { () -> () in
            
            let anchorPoint = CGPoint(x: x, y: y)
            
            var newPoint = CGPointMake(self.animatableLayer().bounds.size.width * anchorPoint.x, self.animatableLayer().bounds.size.height * anchorPoint.y)
            var oldPoint = CGPointMake(self.animatableLayer().bounds.size.width * self.animatableLayer().anchorPoint.x, self.animatableLayer().bounds.size.height * self.animatableLayer().anchorPoint.y)
            
            newPoint = CGPointApplyAffineTransform(newPoint, self.animatableLayer().affineTransform())
            oldPoint = CGPointApplyAffineTransform(newPoint, self.animatableLayer().affineTransform())
            
            var position = self.animatableLayer().position
            position.x -= oldPoint.x
            position.x += newPoint.x
            
            position.y -= oldPoint.y
            position.y += newPoint.y
            
            self.animatableLayer().position = position
            self.animatableLayer().anchorPoint = anchorPoint
        }
        
        return self
    }
    
    // MARK: Move To
    
    public func moveXTo(x: CGFloat, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "moveXTo", timing: JDTimingFunction = .None) -> JDAnimationNode {
        
        return self.moveTo(x, y: self.animatableLayer().position.y, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
    }
    
    
    public func moveYTo(y: CGFloat, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "moveYTo", timing: JDTimingFunction = .None) -> JDAnimationNode {
        
        return self.moveTo(self.animatableLayer().position.x, y: y, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
    }
    
    public func moveTo(x: CGFloat, y: CGFloat, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "moveTo", timing: JDTimingFunction = .None) -> JDAnimationNode {
        
        let moveAnimation = makeMoveTo(x, y: y, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
        
        self._addAnimation(moveAnimation, key: moveAnimation.name)
        
        return self
    }
    
    public func makeMoveTo(x: CGFloat, y: CGFloat, duration: Double = 0.5, delay: Double = 0, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), key: String = "moveTo", timing: JDTimingFunction = .None) -> POPAnimation {
        
        return self.makeGenericAnimation(kPOPLayerPosition, toValue: NSValue(CGPoint: CGPoint(x: x, y: y)), duration: duration, delay: delay, spring: spring, springConfig: springConfig, key: key, timing: timing)
    }
    
    // MARK: Move By
    
    public func moveXBy(deltaX: CGFloat, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "moveXBy", timing: JDTimingFunction = .None) -> JDAnimationNode {
        
        return self.moveBy(deltaX, deltaY: 0, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
    }
    
    
    public func moveYBy(deltaY: CGFloat, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "moveYBy", timing: JDTimingFunction = .None) -> JDAnimationNode {
        
        return self.moveBy(0, deltaY: deltaY, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
    }
    
    public func moveBy(deltaX: CGFloat, deltaY: CGFloat, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "moveBy", timing: JDTimingFunction = .None) -> JDAnimationNode {
        
        let moveAnimation = makeMoveBy(deltaX, deltaY: deltaY, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
        
        self._addAnimation(moveAnimation, key: moveAnimation.name)
        
        return self
    }
    
    public func makeMoveBy(deltaX: CGFloat, deltaY: CGFloat, duration: Double = 0.5, delay: Double = 0, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), key: String = "moveBy", timing: JDTimingFunction = .None) -> POPAnimation {
        
        var nextPosition = self.animatableLayer().position
        nextPosition.x += deltaX
        nextPosition.y += deltaY
        
        return self.makeGenericAnimation(kPOPLayerPosition, toValue: NSValue(CGPoint: nextPosition), duration: duration, delay: delay, spring: spring, springConfig: springConfig, key: key, timing: timing)
    }
    
    // MARK: Callback
    
    public func didStartAnimation(startBlock: JDLayerAnimationStartBlock?) -> JDAnimationNode {
        
        self.animatableLayer().didStartBlock = startBlock
        
        return self
    }
    
    public func didStopAnimation(stopBlock: JDLayerAnimationStartBlock?) -> JDAnimationNode {
        
        self.animatableLayer().didStopBlock = stopBlock
        
        return self
    }
}

// MARK: - POPAnimation Delegate -

extension CALayer : POPAnimationDelegate {
    
    public func pop_animationDidStart(anim: POPAnimation!) {
        
        self.waitingToStartAnimationsKeys.removeObject(anim.name)
        
        guard self.didStartBlock != nil else {
            return
        }
        
        let block = self.didStartBlock
        
        if self.waitingToStartAnimationsKeys.count == 0{
            self.didStartAnimation(nil)
        }
        
        block!(node: self, key: anim.name, finished: (self.startedAnimationsKeys.count == 0), error: nil)
    }
    
    public func pop_animationDidStop(anim: POPAnimation!, finished: Bool) {
        
        self.startedAnimationsKeys.removeObject(anim.name)

        guard self.didStopBlock != nil else {
            return
        }
        
        let block = self.didStopBlock
        
        if self.startedAnimationsKeys.count == 0{
            self.didStopAnimation(nil)
        }
        
        block!(node: self, key: anim.name, finished: (self.startedAnimationsKeys.count == 0), error: nil)
    }
}

// MARK: - Cocoa Objects Animable -

extension CALayer : JDAnimationNode {}

extension UIView :  JDAnimationNode{
    
    public func animatableLayer() -> CALayer{
        return self.layer
    }
    
    public func changeAnchorPoint(x: CGFloat, y: CGFloat, delay: Double = 0) -> JDAnimationNode{
        
        self._executeAfter(delay) { () -> () in
            
            let anchorPoint = CGPoint(x: x, y: y)
            
            var newPoint = CGPointMake(self.bounds.size.width * anchorPoint.x, self.bounds.size.height * anchorPoint.y)
            var oldPoint = CGPointMake(self.bounds.size.width * self.animatableLayer().anchorPoint.x, self.bounds.size.height * self.animatableLayer().anchorPoint.y)
            
            newPoint = CGPointApplyAffineTransform(newPoint, self.transform)
            oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform)
            
            var position = self.animatableLayer().position
            position.x -= oldPoint.x
            position.x += newPoint.x
            
            position.y -= oldPoint.y
            position.y += newPoint.y
            
            self.animatableLayer().position = position
            self.animatableLayer().anchorPoint = anchorPoint
        }
        
        return self
    }
}