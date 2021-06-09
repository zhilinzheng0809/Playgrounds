//: [Previous](@previous)

import Foundation
import JavaScriptCore

class VECore {
    
}

print("hello world")


let context: JSContext = JSContext()
let content = try String(contentsOfFile: Bundle.main.path(forResource: "transform", ofType: "js")!, encoding: .utf8)
print(content)
context.exceptionHandler = { context, exception in
    print("JS Error: \(String(describing: exception))")
}
var result: JSValue = context.evaluateScript(content)
result = context.evaluateScript("getBezierTfromX([1,2,3,4], 2)")
result = context.evaluateScript("tweenCallback1(1,2,3,4)")
let obj = context.evaluateScript("let obj = new Transform(); checkDirty(obj); obj.onStart(); obj.onSeek(2)")

//: [Next](@next)
