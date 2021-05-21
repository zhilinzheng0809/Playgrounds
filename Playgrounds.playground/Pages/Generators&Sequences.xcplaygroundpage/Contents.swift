//: [Previous](@previous)

import Foundation

//: [Next](@next)

protocol GeneratorType {
    associatedtype Element
    func next() -> Element?
}

class CountdownGenerator: GeneratorType {
    typealias Element = Int
    var element: Int
    init<T>(array: [T]) {
        self.element = array.count
    }
    
    func next() -> Int? {
        if element <= 0 {
            return nil
        }
        element -= 1
        return element
    }
}

let xs = ["A", "B", "C"]

let generator = CountdownGenerator(array: xs)
while let i = generator.next() {
    print("Element \(i) of the array is \(xs[i])" )
}

