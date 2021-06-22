import SwiftUI

struct ContentView: View {
    @State private var shouldShowModal = false
    @State private var selectedTab = "home"
    
    var body: some View {
        VStack(spacing: 0){
            ZStack{
                Spacer()
                    .fullScreenCover(isPresented: .constant(shouldShowModal), content: {
                        Button(action: {shouldShowModal.toggle()}, label: {
                            Text("Fillscreen cover")
                        })
                    })
                
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
            }
            
            Divider().padding(.bottom, 8)
            
            TabView(selectedTab: $selectedTab, shouldShowModal: $shouldShowModal)
            
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
