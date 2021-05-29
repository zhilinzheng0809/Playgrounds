//: [Previous](@previous)
import Foundation
import CoreImage
import UIKit

typealias Filter = (CIImage) -> CIImage

infix operator =>: AdditionPrecedence

func => (filter1: @escaping Filter, filter2: @escaping Filter) -> Filter {
    return { image in filter2(filter1(image)) }
}

func => (image: CIImage, filter: Filter) -> CIImage {
    return filter(image)
}

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

func tintColor(with color: UIColor) -> Filter {
    return { image in
        guard let colorMatrix = CIFilter(name: "CIColorMatrix") else { fatalError() }
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        colorMatrix.setDefaults()
        colorMatrix.setValue(image, forKey: "inputImage")
        colorMatrix.setValue(CIVector(x: r, y: 0, z: 0, w: 0), forKey: "inputRVector")
        colorMatrix.setValue(CIVector(x: 0, y: g, z: 0, w: 0), forKey: "inputGVector")
        colorMatrix.setValue(CIVector(x: 0, y: 0, z: b, w: 0), forKey: "inputBVector")
        colorMatrix.setValue(CIVector(x: 0, y: 0, z: 0, w: a), forKey: "inputAVector")
        guard let outputImage = colorMatrix.outputImage else { fatalError() }
        return outputImage
    }
}

if let image = UIImage(named: "img_0.jpg") {
    let inputImage = CIImage(cgImage: image.cgImage!)
    let outputImage = inputImage => tintColor(with: .red.withAlphaComponent(0.2))
}

if let image = UIImage(named: "img_0.jpg") {
    let filter = blur(radius: 2) => tintColor(with: .red.withAlphaComponent(0.2))
    let inputImage = CIImage(cgImage: image.cgImage!)
    let outputImage = filter(inputImage)
}

//: [Next](@next)
