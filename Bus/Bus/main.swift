//
//  main.swift
//  Bus
//
//  Created by favre on 19/07/2016.
//  Copyright © 2016 favre. All rights reserved.
//

import Foundation

print("Hello, World!")

@objc protocol TestEventBus: Event {
  
  func test(notification:String)
}


class Test :NSObject, TestEventBus {
  
  @objc func getNotifications() -> [String] {
    return [
      (#selector(TestEventBus.test(_:))).description
    ]
  }
  
  @objc func test(notification:String) {
    print(notification)
  }
}

let t = Test()

Bus.register(t)


NSNotificationCenter.defaultCenter()
  .postNotificationName(
    (#selector(TestEventBus.test(_:))).description,
    object: "bonjour",
    userInfo: nil)

