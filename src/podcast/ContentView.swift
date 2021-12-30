import SwiftUI

struct ContentView: View {
    @State private var shouldShowModal = false
    @State private var selectedTab = "home"
    @ObservedObject var loginVM: LoginViewModel = LoginViewModel()
    @ObservedObject var shareVM: ShareViewModel = ShareViewModel()

    var body: some View {
        VStack(spacing: 0){
            ZStack{
                Spacer()
                    .fullScreenCover(isPresented: .constant(shouldShowModal), content: {
                        Button(action: {shouldShowModal.toggle()}, label: {
                            Text("Fillscreen cover")
                        })
                    })
                
                if loginVM.hasLoggedIn{
//                    TODO: open "podcasts" view for sharing mode
                    switch selectedTab{

                    case "home":
                        HomeView()

                    case "podcasts":
                        PodcastListView()

                    case "playlist":
                        PlayListView()

                    case "profile":
                        ProfileView()

                    default:
                        NavigationView{
                            Text("Remining tabs")
                        }
                    }
                } else {
                    LoginView(loginVM: loginVM)
                }
                
            }
            Divider().padding(.bottom, 8)
            if loginVM.hasLoggedIn{
                TabBarView(selectedTab: $selectedTab, shouldShowModal: $shouldShowModal)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            .previewDevice("iPhone 11")
    }
}
