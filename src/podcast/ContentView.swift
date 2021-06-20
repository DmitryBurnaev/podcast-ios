import SwiftUI


struct Podcast: Identifiable{
    var id: Int
    
    let name, description, imageURL: String
}


struct ContentView: View {
    
    let podcasts: [Podcast] = [
        .init(id: 1, name: "Audio Books", description: "Audio books for everyone", imageURL: "podcast-cax7j52Xha3f"),
        .init(id: 2, name: "Listen later", description: "Only interesting audios", imageURL: "podcast-75fc068c8ecbca77"),
        .init(id: 3, name: "Lighting talks", description: "Some audio for listening after difficult day", imageURL: "cover-default"),
        .init(id: 4, name: "Test podcast", description: "SwiftUI gives us five built-in shapes that are commonly used: rectangle, rounded rectangle, circle, ellipse, and capsule. The last three in particular are subtly different in how they behave based on what sizes you provide, but we can demonstrate all the options with a single example", imageURL: "podcast-98765f61b45b1503"),
    ]
    
    var body: some View {
        NavigationView{
            List {
                ForEach(podcasts, id: \.id){ podcast in
                    PodcastRow(podcast: podcast)
                }
            }.navigationBarTitle(Text("Podcasts"))
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
                Text(podcast.description).font(.subheadline).lineLimit(2)
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
