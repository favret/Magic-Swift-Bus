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
  
  fileprivate static func nameFor(_ event: EventBus) -> String {
    return "\(self).\(event.rawValue)"
  }

  // MARK: Post
  
  func post(_ event: EventBus, object: AnyObject? = nil) {
    Self.post(event, object: object)
  }
  
  func post(_ event: EventBus, object: AnyObject? = nil, userInfo: [String : AnyObject]? = nil) {
    Self.post(event, object: object, userInfo: userInfo)
  }
  
  static func post(_ event: EventBus, object: AnyObject? = nil, userInfo: [String : AnyObject]? = nil) {
    let name = nameFor(event)
    
    NotificationCenter.default
      .post(name: Notification.Name(rawValue: name), object: object, userInfo: userInfo)
  }
  
  // MARK: Register
  static func register(_ observer: AnyObject, events: EventBus ...,
    queue: OperationQueue = OperationQueue.main) {
    for event in events {
      register(observer, event: event, queue: queue)
    }
  }
  
  static func register(_ observer: AnyObject, event: EventBus,
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
          
          if let o = notification.object {
            obj.perform(selector, with: o)
          }
          else { obj.perform(selector) }
        })
  }
  
  // MARK: Unregister
  static func unregisterAll(_ observer: AnyObject) {
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
