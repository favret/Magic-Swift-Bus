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

![Bus Demo](./Bus-presentation.gif)

## Some methods

`func register(observer: AnyObject, event: EventBus ..., queue: NSOperationQueue = NSOperationQueue.mainQueue()) `

`func post(event: EventBus, object: AnyObject? = nil)`

`func unregister(observer: AnyObject, events: EventBus ...)`
