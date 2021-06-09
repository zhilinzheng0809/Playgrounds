//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

//: [Next](@next)


@propertyWrapper
struct SmallNumber {
    private var number: Int
    private var maximum: Int
    var wrappedValue: Int {
        get { return number }
        set { number = min(newValue, maximum) }
    }
    
    init() {
        maximum = 12
        number = 0
    }
    
    init(wrappedValue: Int) {
        maximum = 12
        number = min(wrappedValue, maximum)
    }
    
    init(wrappedValue: Int, maximum: Int) {
        self.maximum = maximum
        number = min(wrappedValue, maximum)
    }
}

struct ZeroRectangle {
    @SmallNumber(wrappedValue: 10) var height: Int
    @SmallNumber var width: Int //会调用init()进行初始化
}

struct UnitRectangle {
    @SmallNumber var height: Int = 1    //会调用init(wrappedValue: Int)进行初始化
    @SmallNumber var width: Int = 1
}


var zeroRect = ZeroRectangle()
print(zeroRect.height, zeroRect.width)
