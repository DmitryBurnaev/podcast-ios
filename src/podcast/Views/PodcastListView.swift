import SwiftUI
import Kingfisher

struct PodcastListView: View {
    @StateObject private var podcastVM = PodcastListViewModel()

    var body: some View {
        NavigationView{
            List {
                ForEach(podcastVM.podcasts, id: \.id){ podcast in
                    NavigationLink(destination: PodcastDetailsView(podcastID: podcast.id)){
                        PodcastRow(podcast: podcast)
                    }
                }
            }.navigationBarTitle(Text("Podcasts"), displayMode: .inline)
        }
    }
}

struct PodcastListView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastListView()
            .previewLayout(.sizeThatFits)
    }
}


struct PodcastRow: View {
    @Environment(\.colorScheme) var colorScheme

    let podcast: PodcastInList
    
    var body: some View{
        HStack{
            KFImage(URL(string: podcast.imageUrl ?? ""))
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color.black, lineWidth: 1))
                .frame(width: 70, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            VStack (alignment: .leading){
                Text(podcast.name).font(.headline).baselineOffset(5).foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                Text(podcast.description).font(.subheadline).lineLimit(3)
            }.padding(.leading, 8)
        }.padding(.init(top: 12, leading: 0, bottom: 12, trailing: 0))
    }
}
