//: [Previous](@previous)

import Foundation

var str = "Hello, playground"

//: [Next](@next)

//if 0.1 + 0.2 == 0.3 {
//    print("equal")
//} else {
//    print(0.1 + 0.2)
//    print("not equal")
//}


struct ScoreStrut {
    var home: Int {
        willSet {
            print("xxx home")
        }
    }
    var guest: Int {
        willSet {
            print("xxx guest")
        }
    }
    
    //结构体中包含引用类型的属性
    let scoreFormatter: NumberFormatter
    
    
    //“在结构体上用 func 关键字定义的普通方法，是不能修改结构体的任何属性的。这是因为被隐式传入的 self 参数，默认是不可变的。”
    func changeGuest(guest: Int) {
        
//        self.guest = guest //不能修改
    }
    mutating func change(home: Int) {
//        self = ScoreStrut(home: 1, guest: 1) //还能对self进行修改，可以理解为默认传入的self是一个var变量，所以可以进行修改
        self.home = home
    }
    
    init(home: Int, guest: Int) {
        self.home = home
        self.guest = guest
        scoreFormatter = NumberFormatter()
        scoreFormatter.minimumIntegerDigits = 2
    }
    
    var pretty: String {
        let h = scoreFormatter.string(from: home as NSNumber)!
        let g = scoreFormatter.string(from: guest as NSNumber)!
        return "\(h) – \(g)"
    }
}

class ScoreClass {
    var home: Int
    var guest: Int
    init(home: Int, guest: Int) {
        self.home = home
        self.guest = guest
    }
}

////值类型，两者值不一样
var score = ScoreStrut(home: 0, guest: 1)
print(score.pretty)
print(CFGetRetainCount(score.scoreFormatter))
var score1 = score //score.scoreFormatter 引用计数+1 ，写时复制技术
print(CFGetRetainCount(score.scoreFormatter))
score1.scoreFormatter.minimumIntegerDigits = 3
print(score.pretty)
score.home += 1
print(score, score1)

//引用类型，两者的值是一样
var score2 = ScoreClass(home: 0, guest: 0)
var score3 = score2
score2.home += 1
print(score2.home, score3.home)

func changeClass(score: ScoreClass) {
    score.home = 10
}

func changeStruct(score: inout ScoreStrut) {
    //值类型作为参数传递到函数内部，是不可变的，不能修改它的属性，所以要用inout
    score.home = 10
}

changeClass(score: score2)
print(score2.home)

changeStruct(score: &score)
print(score.home)

let score4 = ScoreClass(home: 0, guest: 0)
var score5 = ScoreStrut(home: 0, guest: 0)
var score6 = ScoreStrut(home: 0, guest: 0)
score4.home = 10
//score5.home = 10 //无法修改
//修改一个结构体的属性这件事，在语义上是等同于对变量赋值一个新的结构体实例。
score6.home = 11

score5.change(home: 10)



//生命周期，互相引用
class Window {
    var rootView: View?
    
    deinit {
        print("dealloc window")
    }
}

class View {
    //weak 修饰的属性必须是可选的，unowned 没有这种限制,但是如果window的引用计数为0后，调用view.window,unowned会崩溃，而weak不会崩溃
    unowned var window: Window? //不会造成引用计数+1
    init(window: Window) {
        self.window = window
    }
    
    deinit {
        print("dealloc view")
    }
}

//CFGetRetainCount统计的是对象的引用个数，但是CFGetRetainCount在swift下初次创建的对象是2，这个有点奇怪，在OC下是1
var window: Window? = Window()
print(CFGetRetainCount(window))
var view: View? = View(window: window!)
window?.rootView = view
print(CFGetRetainCount(window))
print(CFGetRetainCount(view))
window = nil
//print(view?.window) //会崩溃



struct PointStruct {
    var x: Int
    var y: Int
    
    mutating func set() {
        x = 0
        y = 0
    }
}

class PointClass {
    var x: Int
    var y: Int

    init (x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

var structPoint = PointStruct(x: 1, y: 2)

func setStructToOrigin( point: inout PointStruct) -> PointStruct {
    point.set()
    return point
}

//函数参数会默认加个let来防止内部修改，所以结构体是不能修改自身，也不能修改属性，但是类是可以修改属性，但是不能修改自身
let struct1 = setStructToOrigin(point: &structPoint)
print(struct1.x, structPoint.x)

func setClassToOrigin(point: PointClass) -> PointClass {
    point.x = 0
    point.y = 0
    return point
}

let point = PointClass(x: 10, y: 20)
let point1 = setClassToOrigin(point: point)
print(point.x, point1.x)
