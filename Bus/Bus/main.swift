//
//  main.swift
//  Bus
//
//  Created by favre on 19/07/2016.
//  Copyright © 2016 favre. All rights reserved.
//

import Foundation

@objc protocol MyEvent {
  
  func test(_ str:String)
}

class MyBus: Bus {
  enum EventBus: String, EventBusType{
    case Test
    
    var notification: Selector {
      switch self {
      case .Test: return #selector(MyEvent.test(_:))
      }
    }
  }
}

class Test :NSObject, MyEvent {
  
  func test(_ str: String) {
    print(str)
  }

}

let t = Test()

MyBus.register(t, event: .Test)

MyBus.post(.Test, object: "bonjour")

MyBus.unregister(t, event: .Test)

