import SwiftUI

struct ContentView: View {
    @State private var shouldShowModal = false
    @State private var selectedTab = "home"
    @ObservedObject var loginVM: LoginViewModel = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 0){
            ZStack{
                Spacer()
                    .fullScreenCover(isPresented: .constant(shouldShowModal), content: {
                        Button(action: {shouldShowModal.toggle()}, label: {
                            Text("Fillscreen cover")
                        })
                    })
                // TODO: toggle isAuthenticated if we have got 401 status code
//                Toggle()
                if loginVM.hasLoggedIn{
                    switch selectedTab{

                    case "home":
                        HomeView()

                    case "podcasts":
                        PodcastListView()

                    case "playlist":
                        PlayListView()

                    case "profile":
                        ProfileView(loginVM: loginVM)

                    default:
                        NavigationView{
                            Text("Remining tabs")
                        }
                    }
                } else {
                    ProfileView(loginVM: loginVM)
                }
                
            }

            Divider().padding(.bottom, 8)

            TabBarView(selectedTab: $selectedTab, shouldShowModal: $shouldShowModal)

        }
//        TODO: add alert for unauth requests
//        .alert(isPresented: $loginVM.notifyUserIsAuthenticated) {
//            Alert(
//                title: Text("Got access token"),
//                message: Text("Access token: \(loginVM.token)"),
//                dismissButton: .default(Text("Got it!"))
//            )
//        }

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 11")
    }
}
