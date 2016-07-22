//
//  main.swift
//  Bus
//
//  Created by favre on 19/07/2016.
//  Copyright © 2016 favre. All rights reserved.
//

import Foundation

@objc protocol TestEventBus {
  func test(str:String)
  
}

class MyNotif : Bus {
  enum EventBus : String, EventBusType {
    case coffeeMade
  
    var notification:Selector {
      switch self {
      case .coffeeMade: return #selector(TestEventBus.test(_:))
      }
    }
  }  
}

class Test :NSObject, TestEventBus {
  
  @objc func test(str:String) {
    print(str)
  }
}

let t = Test()

//register
//MyNotif.register(t, event: .coffeMade)
MyNotif.register(t, event: .coffeeMade)

//post event
MyNotif.post(.coffeeMade, object: "bonjour")

//unregister
//MyNotif.unregister(t)
MyNotif.unregister(t, event: .coffeeMade)

