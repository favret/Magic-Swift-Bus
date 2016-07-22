//
//  Notifier.swift
//  Bus
//
//  Created by favre on 19/07/2016.
//  Copyright © 2016 favre. All rights reserved.
//

import Foundation

public protocol NotificationType: RawRepresentable {
  var notification: Selector { get }
}

public protocol Notifier {
  associatedtype Notification: NotificationType
}

public extension Notifier where Notification.RawValue == String {
  
  private static func nameFor(notification: Notification) -> String {
    return "\(self).\(notification.rawValue)"
  }

  // MARK: Post
  
  func post(notification: Notification, object: AnyObject? = nil) {
    Self.post(notification, object: object)
  }
  
  func post(notification: Notification, object: AnyObject? = nil, userInfo: [String : AnyObject]? = nil) {
    Self.post(notification, object: object, userInfo: userInfo)
  }
  
  static func post(notification: Notification, object: AnyObject? = nil, userInfo: [String : AnyObject]? = nil) {
    let name = nameFor(notification)
    
    NSNotificationCenter.defaultCenter()
      .postNotificationName(name, object: object, userInfo: userInfo)
  }
  
  // MARK: Register
  static func register(observer: AnyObject, events: Notification ...,
    queue: NSOperationQueue = NSOperationQueue.mainQueue()) {
    for event in events {
      register(observer, event: event, queue: queue)
    }
  }
  
  static func register(observer: AnyObject, event: Notification,
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
  static func unregister(observer: AnyObject) {
    NSNotificationCenter.defaultCenter().removeObserver(observer)
  }
  
  static func unregister(observer: AnyObject, events: Notification ...) {
    for event in events {
      unregister(observer, event: event)
    }
  }
  
  static func unregister(observer: AnyObject, event: Notification, object: AnyObject? = nil) {
    let name = nameFor(event)
    
    NSNotificationCenter.defaultCenter()
      .removeObserver(observer, name: name, object: object)
  }
}