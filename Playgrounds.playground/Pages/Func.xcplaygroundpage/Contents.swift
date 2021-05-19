//: [Previous](@previous)

import Foundation
import CoreImage
import UIKit

var greeting = "Hello, playground"

//: [Next](@next)

typealias Filter = (CIImage) -> CIImage

func blur(radius: Double) -> Filter {
    return { image in
        let parameters: [String: Any] = [
            kCIInputRadiusKey: radius,
            kCIInputImageKey: image
        ]
        guard let filter = CIFilter(name: "CIGaussianBlur", parameters: parameters) else { fatalError() }
        guard let outputImage = filter.outputImage else { fatalError() }
        return outputImage
        
    }
}

func colorGenerator(color: UIColor) -> Filter {
    return { image in
        let c = CIColor(color: color)
        let parameters: [String: Any] = [
            kCIInputColorKey: c
        ]
        guard let filter = CIFilter(name: "CIConstantColorGenerator", parameters: parameters) else { fatalError() }
        guard let outputImage = filter.outputImage else { fatalError() }
        return outputImage.cropped(to: image.extent)
    }
}

func compositeSourceOver(overlay: CIImage) -> Filter {
    return { image in
        let parameters: [String: Any] = [
            kCIInputBackgroundImageKey: image,
            kCIInputImageKey: overlay
        ]
        guard let filter = CIFilter(name: "CISourceOverCompositing", parameters: parameters) else { fatalError() }
        guard let outputImage = filter.outputImage else { fatalError() }
        return outputImage
    }
}

func colorOverlay(color: UIColor) -> Filter {
    return { image in
        let overlay = colorGenerator(color: color)(image)
        return compositeSourceOver(overlay: overlay)(image)
    }
}

//滤镜组合生成新的滤镜
func composeFilters(filter1: @escaping Filter, filter2: @escaping Filter) -> Filter {
    { image in filter2(filter1(image)) }
}
precedencegroup CustomerPrecedence {
  /// 优先从左向右， left, right or none
  associativity: left
  higherThan: MultiplicationPrecedence//优先级，比乘法运算高
  // lowerThan: AdditionPrecedence // 优先级, 比加法运算低
  assignment: false // 是否是赋值运算
}
infix operator =>: AdditionPrecedence

func => (filter1: @escaping Filter, filter2: @escaping Filter) -> Filter {
    return { image in filter2(filter1(image)) }
}

if let image = UIImage(named: "willowtree_logo") {
//    let filter = blur(radius: 10) => colorOverlay(color: .red.withAlphaComponent(0.2))
    let filter = colorOverlay(color: .red.withAlphaComponent(0.2)) => blur(radius: 10)
    filter(CIImage(cgImage: image.cgImage!))
//    blur(radius: 10)(colorOverlay(color: .red.withAlphaComponent(0.2))(CIImage(cgImage: image.cgImage!)))
//    composeFilters(filter1: colorOverlay(color: .red.withAlphaComponent(0.2)), filter2: blur(radius: 10))(CIImage(cgImage: image.cgImage!))
}

let filter = blur(radius: 5)
if let image = UIImage(named: "img_0.jpg") {
    filter(CIImage(cgImage: image.cgImage!))
}

func add(x: Int) -> (Int) -> Int {
    return { y in x + y}
}

add(x: 2)(3)

