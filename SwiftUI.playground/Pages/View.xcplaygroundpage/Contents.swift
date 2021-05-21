//: [Previous](@previous)

import SwiftUI
import PlaygroundSupport

extension View {
    func debug() -> Self {
        print(Mirror(reflecting: self).subjectType)
        return self
    }
}

struct ContentView: View {
    //状态变更时，会调用view的body
    @State var counter = 0
    var body: some View {
        let _ = print("hi!")
        VStack {
            Button(action: { counter += 1 }, label: {
                Text("Tap me!")
                    .padding()
                    .background(Color(.tertiarySystemFill))
                    .cornerRadius(5)
            })
            if counter > 0 {
                Text("You've tapped \(counter) times")
            } else {
                Text("You've not yet tapped")
            }
        }.debug()
        .border(Color.red)
        .frame(width: 200, height: 200)
    }
}

PlaygroundPage.current.setLiveView(ContentView())

//: [Next](@next)
