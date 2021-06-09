//: [Previous](@previous)

import Foundation

var greeting = "Hello, playground"

struct Student {
    let name: String
    let scores: [科目: Int]
}
enum 科目: String, CaseIterable {
    case 语文, 数学, 英语, 物理
}

let s1 = Student(
    name: "Jane",
    scores: [.语文: 86, .数学: 92, .英语: 73, .物理: 88]
)
let s2 = Student(
    name: "Tom",
    scores: [.语文: 99, .数学: 52, .英语: 97, .物理: 36]
)
let s3 = Student(
    name: "Emma",
    scores: [.语文: 91, .数学: 92, .英语: 100, .物理: 99]
)
let students = [s1, s2, s3]
func average(_ scores: [科目: Int]) -> Double {
    return Double(scores.values.reduce(0, +)) /
        Double(科目.allCases.count)
}
print(students.map { ($0, average($0.scores)) }
    .sorted { $0.1 > $1.1 }
    .first)




//: [Next](@next)
