import SwiftUI


struct Podcast: Identifiable{
    var id: Int
    
    let name, description, imageURL: String
}

struct NavigationItem: Identifiable{
    var id: Int
    
    let name, icon, value: String
}

struct ContentView: View {
    
    let podcasts: [Podcast] = [
        .init(id: 1, name: "Audio Books", description: "Audio books for everyone", imageURL: "podcast-cax7j52Xha3f"),
        .init(id: 2, name: "Listen later", description: "Only interesting audios", imageURL: "podcast-75fc068c8ecbca77"),
        .init(id: 3, name: "Lighting talks", description: "Some audio for listening after difficult day", imageURL: "cover-default"),
        .init(id: 4, name: "Test podcast", description: "SwiftUI gives us five built-in shapes that are commonly used: rectangle, rounded rectangle, circle, ellipse, and capsule. The last three in particular are subtly different in how they behave based on what sizes you provide, but we can demonstrate all the options with a single example", imageURL: "podcast-98765f61b45b1503"),
        .init(id: 5, name: "Audio Books", description: "Audio books for everyone", imageURL: "podcast-cax7j52Xha3f"),
        .init(id: 6, name: "Listen later", description: "Only interesting audios", imageURL: "podcast-75fc068c8ecbca77"),
        .init(id: 7, name: "Lighting talks", description: "Some audio for listening after difficult day", imageURL: "cover-default"),
        .init(id: 8, name: "Test podcast", description: "SwiftUI gives us five built-in shapes that are commonly used: rectangle, rounded rectangle, circle, ellipse, and capsule. The last three in particular are subtly different in how they behave based on what sizes you provide, but we can demonstrate all the options with a single example", imageURL: "podcast-98765f61b45b1503"),

    ]
    let navigationItems: [NavigationItem] = [
        .init(id: 1, name: "Home", icon: "house", value: "home"),
        .init(id: 2, name: "Podcasts", icon: "filemenu.and.selection", value: "podcasts"),
        .init(id: 3, name: "Add Episode", icon: "plus.app.fill", value: "add"),
        .init(id: 4, name: "Playlist", icon: "play.rectangle", value: "playlist"),
        .init(id: 5, name: "Profile", icon: "person", value: "profile"),
    ]
    
    
    let tabBarImageNames = ["house",  "filemenu.and.selection", "plus.app.fill", "play.rectangle", "person"]
    @State var selectednIndex = "podcasts"
    @State var shouldShowModal = false
        
    var body: some View {
        VStack(spacing: 0){
            ZStack{
                Spacer()
                    .fullScreenCover(isPresented: .constant(shouldShowModal), content: {
                        Button(action: {shouldShowModal.toggle()}, label: {
                            Text("Fillscreen cover")
                        })
                    })
                
                switch selectednIndex{
                
                case "home":
                    NavigationView{
                        Text("Home tab")
                    }
                    
                case "podcasts":
                    NavigationView{
                        List {
                            ForEach(podcasts, id: \.id){ podcast in
                                PodcastRow(podcast: podcast)
                            }
                        }.navigationBarTitle(Text("Podcasts"))
                    }
                    
                case "playlist":
                    NavigationView{
                        ScrollView{
                            Divider()
                            ForEach(0..<100){ num in
                                Text("Episode #\(num)")
                            }
                        }.navigationBarTitle(Text("Episodes"))
                    }
                case "profile":
                    NavigationView{
                        Text("User profile")
                    }

                default:
                    NavigationView{
                        Text("Remining tabs")
                    }
                }
            }
            
            Divider().padding(.bottom, 8)
            
            HStack{
                ForEach(navigationItems, id: \.id){ navigation in
                    Button(action: {
                        if navigation.value == "add" {
                            shouldShowModal.toggle()
                            return
                        }
                        selectednIndex = navigation.value
                    }, label: {
                        Spacer()
                        if navigation.value == "add" {
                            Image(systemName: navigation.icon)
                                .font(.system(size: 44))
                                .foregroundColor(.red)
                        } else {
                            Image(systemName: navigation.icon)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(selectednIndex == navigation.value ? Color(.label) : .init(white: 0.8))
                        }
                        Spacer()
                    })
                }
            }

        }

    }
}

struct PodcastRow: View {
    let podcast: Podcast
    
    var body: some View{
        HStack{
            Image(podcast.imageURL)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color.black, lineWidth: 1))
                .frame(width: 70, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            VStack (alignment: .leading){
                Text(podcast.name).font(.headline).baselineOffset(5)
                Text(podcast.description).font(.subheadline).lineLimit(3)
            }.padding(.leading, 8)
        }.padding(.init(top: 12, leading: 0, bottom: 12, trailing: 0))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}
