//
//  Bus.swift
//  Bus
//
//  Created by favre on 19/07/2016.
//  Copyright © 2016 favre. All rights reserved.
//

import Foundation

private var dispatchOnceToken: dispatch_once_t = 0

private var selectors: [Selector] = [
  #selector(NSObjectProtocol.performSelector(_:)),
  #selector(NSObjectProtocol.performSelector(_:withObject:)),
  #selector(NSObjectProtocol.performSelector(_:withObject:withObject:)),
  #selector(NSObject.performSelector(_:withObject:afterDelay:inModes:)),
  #selector(NSObject.performSelector(_:withObject:afterDelay:)),
]

private func swizzle() {
  dispatch_once(&dispatchOnceToken) {
    for selector: Selector in selectors {
      let 🚀selector = Selector("🚀\(selector)")
      let method = class_getInstanceMethod(NSObject.self, selector)
      
      class_replaceMethod(
        NSObject.self,
        🚀selector,
        method_getImplementation(method),
        method_getTypeEncoding(method)
      )
    }
  }
}

extension NSObject {
  
  func 🚀performSelector(selector: Selector) -> AnyObject? {
    swizzle()
    return self.🚀performSelector(selector)
  }
  
  func 🚀performSelector(selector: Selector, withObject object: AnyObject?) -> AnyObject? {
    swizzle()
    return self.🚀performSelector(selector, withObject: object)
  }
  
  func 🚀performSelector(selector: Selector, withObject object1: AnyObject?, withObject object2: AnyObject?) -> AnyObject? {
    swizzle()
    return self.🚀performSelector(selector, withObject: object1, withObject: object2)
  }
  
  func 🚀performSelector(selector: Selector, withObject object: AnyObject?, afterDelay delay: NSTimeInterval, inModes modes: [AnyObject?]?) {
    swizzle()
    self.🚀performSelector(selector, withObject: object, afterDelay: delay, inModes: modes)
  }
  
  func 🚀performSelector(selector: Selector, withObject object: AnyObject?, afterDelay delay: NSTimeInterval) {
    swizzle()
    self.🚀performSelector(selector, withObject: object, afterDelay: delay)
  }
  
}

/*
@objc protocol Event: AnyObject {
  
  func getNotifications() -> [String]
}

public class Bus {
  
  static func invoke( selector:Selector, on target:Event, afterDelay delay:NSTimeInterval ) {

    NSTimer.scheduledTimerWithTimeInterval( delay, target: target, selector: selector, userInfo: nil, repeats: false )
  }
  
  static func register<T where T: Event>(object: T) {
    
    for sel in object.getNotifications() {
      NSNotificationCenter
        .defaultCenter()
        //.addObserver(self, selector: sel, name: sel.description, object: nil)
        .addObserverForName(sel, object: nil, queue:  NSOperationQueue.mainQueue(), usingBlock: { [weak object](notification) in
          let selector = Selector(notification.name)
          
          if let obj = object as? NSObject{
            if let o = notification.object {
              obj.🚀performSelector(selector, withObject: o)
            }
            else {
              obj.🚀performSelector(selector)
              
            }
          }
         
          })
    }
    
  }
  
}*/
