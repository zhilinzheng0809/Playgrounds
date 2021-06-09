//: [Previous](@previous)

import Foundation
import CoreImage
import UIKit

class BlueGreenFilter: CIFilter
{
    @objc var inputImage: CIImage?
    @objc var inputBackgroundImage: CIImage?
    
    var extent: CGRect?
    
    var kernel = CIColorKernel(source:
        "kernel vec4 thresholdFilter(__sample image)" +
        "{" +
        "   return vec4(0.0, image.g * 0.5, image.b, image.a);" +
        "}"
    )
    
    override var outputImage: CIImage!
    {
        guard let inputImage = inputImage, let kernel = kernel else
        {
            return nil
        }
        
        let extent = self.extent ?? inputImage.extent
        
        let arguments = [inputImage]
        
        return kernel.apply(extent: extent,
            arguments: arguments)
    }
}

class CRTWarpFilter: CIFilter
{
    @objc var inputImage : CIImage?
    var bend: CGFloat = 3.2
    let crtWarpKernel = CIWarpKernel(source:
        "kernel vec2 crtWarp(vec2 extent, float bend)" +
            "{" +
            "   vec2 coord = ((destCoord() / extent) - 0.5) * 2.0;" +
            "   coord.x *= 1.0 + pow((abs(coord.y) / bend), 2.0);" +
            "   coord.y *= 1.0 + pow((abs(coord.x) / bend), 2.0);" +
            "   coord  = ((coord / 2.0) + 0.5) * extent;" +
            "   return coord;" +
        "}"
    )

    override var outputImage : CIImage!
        {
            if let inputImage = inputImage,let crtWarpKernel = crtWarpKernel
            {
                let arguments = [CIVector(x: inputImage.extent.size.width, y: inputImage.extent.size.height), bend] as [Any]
                let extent = inputImage.extent

                return crtWarpKernel.apply(extent: extent,
                                           roiCallback:
                                            {
                                                (index, rect) in
                                                return rect
                                            },
                                           image: inputImage,
                    arguments: arguments)
            }
            return nil
    }
}

class CustomFiltersVendor: NSObject, CIFilterConstructor
{
    static func registerFilters() {
        CIFilter.registerName(
            "CRTWarpFilter",
            constructor: CustomFiltersVendor(),
            classAttributes: [
                kCIAttributeFilterCategories: ["CustomFilters"]
            ])
        CIFilter.registerName(
            "BlueGreenFilter",
            constructor: CustomFiltersVendor(),
            classAttributes: [
                kCIAttributeFilterCategories: ["CustomFilters"]
            ])
    }
    
    func filter(withName name: String) -> CIFilter? {
        switch name {
        case "CRTWarpFilter":
            return CRTWarpFilter()
        case "BlueGreenFilter":
            return BlueGreenFilter()
        default:
            return nil
        }
    }
}

CustomFiltersVendor.registerFilters()
    
let customFilter = CIFilter(name: "BlueGreenFilter")

let carMascot = CIImage(image: UIImage(named: "carmascot.jpg")!)!
let filter = CIFilter(name: "BlueGreenFilter") as! BlueGreenFilter
filter.inputImage = carMascot
filter.outputImage


class ThresholdFilter: CIFilter {
    private class Constructor : NSObject, CIFilterConstructor {
        func filter(withName name: String) -> CIFilter? {
            if name == "FLDThresholdFilter" {
                return ThresholdFilter()
            }
            return nil
        }
    }
    
    @objc
    var inputImage : CIImage?
    
    @objc
    var threshold: CGFloat = 0.75
    
    private let filterKernel = CIColorKernel(source: """
kernel vec4 thresholdFilter(__sample image, float threshold) {
    float luma = (image.r * 0.2126) + (image.g * 0.7152) + (image.b * 0.0722);
    return (luma > threshold) ? vec4(1.0, 1.0, 1.0, 1.0) : vec4(0.0, 0.0, 0.0, 0.0);
}
"""
    )
    
    class func register() {
        CIFilter.registerName("FLDThresholdFilter", constructor: Constructor(), classAttributes: [:])
    }

    override var outputImage : CIImage? {
        guard let inputImage = inputImage, let filterKernel = filterKernel else { return nil }
        return filterKernel.apply(extent: inputImage.extent, arguments: [inputImage, threshold])
    }
}

ThresholdFilter.register()
let _filter = CIFilter(name: "FLDThresholdFilter")
_filter.inputImage

//: [Next](@next)
