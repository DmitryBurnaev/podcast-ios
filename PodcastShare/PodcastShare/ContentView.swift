import SwiftUI



class LoginViewModel: ObservableObject {
    @Published var incomingURL: String  = ""
    var allowedDomains: [String] = [
        "youtube.com",
        "youtu.be"
    ]
    
    
    init() {
        if let incomingURL = UIPasteboard.general.string {
            for domain in self.allowedDomains {
                if incomingURL.contains(domain){
                    self.incomingURL = incomingURL
                    break
                }
            }
        }
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
