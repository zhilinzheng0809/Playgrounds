//: [Previous](@previous)

import Foundation
import CoreImage

var greeting = "Hello, playground"

CIFilter.localizedName(forCategory: kCICategoryHalftoneEffect)
CIFilter.filterNames(inCategory: kCICategoryHalftoneEffect)


CIFilter.filterNames(inCategory: nil).count
CIFilter.filterNames(inCategories: [kCICategoryBlur, kCICategorySharpen])
CIFilter.localizedReferenceDocumentation(forFilterName: "CICMYKHalftone")

let filter = CIFilter(name: "CICMYKHalftone")
filter?.inputKeys
filter?.attributes
//: [Next](@next)

