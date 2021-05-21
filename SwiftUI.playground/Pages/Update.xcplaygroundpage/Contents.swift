//: [Previous](@previous)

import SwiftUI
import PlaygroundSupport

//struct LabelView: View {
//    @State var counter = 0
//    var body: some View {
//        print("LabelView")
//        return VStack {
//            Button("Tap me!") { self.counter += 1 }
//            if counter > 0 {
//                Text("You've tapped \(counter) times")
//            }
//        }
//    }
//}
//struct ContentView: View {
//    var body: some View {
//        print("ContentView")
//        return LabelView()
//    }
//}

//采用绑定
struct LabelView: View {
    @Binding var number: Int
    var body: some View {
        let _ = print("LabelView")
//        return Group {
//            if number > 0 {
//                Text("You've tapped \(number) times")
//            }
//        }
        if number > 0 {
            Text("You've tapped \(number) times")
        } else {
            Image(systemName: "lightbulb")
        }
    }
}
struct ContentView: View {
    @State var counter = 0
    var body: some View {
        print("ContentView")
        return VStack {
            Button("Tap me!") { self.counter += 1 }
            LabelView(number: $counter)
        }
    }
}


PlaygroundPage.current.setLiveView(ContentView())

//: [Next](@next)
