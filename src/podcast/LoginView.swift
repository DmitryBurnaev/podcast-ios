import SwiftUI

struct LoginView: View {
    
    @StateObject private var loginVM = LoginViewModel()
    @StateObject private var podcastVM = PodcastListViewModel()

    
    var body: some View {
        VStack(alignment: .leading){
            Form{
                HStack{
                    Spacer()
                    Image(systemName: loginVM.isAuthenticated ? "lock.open" : "lock.fill")
                }
                TextField("Email", text: $loginVM.email).keyboardType(.emailAddress).autocapitalization(.none)
                SecureField("Password", text: $loginVM.password)
                HStack{
                    Spacer()
                    Button("Login"){
                        loginVM.login()
                    }.alert(isPresented: $loginVM.notifyUserIsAuthenticated) {
                        Alert(
                            title: Text("Got access token"),
                            message: Text("Access token: \(loginVM.token)"),
                            dismissButton: .default(Text("Got it!"))
                        )
                    }
                    Spacer()
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            VStack{
                Spacer()
                if podcastVM.podcasts.count > 0{
                    List(podcastVM.podcasts, id:\.id){ podcast in
                        HStack{
                            Text("\(podcast.name)")
                        }
                    }
                } else {
                    Text("No podcasts found")
                }
            }
            Button("Get podcasts"){
                podcastVM.getPodcasts()
            }.padding().background(Color.blue)
            
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
