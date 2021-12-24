import SwiftUI



class LoginViewModel: ObservableObject {
    var observer: NSKeyValueObservation?

    @Published var incomingURL: String  = ""
        
    init() {
        self.observer = UserDefaults.standard.observe(\.incomingURL, options: [.initial, .new]) { (observed, change) in
            print("something changed change (new value): \(String(describing: change.newValue)) | observed: \(observed)")
            DispatchQueue.main.async {
                self.incomingURL = change.newValue ?? ""
            }
        }
    }
    
    deinit {
        observer?.invalidate()
    }
    
}



struct ContentView: View {
    @ObservedObject var loginVM: LoginViewModel = LoginViewModel()

    var body: some View {
        if loginVM.incomingURL != "" {
            ProfileView2(incomingURL: loginVM.incomingURL)
        } else {
            ProfileView1()
        }
    }
}

struct ProfileView1: View {
    var body: some View {
        NavigationView{
            Text("ProfileView1")
        }
    }
}

struct ProfileView2: View {
    var incomingURL: String  = ""
    
    init(incomingURL: String) {
        self.incomingURL = incomingURL
    }
    
    var body: some View {
        NavigationView{
            Text("ProfileView2 \(incomingURL)")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
