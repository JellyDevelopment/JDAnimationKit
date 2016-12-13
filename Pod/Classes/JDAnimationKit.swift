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
    case linear
    case easeIn
    case easeOut
    case easeInOut
    case none
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

public typealias JDLayerAnimationStartBlock = (_ node: JDAnimationNode?, _ key: String?, _ finished: Bool?, _ error: NSError?) -> Void

class ClosureLayerWrapper {
    var closure: JDLayerAnimationStartBlock!
    
    init(_ closure: JDLayerAnimationStartBlock!) {
        self.closure = closure
    }
}

// MARK: - Addons -

extension Array where Element: Equatable {
    
    mutating func removeObject(_ object: Element) {
        if let index = self.index(of: object) {
            self.remove(at: index)
        }
    }
    
    mutating func removeObjectsInArray(_ array: [Element]) {
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
    
    @discardableResult func didStartAnimation(_ startBlock: JDLayerAnimationStartBlock?) -> JDAnimationNode
    @discardableResult func didStopAnimation(_ stopBlock: JDLayerAnimationStartBlock?) -> JDAnimationNode
    
    func makeGenericAnimation(_ property: String, toValue: AnyObject, duration: Double, delay: Double, spring: Bool, springConfig: JDSpringConfig, key: String, timing: JDTimingFunction) -> POPAnimation
    
    func makeChangeBounds(_ bounds: CGRect, duration: Double, spring: Bool, springConfig: JDSpringConfig, delay: Double, key: String, timing: JDTimingFunction) -> POPAnimation
    func changeBounds(_ bounds: CGRect, duration: Double, spring: Bool, springConfig: JDSpringConfig, delay: Double, key: String, timing: JDTimingFunction) -> JDAnimationNode
    
    func makeScaleTo(_ scaleX: CGFloat, scaleY: CGFloat, duration: Double, spring: Bool, springConfig: JDSpringConfig, delay: Double , key: String, timing: JDTimingFunction) -> POPAnimation
    func scaleXTo(_ scaleX: CGFloat, duration: Double , spring: Bool, springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> JDAnimationNode
    func scaleYTo(_ scaleY: CGFloat, duration: Double , spring: Bool, springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> JDAnimationNode
    func scaleTo(_ scaleX: CGFloat, scaleY: CGFloat, duration: Double , spring: Bool, springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> JDAnimationNode
    
    func makeRotateTo(_ angle: Double, duration: Double , spring: Bool, springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> POPAnimation
    func rotateTo(_ angle: Double, duration: Double , spring: Bool, springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> JDAnimationNode
    
    func makeChangeBgColor(_ color: UIColor, duration: Double, spring: Bool, springConfig: JDSpringConfig, delay: Double, key: String, timing: JDTimingFunction) -> POPAnimation
    
    func changeBgColor(_ color: UIColor, duration: Double, spring: Bool, springConfig: JDSpringConfig, delay: Double, key: String, timing: JDTimingFunction) -> JDAnimationNode
    
    func makeOpacity(_ alpha: Double, duration: Double , spring: Bool, springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> POPAnimation
    func opacityTo(_ alpha: Double, duration: Double , spring: Bool, springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> JDAnimationNode
    
    func changeAnchorPoint(_ x: CGFloat, y: CGFloat, delay: Double) -> JDAnimationNode
    
    func moveXTo(_ x: CGFloat, duration: Double , spring: Bool, springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> JDAnimationNode
    func moveYTo(_ y: CGFloat, duration: Double , spring: Bool, springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> JDAnimationNode
    func moveTo(_ x: CGFloat, y: CGFloat, duration: Double , spring: Bool, springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> JDAnimationNode
    
    func moveXBy(_ deltaX: CGFloat, duration: Double , spring: Bool , springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> JDAnimationNode
    func moveYBy(_ deltaY: CGFloat, duration: Double , spring: Bool , springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> JDAnimationNode
    func moveBy(_ deltaX: CGFloat, deltaY: CGFloat, duration: Double , spring: Bool , springConfig: JDSpringConfig , delay: Double , key: String, timing: JDTimingFunction) -> JDAnimationNode
    func makeMoveBy(_ deltaX: CGFloat, deltaY: CGFloat, duration: Double , delay: Double , spring: Bool , springConfig: JDSpringConfig , key: String, timing: JDTimingFunction) -> POPAnimation
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
    
    public func makeGenericAnimation(_ property: String, toValue: AnyObject, duration: Double, delay: Double = 0, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), key: String, timing: JDTimingFunction) -> POPAnimation {
        
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
            animation?.duration = duration
            animation?.toValue = toValue
            animation?.beginTime = (CACurrentMediaTime() + delay)
            animation?.delegate = self.animatableLayer()
            animation?.name = key
            animation?.timingFunction = self._timingFunctionKey(timing)
            
            return animation!
        }
    }
    
    public func animatableLayer() -> CALayer{
        return self as! CALayer
    }
    
    // MARK: Private
    
    internal func _timingFunctionKey(_ timing: JDTimingFunction) -> CAMediaTimingFunction{
        
        switch timing{
            
        case .easeIn:
            return CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseIn)
        case .easeOut:
            return CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
        case .easeInOut:
            return CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        case .linear:
            return CAMediaTimingFunction(name:kCAMediaTimingFunctionLinear)
        case .none:
            return CAMediaTimingFunction(name:kCAMediaTimingFunctionDefault)
        }
    }
    
    internal func _executeAfter(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure
        )
    }
    
    @discardableResult internal func _addAnimation(_ animation: POPAnimation, key: String) -> JDAnimationNode{
        
        self.waitingToStartAnimationsKeys.append(key)
        self.startedAnimationsKeys.append(key)
        
        self.animatableLayer().pop_add(animation, forKey: key)
        
        return self
    }
    
    // MARK: Change Bounds
    
    public func makeChangeBounds(_ bounds: CGRect, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "changeBound", timing: JDTimingFunction = .none) -> POPAnimation {
        
        return self.makeGenericAnimation(kPOPLayerBounds, toValue: NSValue(cgRect: bounds), duration: duration, delay: delay, spring: spring, springConfig: springConfig, key: key, timing: timing)
    }
    
    public func changeBounds(_ bounds: CGRect, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "changeBound", timing: JDTimingFunction = .none) -> JDAnimationNode {
        
        let frameAnimation = makeChangeBounds(bounds, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
        
        self._addAnimation(frameAnimation, key: frameAnimation.name)
        
        return self
    }
    
    // MARK: ScaleTo
    
    public func makeScaleTo(_ scaleX: CGFloat, scaleY: CGFloat, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "scaleTo", timing: JDTimingFunction = .none) -> POPAnimation {
        
        return self.makeGenericAnimation(kPOPLayerScaleXY, toValue: NSValue(cgPoint: CGPoint(x: scaleX, y: scaleY)), duration: duration, delay: delay, spring: spring, springConfig: springConfig, key: key, timing: timing)
    }
    
    public func scaleXTo(_ scaleX: CGFloat, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "scaleXTo", timing: JDTimingFunction = .none) -> JDAnimationNode {
        
        return self.scaleTo(scaleX, scaleY: 1, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
    }
    
    public func scaleYTo(_ scaleY: CGFloat, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "scaleYTo", timing: JDTimingFunction = .none) -> JDAnimationNode {
        
        return self.scaleTo(1, scaleY: scaleY, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
    }
    
    public func scaleTo(_ scaleX: CGFloat, scaleY: CGFloat,duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "scaleTo", timing: JDTimingFunction = .none) -> JDAnimationNode {
        
        let scaleAnimation = makeScaleTo(scaleX, scaleY: scaleY, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
        
        self._addAnimation(scaleAnimation, key: scaleAnimation.name)
        
        return self
    }
    
    // MARK: RotateTo
    
    public func makeRotateTo(_ angle: Double, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "rotateTo", timing: JDTimingFunction = .none) -> POPAnimation {
        
        return self.makeGenericAnimation(kPOPLayerRotation, toValue: CGFloat(angle.DegreesToRadians()) as AnyObject, duration: duration, delay: delay, spring: spring, springConfig: springConfig, key: key, timing: timing)
    }
    
    public func rotateTo(_ angle: Double, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "rotateTo", timing: JDTimingFunction = .none) -> JDAnimationNode {
        
        let rotateAnimation = makeRotateTo(angle, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
        
        self._addAnimation(rotateAnimation, key: rotateAnimation.name)
        
        return self
    }
    
    // MARK: BackgroundColor
    
    public func makeChangeBgColor(_ color: UIColor, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "backgroundTo", timing: JDTimingFunction = .none) -> POPAnimation {
        return self.makeGenericAnimation(kPOPLayerBackgroundColor, toValue: color, duration: duration, delay: delay, spring: spring, springConfig: springConfig, key: key, timing: timing)
    }
    
    public func changeBgColor(_ color: UIColor, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "backgroundTo", timing: JDTimingFunction = .none) -> JDAnimationNode {
        
        let backgroundAnimation = makeChangeBgColor(color, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
        
        self._addAnimation(backgroundAnimation, key: backgroundAnimation.name)
        
        return self
    }
    
    // MARK: Opacity
    
    public func makeOpacity(_ alpha: Double, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "opacityTo", timing: JDTimingFunction = .none) -> POPAnimation {
        return self.makeGenericAnimation(kPOPLayerOpacity, toValue: CGFloat(alpha) as AnyObject, duration: duration, delay: delay, spring: spring, springConfig: springConfig, key: key, timing: timing)
    }
    
    public func opacityTo(_ alpha: Double, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "opacityTo", timing: JDTimingFunction = .none) -> JDAnimationNode {
        
        let alphaAnimation = makeOpacity(alpha, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
        
        self._addAnimation(alphaAnimation, key: alphaAnimation.name)
        
        return self
    }
    
    // MARK: Anchor point
    
    public func changeAnchorPoint(_ x: CGFloat, y: CGFloat, delay: Double = 0) -> JDAnimationNode{
        
        self._executeAfter(delay) { () -> () in
            
            let anchorPoint = CGPoint(x: x, y: y)
            
            var newPoint = CGPoint(x: self.animatableLayer().bounds.size.width * anchorPoint.x, y: self.animatableLayer().bounds.size.height * anchorPoint.y)
            var oldPoint = CGPoint(x: self.animatableLayer().bounds.size.width * self.animatableLayer().anchorPoint.x, y: self.animatableLayer().bounds.size.height * self.animatableLayer().anchorPoint.y)
            
            newPoint = newPoint.applying(self.animatableLayer().affineTransform())
            oldPoint = newPoint.applying(self.animatableLayer().affineTransform())
            
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
    
    public func moveXTo(_ x: CGFloat, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "moveXTo", timing: JDTimingFunction = .none) -> JDAnimationNode {
        
        return self.moveTo(x, y: self.animatableLayer().position.y, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
    }
    
    
    public func moveYTo(_ y: CGFloat, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "moveYTo", timing: JDTimingFunction = .none) -> JDAnimationNode {
        
        return self.moveTo(self.animatableLayer().position.x, y: y, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
    }
    
    public func moveTo(_ x: CGFloat, y: CGFloat, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "moveTo", timing: JDTimingFunction = .none) -> JDAnimationNode {
        
        let moveAnimation = makeMoveTo(x, y: y, duration: duration, delay: delay, spring: spring, springConfig: springConfig, key: key, timing: timing)
        
        self._addAnimation(moveAnimation, key: moveAnimation.name)
        
        return self
    }
    
    public func makeMoveTo(_ x: CGFloat, y: CGFloat, duration: Double = 0.5, delay: Double = 0, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), key: String = "moveTo", timing: JDTimingFunction = .none) -> POPAnimation {
        
        return self.makeGenericAnimation(kPOPLayerPosition, toValue: NSValue(cgPoint: CGPoint(x: x, y: y)), duration: duration, delay: delay, spring: spring, springConfig: springConfig, key: key, timing: timing)
    }
    
    // MARK: Move By
    
    public func moveXBy(_ deltaX: CGFloat, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "moveXBy", timing: JDTimingFunction = .none) -> JDAnimationNode {
        
        return self.moveBy(deltaX, deltaY: 0, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
    }
    
    
    public func moveYBy(_ deltaY: CGFloat, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "moveYBy", timing: JDTimingFunction = .none) -> JDAnimationNode {
        
        return self.moveBy(0, deltaY: deltaY, duration: duration, spring: spring, springConfig: springConfig, delay: delay, key: key, timing: timing)
    }
    
    public func moveBy(_ deltaX: CGFloat, deltaY: CGFloat, duration: Double = 0.5, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), delay: Double = 0, key: String = "moveBy", timing: JDTimingFunction = .none) -> JDAnimationNode {
        
        let moveAnimation = makeMoveBy(deltaX, deltaY: deltaY, duration: duration, delay: delay, spring: spring, springConfig: springConfig, key: key, timing: timing)
        
        self._addAnimation(moveAnimation, key: moveAnimation.name)
        
        return self
    }
    
    public func makeMoveBy(_ deltaX: CGFloat, deltaY: CGFloat, duration: Double = 0.5, delay: Double = 0, spring: Bool = false, springConfig: JDSpringConfig = .JDSpringConfigDefault(), key: String = "moveBy", timing: JDTimingFunction = .none) -> POPAnimation {
        
        var nextPosition = self.animatableLayer().position
        nextPosition.x += deltaX
        nextPosition.y += deltaY
        
        return self.makeGenericAnimation(kPOPLayerPosition, toValue: NSValue(cgPoint: nextPosition), duration: duration, delay: delay, spring: spring, springConfig: springConfig, key: key, timing: timing)
    }
    
    // MARK: Callback
    
    public func didStartAnimation(_ startBlock: JDLayerAnimationStartBlock?) -> JDAnimationNode {
        
        self.animatableLayer().didStartBlock = startBlock
        
        return self
    }
    
    public func didStopAnimation(_ stopBlock: JDLayerAnimationStartBlock?) -> JDAnimationNode {
        
        self.animatableLayer().didStopBlock = stopBlock
        
        return self
    }
}

// MARK: - POPAnimation Delegate -

extension CALayer : POPAnimationDelegate {
    
    public func pop_animationDidStart(_ anim: POPAnimation!) {
        
        self.waitingToStartAnimationsKeys.removeObject(anim.name)
        
        guard self.didStartBlock != nil else {
            return
        }
        
        let block = self.didStartBlock
        
        if self.waitingToStartAnimationsKeys.count == 0{
            self.didStartAnimation(nil)
        }
        
        block!(self, anim.name, (self.startedAnimationsKeys.count == 0), nil)
    }
    
    public func pop_animationDidStop(_ anim: POPAnimation!, finished: Bool) {
        
        self.startedAnimationsKeys.removeObject(anim.name)

        guard self.didStopBlock != nil else {
            return
        }
        
        let block = self.didStopBlock
        
        if self.startedAnimationsKeys.count == 0{
            self.didStopAnimation(nil)
        }
        
        block!(self, anim.name, (self.startedAnimationsKeys.count == 0), nil)
    }
}

// MARK: - Cocoa Objects Animable -

extension CALayer : JDAnimationNode {}

extension UIView :  JDAnimationNode{
    
    public func animatableLayer() -> CALayer{
        return self.layer
    }
    
    public func changeAnchorPoint(_ x: CGFloat, y: CGFloat, delay: Double = 0) -> JDAnimationNode{
        
        self._executeAfter(delay) { () -> () in
            
            let anchorPoint = CGPoint(x: x, y: y)
            
            var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
            var oldPoint = CGPoint(x: self.bounds.size.width * self.animatableLayer().anchorPoint.x, y: self.bounds.size.height * self.animatableLayer().anchorPoint.y)
            
            newPoint = newPoint.applying(self.transform)
            oldPoint = oldPoint.applying(self.transform)
            
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
