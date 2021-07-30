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
        guard let url = URL(string: "http://192.168.1.6:8001/api/podcasts/") else {
            return
        }
//        URLSession.shared.dataTask(with: url){ (data, resp, err) in
//            guard let data = data else { return }
//            do {
//                let res = try JSONDecoder().decode(PodcastsList.self, from: data)
//                // TODO: fix warning: "Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates."
//                self.podcasts = res.payload
//            } catch {
//                print("Failed to decode: \(error) \(data)")
//            }
//        }.resume()
//        
//        
//        guard let url = URL(string: "http://192.168.1.6:8001/api/episodes/?limit=5") else {
//            return
//        }
//        URLSession.shared.dataTask(with: url){ (data, resp, err) in
//            guard let data = data else { return }
//            do {
//                let res = try JSONDecoder().decode(EpisodesResponse.self, from: data)
//                // TODO: fix warning: "Publishing changes from background threads is not allowed; make sure to publish values from the main thread (via operators like receive(on:)) on model updates."
//                self.episodes = res.payload.items
//            } catch {
//                print("Failed to decode: \(error) \(data)")
//            }
//        }.resume()
//        

        
        
    }
}

struct HomeView: View {
    
    @ObservedObject var vm = GridViewModel()
    @StateObject private var podcastVM = PodcastListViewModel()
    
    var body: some View {
        NavigationView{
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading){
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 22){
                            ForEach(vm.podcasts, id: \.self){ podcast in
                                VStack(alignment: .leading){
//                                    Image(podcast.image_url)
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
                    ForEach(vm.episodes, id: \.id){ episode in
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
