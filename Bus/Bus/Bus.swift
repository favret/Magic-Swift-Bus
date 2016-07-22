//
//  Notifier.swift
//  Bus
//
//  Created by favre on 19/07/2016.
//  Copyright © 2016 favre. All rights reserved.
//

import Foundation

public protocol EventBusType: RawRepresentable {
  var notification: Selector { get }
}

public protocol Bus {
  associatedtype EventBus: EventBusType
}

public extension Bus where EventBus.RawValue == String {
  
  private static func nameFor(event: EventBus) -> String {
    return "\(self).\(event.rawValue)"
  }

  // MARK: Post
  
  func post(event: EventBus, object: AnyObject? = nil) {
    Self.post(event, object: object)
  }
  
  func post(event: EventBus, object: AnyObject? = nil, userInfo: [String : AnyObject]? = nil) {
    Self.post(event, object: object, userInfo: userInfo)
  }
  
  static func post(event: EventBus, object: AnyObject? = nil, userInfo: [String : AnyObject]? = nil) {
    let name = nameFor(event)
    
    NSNotificationCenter.defaultCenter()
      .postNotificationName(name, object: object, userInfo: userInfo)
  }
  
  // MARK: Register
  static func register(observer: AnyObject, events: EventBus ...,
    queue: NSOperationQueue = NSOperationQueue.mainQueue()) {
    for event in events {
      register(observer, event: event, queue: queue)
    }
  }
  
  static func register(observer: AnyObject, event: EventBus,
                       queue: NSOperationQueue = NSOperationQueue.mainQueue()) {
    let name = nameFor(event)
    
    NSNotificationCenter.defaultCenter()
      .addObserverForName(
        name,
        object: nil,
        queue: queue,
        usingBlock: { [weak observer](notification) in
          guard let obj = observer as? NSObject
            else { return }
          
          let selector = event.notification
          
          if let o = notification.object {
            obj.performSelector(selector, withObject: o)
          }
          else { obj.performSelector(selector) }
        })
  }
  
  // MARK: Unregister
  static func unregisterAll(observer: AnyObject) {
    NSNotificationCenter.defaultCenter().removeObserver(observer)
  }
  
  static func unregister(observer: AnyObject, events: EventBus ...) {
    for event in events {
      unregister(observer, event: event)
    }
  }
  
  static func unregister(observer: AnyObject, event: EventBus, object: AnyObject? = nil) {
    let name = nameFor(event)
    
    NSNotificationCenter.defaultCenter()
      .removeObserver(observer, name: name, object: object)
  }
}