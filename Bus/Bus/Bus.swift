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
  "performSelector:",
  "performSelector:withObject:",
  "performSelector:withObject:withObject:",
  "performSelector:withObject:afterDelay:inModes:",
  "performSelector:withObject:afterDelay:",
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

@objc protocol Event: AnyObject {
  
  func getNotifications() -> [String]
}

/*extension Event where Self:NSObject {
  
  /*func getNotifications() -> [Selector] {
   return [
   #selector(GameEventBus.playerWin(_:)),
   #selector(GameEventBus.playerWinRound(_:)),
   #selector(GameEventBus.selectCardSuccess(_:)),
   #selector(GameEventBus.unselectCardSuccess(_:))
   ]
   }*/
  
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
*/

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
              //Bus.invoke(selector, on:obj, afterDelay:0.3)
            }
            else {
              obj.🚀performSelector(selector)
              
              //Bus.invoke(selector, on:obj, afterDelay:0.3)
            }
          }
          /*let method = class_getInstanceMethod(GameEventBus.self, selector)
           class_replaceMethod(
           NSObject.self,
           sel,
           method_getImplementation(method),
           method_getTypeEncoding(method)
           )*/
          
          
          })
      //.addObserver(self, selector: sel, name: sel.description, object: nil)
    }
    
  }
  
}
