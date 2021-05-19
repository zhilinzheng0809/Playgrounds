//: [Previous](@previous)

import Foundation

//: [Next](@next)

extension Array {
    func map<T>(transform: (Element) -> T) -> [T] {
        var result: [T] = []
        for element in self {
            result.append(transform(element))
        }
        return result
    }
    
    func filter(isIncluded: (Element) -> Bool) -> [Element] {
        var result: [Element] = []
        for element in self {
            if isIncluded(element) {
                result.append(element)
            }
        }
        return result
    }
    
    func reduce<T>(_ initial: T, _ combine: (T, Element) -> T) -> T {
        var result = initial
        for element in self {
            result = combine(result, element)
        }
        return result
    }
    
    //使用reduce来实现map
    func map1<T>(transform: (Element) -> T) -> [T] {
        return reduce([]) { result, element in
            result + [transform(element)]
        }
    }
    
    //使用reduce来实现filter
    func filter1(isIncluded: (Element) -> Bool) -> [Element] {
        return reduce([]) { result, element in
            isIncluded(element) ? result + [element] : result
        }
    }
}

let result = [1, 2].map1 { String($0) + "hello" }
print(result)

let exampleFiles = ["README.md", "HelloWorld.swift", "FlappyBird.swift"]

let filter = exampleFiles.filter1 { $0.hasSuffix(".swift")}
print(filter)


[1, 2, 3, 4].reduce(10, +)


func flatten<T>(xss: [[T]]) -> [T] {
    var result: [T] = []
    for xs in xss {
        //数组拼接
        result += xs
    }
    return result
}

flatten(xss: [[1,2],[4,5],[5,7]])

//两个数组拼接
[[1,2,3],[4,5,6]].reduce([], +)

struct City {
    let name: String
    let population: Int
}

extension City {
    func cityByScalingPopulation() -> City {
        return City(name: name, population: population * 1000)
    }
}

let paris = City(name: "Paris", population: 2241)
let madrid = City(name: "Madrid", population: 3165)
let amsterdam = City(name: "Amsterdam", population: 827)
let berlin = City(name: "Berlin", population: 3562)

let cities = [paris, madrid, amsterdam, berlin]

//假设我们现在想筛选出居⺠数量⾄少⼀百万的城市，并打印⼀份这些城市的名字及总⼈⼝数的 列表。
cities.filter { $0.population > 1000 }
    .map { $0.cityByScalingPopulation() }
    .reduce("City: Population") { result, city in
        return result + "\n" + " \(city.name): \(city.population)"
    }


//泛型可以⽤于定义灵活的函数，类型检查仍然由编译器负责；⽽ Any 类型则 可以避开 Swift 的类型系统 (所以应该尽可能避免使⽤)。
