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


//构建UserDefault属性包裹器

@propertyWrapper
struct UserDefaultWrapper<Value> {
    let userDefault = UserDefaults.standard
    let key: String
    let defaultValue: Value
    //实现这个后，可以使用$来访问额外呈现的值
    var projectedValue: String {
        return String(describing: "The value: \(wrappedValue)")
    }
    var wrappedValue: Value {
        get {
            return userDefault.value(forKey: key) as? Value ?? defaultValue
        }
        set {
            userDefault.setValue(newValue, forKey: key)
        }
    }
    
    var projectValue: String {
        return String(describing: "The value: \(defaultValue)")
    }
    
    init(defaultValue: Value) {
        self.defaultValue = defaultValue
        self.key = UUID().uuidString
    }
    
    init(key: String, defaultValue: Value) {
        self.defaultValue = defaultValue
        self.key = key
    }
}

struct User {
    @UserDefaultWrapper(key: "name", defaultValue: "") var name: String
    @UserDefaultWrapper(key: "pwd", defaultValue: nil) var pwd: String?
    
    @UserDefaultWrapper(defaultValue: nil) public var pwd1: String?
}

var user = User()
user.pwd
user.pwd
user.pwd = "xxxx"
user.$pwd
user.pwd

@propertyWrapper
struct SmallNumber1 {
    private var number: Int
    var projectedValue: Bool
    init() {
        self.number = 0
        self.projectedValue = false
    }
    var wrappedValue: Int {
        get { return number }
        set {
            if newValue > 12 {
                number = 12
                projectedValue = true
            } else {
                number = newValue
                projectedValue = false
            }
        }
    }
}
struct SomeStructure {
    @SmallNumber1 var someNumber: Int
}
var someStructure = SomeStructure()

someStructure.someNumber = 4
print(someStructure.$someNumber)
// 打印 "false"

someStructure.someNumber = 55
print(someStructure.$someNumber)
// 打印 "true"
