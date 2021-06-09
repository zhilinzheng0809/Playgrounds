//: [Previous](@previous)

import Foundation
import CoreImage
import UIKit

var greeting = "Hello, playground"
let carMascot = CIImage(image: UIImage(named: "carmascot.jpg")!)!
let bloomFilter = CIFilter(name: "CIBloom", parameters: [kCIInputRadiusKey : 8,
                                                         kCIInputIntensityKey: 1.25,
                                                         kCIInputImageKey: carMascot])
//bloomFilter?.setValue(carMascot, forKey: "inputImage")
bloomFilter?.outputImage

let image = CIImage(color: CIColor(color: .red)).cropped(to: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 100, height: 100)))

let sourceImage = UIImage(named: "carmascot.jpg")!
let image1 = CIImage(image: sourceImage)
//image1?.oriented(sourceImage.imageOrientation)

let filter = CIFilter(name: "CIConvolution5X5")
//let attribute = filter?.attributes[kCIInputWidthKey] as! [String: Any]
//let defaultValue = attribute[kCIAttributeDefault] as! CIVector

let message = "Core Image for Swift"
let data = message.data(using: .ascii)!
let filter1 = CIFilter(name: "CICode128BarcodeGenerator",parameters: ["inputMessage":data])!
filter1.outputImage

let fortyFiveDegrees = CGFloat(Double.pi / 4)

let transform = NSValue(cgAffineTransform:CGAffineTransform(rotationAngle: fortyFiveDegrees))
let filter2 = CIFilter(name: "CIAffineTransform", parameters: [kCIInputImageKey:carMascot,
                                                   kCIInputTransformKey:transform])
filter2?.outputImage

let extent = CGRect(x: 100, y: 100, width: 100, height: 100)

let averageFilter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: carMascot,
                                                                 kCIInputExtentKey: extent])
averageFilter?.outputImage

//: [Next](@next)
