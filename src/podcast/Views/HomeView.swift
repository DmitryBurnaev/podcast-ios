import SwiftUI
import Kingfisher


struct PodcastsListResponse: Decodable{
    let payload: [PodcastItem]
}

struct PodcastItem: Decodable, Hashable {
    let id, episodes_count: Int
    let name, description, image_url: String
}



struct EpisodesResponse: Decodable{
    let payload: EpisodesList
}

struct EpisodesList: Decodable{
    let items: [Episode]
}

struct Episode: Decodable, Hashable{
    var id: Int
    let title, image_url: String
}


class GridViewModel: ObservableObject{
    @Published var podcasts = [PodcastItem]()
    @Published var episodes = [Episode]()

    init() {
        let podcastVM = PodcastListViewModel()
        podcastVM.getPodcasts()
        DispatchQueue.main.async {
            self.podcasts = podcastVM.podcasts
        }
    }
}

struct HomeView: View {
    @ObservedObject var podcastVM = PodcastListViewModel()
    
    var body: some View {
        NavigationView{
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading){
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 22){
                            ForEach(podcastVM.podcasts, id: \.self){ podcast in
                                VStack(alignment: .leading){
                                    KFImage(URL(string: podcast.image_url))
                                        .resizable()
                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                        .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color.black, lineWidth: 0.5))
                                        .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    Text(podcast.name)
                                        .font(.system(size: 10, weight: .semibold))
                                    Text("Episodes: \(podcast.episodes_count)")
                                        .font(.system(size: 9, weight: .regular))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }.padding()
                    Text("Recent episodes")
                        .font(.system(size: 20, weight: .semibold))
                        .padding()
                    ForEach(podcastVM.episodes, id: \.id){ episode in
                        HStack{
                            KFImage(URL(string: episode.image_url))
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color.black, lineWidth: 1))
                                .frame(width: 70, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            VStack (alignment: .leading){
                                Text(episode.title)
                                    .font(.system(size: 12, weight: .regular))
                                    .foregroundColor(.gray)
                            }.padding(.leading, 8)
                        }.padding(.init(top: 0, leading: 15, bottom: 0, trailing: 15))
                    }
                }
            }.navigationTitle("Your podcasts")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
