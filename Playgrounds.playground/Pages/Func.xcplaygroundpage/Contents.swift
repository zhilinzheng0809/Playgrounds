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
    return { _ in
        let c = CIColor(color: color)
        let parameters: [String: Any] = [
            kCIInputColorKey: c
        ]
        guard let filter = CIFilter(name: "CIConstantColorGenerator", parameters: parameters) else { fatalError() }
        guard let outputImage = filter.outputImage else { fatalError() }
        return outputImage
    }
}

if let image = UIImage(named: "img_0.jpg") {
    colorGenerator(color: .red)(CIImage(cgImage: image.cgImage!))
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
        return colorGenerator(color: color)(image)
//        let overlay = colorGenerator(color: color)(image)
//        return compositeSourceOver(overlay: overlay)(image)
    }
}

if let image = UIImage(named: "willowtree_logo") {
//    let outputImage = CIImage(cgImage: image.cgImage!)
//    let outputImage = colorOverlay(color: .red)(CIImage(cgImage: image.cgImage!))
    let outputImage = colorOverlay(color: .red)(CIImage(cgImage: image.cgImage!))
}

let filter = blur(radius: 5)
if let image = UIImage(named: "img_0.jpg") {
    let outputImage = filter(CIImage(cgImage: image.cgImage!))
}

func add(x: Int) -> (Int) -> Int {
    return { y in x + y}
}

add(x: 2)(3)
