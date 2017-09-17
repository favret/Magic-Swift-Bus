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
  
  private static func nameFor(_ event: EventBus) -> String {
    return "\(self).\(event.rawValue)"
  }
  
  // MARK: Post
  
  static func post(event: EventBus, object: AnyObject? = nil, with arg1: Any? = nil, with arg2: Any? = nil) {
    let name = nameFor(event)
    var userInfo: [AnyHashable: Any] = [:]
    
    if let arg1 = arg1 {
      userInfo["arg1"] = arg1
    }
    if let arg2 = arg2 {
      userInfo["arg2"] = arg2
    }
    
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: object, userInfo: userInfo)
  }
  
  // MARK: Post on Thread
  static func post(on queue:DispatchQueue = DispatchQueue.global(qos: .background), event: EventBus, object: AnyObject? = nil, with arg1: Any? = nil, arg2: Any? = nil, async:Bool = true) {
    if async {
      queue.async {
        Self.post(event: event, object: object, with: arg1, with: arg2)
      }
    }
    else {
      queue.sync {
        Self.post(event: event, object: object, with: arg1, with: arg2)
      }
    }
    
  }
  
  static func postOnMainThread(event: EventBus, object: AnyObject? = nil, with arg1: Any? = nil, arg2: Any? = nil, async:Bool = true) {
    Self.post(on: DispatchQueue.main, event: event, object: object, with: arg1, arg2: arg2, async: async)
  }
  
  static func postOnBackgroundThread(event: EventBus, object: AnyObject? = nil, with arg1: Any? = nil, arg2: Any? = nil, async:Bool = true) {
     Self.post(on: DispatchQueue.global(qos: .background), event: event, object: object, with: arg1, arg2: arg2, async: async)
  }
  
  // MARK: Register
  static func register(observer: AnyObject, events: EventBus ...,
    queue: OperationQueue = OperationQueue.main) {
    for event in events {
      register(observer: observer, event: event, queue: queue)
    }
  }
  
  static func register(observer: AnyObject, event: EventBus,
                       queue: OperationQueue = OperationQueue.main) {
    let name = nameFor(event)
    
    NotificationCenter.default
      .addObserver(
        forName: NSNotification.Name(rawValue: name),
        object: nil,
        queue: queue,
        using: { [weak observer](notification) in
          guard let obj = observer as? NSObject
            else { return }
          
          let selector = event.notification
          if let userInfo = notification.userInfo {
            let arg1 = userInfo["arg1"]
            let arg2 = userInfo["arg2"]
            if (arg1 != nil) && (arg2 != nil) {
              obj.perform(selector, with: arg1, with: arg2)
            } else if (arg1 != nil) || (arg2 != nil) {
              obj.perform(selector, with: (arg1 != nil ? arg1 : arg2) as Any)
            } else {
              obj.perform(selector)
            }
          }
          else { obj.perform(selector) }
      })
  }
  
  // MARK: Unregister
  static func unregisterAll(observer: AnyObject) {
    NotificationCenter.default.removeObserver(observer)
  }
  
  static func unregister(_ observer: AnyObject, events: EventBus ...) {
    for event in events {
      unregister(observer, event: event)
    }
  }
  
  static func unregister(_ observer: AnyObject, event: EventBus, object: AnyObject? = nil) {
    let name = nameFor(event)
    
    NotificationCenter.default
      .removeObserver(observer, name: NSNotification.Name(rawValue: name), object: object)
  }
}
