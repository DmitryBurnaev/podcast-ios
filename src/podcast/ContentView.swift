//
//  ContentView.swift
//  podcast
//
//  Created by Dmitry Burnaev on 12.06.2021.
//

import SwiftUI


struct Podcast: Identifiable{
    var id: Int
    
    let name, description, imageURL: String
}


struct ContentView: View {
    
    let podcasts: [Podcast] = [
        .init(id: 1, name: "Audio Books", description: "Audio books for everyone", imageURL: "podcast-cax7j52Xha3f"),
        .init(id: 2, name: "Listen later", description: "Interesting auidios", imageURL: "podcast-75fc068c8ecbca77"),
        .init(id: 3, name: "Test podcast", description: "Only for testing new features", imageURL: "podcast-98765f61b45b1503"),
        .init(id: 4, name: "Lighting talks", description: "Some audio for listening after difficult day", imageURL: "cover-default"),
    ]
    
    var body: some View {
        NavigationView{
            List {
                Text("Podcast list will be here").font(.title2)
                ForEach(podcasts, id: \.id){ podcast in
                    HStack{
                        Image(podcast.imageURL)
                            .resizable()
                            .frame(width: 70, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .clipped()
                        VStack (alignment: .leading){
                            Text(podcast.name).font(.headline)
                            Text(podcast.description).font(.subheadline)
                        }
                    }
                }
            }.navigationBarTitle(Text("Podcasts"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}
