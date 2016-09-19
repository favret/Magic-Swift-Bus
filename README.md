# Bus
Use NotificationCenter with EventBus style

## Synopsis
- Implement publish-subscribe communication between object easily.
- Don't loose time with crash due to missing character, use enum instead.
- don't use NSNotification as parameters of your methods, define the real param directly.
- Define all your communication in a protocol.

[inspired By](https://medium.com/swift-programming/swift-nsnotificationcenter-protocol-c527e67d93a1#.5zinv4kr6)

## How to use
1. Download `Bus.Swift`
2. Implement a Protocol who define event methods.
3. Create Class that inherit Bus protocol.

You can find an exemple in `main.swift`

## Installation
1. Download `Bus.Swift`

## Exemple

1. Create your protocol
```
@objc protocol MyEvent {
  func testSuccess(str:String)
}
```

2. create a class who inherit `Bus`
You also have to map your event with the associated method
```
class MyBus: Bus {
  enum EventBus: String, EventBusType{
    case Test
    
    var notification: Selector {
      switch self {
      case .Test: return #selector(MyEvent.testSuccess(_:))
      }
    }
  }
}
```
3. In your receiver, can be ViewController, nsobject or something else, implement all methods that you want to receive 
```
extension MyReceiver: MyEvent {
  
  func testSuccess(str: String) {
    print(str)
  }

}
```

Finally, you can fire an event like that :
```
MyBus.post(.Test, object: "bonjour")
```

Don't forget to register and unregister your class : 
```
MyBus.register(self, event: .Test)
...
MyBus.unregisterAll(self)
```

