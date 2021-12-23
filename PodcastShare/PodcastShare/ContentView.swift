import SwiftUI


struct ContentView: View {
    var incomingURL: String  = ""
    var observer: NSKeyValueObservation?
    
    init() {
        print("dasssss")
//        TODO: fix observer problems
//        self.observer = UserDefaults.standard.observe(\.incomingURL, options: [.initial, .new]) { (observed, change) in
//            print("something changed change (new value): \(String(describing: change.newValue)) | observed: \(observed)")
//            DispatchQueue.main.async {
//                self.incomingURL = change.newValue ?? ""
//            }
//        }

//        let incomingURL = UserDefaults(suiteName: "podcastShareUserDefaults")?.value(forKey: "incomingURL") as? String
//        let incomingURL = UserDefaults().value(forKey: "incomingURL") as? String
//        if incomingURL != nil {
//            UserDefaults().removeObject(forKey: "incomingURL")
//            print("incomingURL", incomingURL)
//        }
    }
    
//    deinit {
//        observer?.invalidate()
//    }

    var body: some View {
        Text("Hello, podcast share! \(incomingURL)").padding()
    }
}
//TODO: ContentView2

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
