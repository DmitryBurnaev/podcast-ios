import SwiftUI


struct ContentView: View {
    init() {
        print("dasssss")
//        let incomingURL = UserDefaults(suiteName: "podcastShareUserDefaults")?.value(forKey: "incomingURL") as? String
        let incomingURL = UserDefaults().value(forKey: "incomingURL") as? String
        if incomingURL != nil {
//            UserDefaults().removeObject(forKey: "incomingURL")
            print("incomingURL", incomingURL)
        }
    }

    var body: some View {
        Text("Hello, podcast share!")
            .padding()
    }
}
//TODO: ContentView2

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
