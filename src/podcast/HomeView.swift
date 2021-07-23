import SwiftUI
import Kingfisher


struct PodcastsList: Decodable{
    let payload: [PodcastItem]
}

struct PodcastItem: Decodable, Hashable {
    let id, episodes_count: Int
    let name, description, image_url: String
}

let podcasts_list: [PodcastItem] = [
    .init(id: 1, episodes_count: 10, name: "Audio Books", description: "Audio books for everyone", image_url: "podcast-cax7j52Xha3f"),
    .init(id: 2, episodes_count: 40,  name: "Listen later", description: "Only interesting audios", image_url: "podcast-75fc068c8ecbca77"),
    .init(id: 3,  episodes_count: 12, name: "Lighting talks", description: "Some audio for listening after difficult day", image_url: "cover-default"),
    .init(id: 4,  episodes_count: 15, name: "Test podcast", description: "SwiftUI gives us five built-in shapes that are commonly used: rectangle, rounded rectangle, circle, ellipse, and capsule. The last three in particular are subtly different in how they behave based on what sizes you provide, but we can demonstrate all the options with a single example", image_url: "podcast-98765f61b45b1503"),
]


class GridViewModel: ObservableObject{
    @Published var podcasts = 0..<5
    @Published var payload = [PodcastItem]()
    

    init() {
        self.payload = podcasts_list
        
//        TODO: use fetching API
//        guard let url = URL(string: "http://192.168.1.6:8001/api/podcasts/") else {
//            return
//        }
//        URLSession.shared.dataTask(with: url){ (data, resp, err) in
//            guard let data = data else { return }
//            do {
//                let res = try JSONDecoder().decode(PodcastsList.self, from: data)
//                self.payload = res.payload
//            } catch {
//                print("Failed to decode: \(error) \(data)")
//            }
//        }.resume()
    
    }
}



struct Episode: Identifiable{
    var id: Int
    let title, image_url: String
}


let episodes: [Episode] = [
    .init(id: 1, title: "Роберт Хайнлайн - ТОННЕЛЬ В НЕБЕ. Часть 3 из 3 (окончание). Аудиокнига. Фантастика.", image_url: "https://s1.livelib.ru/boocover/1001456680/o/5f47/Robert_Hajnlajn__Tunnel_v_nebe.jpeg"),
    .init(id: 2, title: "ASGI — не еще один gateway / Сергей Халецкий / EPAM [Python Meetup 28.11.2019]", image_url: "https://i.ytimg.com/vi/HGcv9WAKkPM/maxresdefault.jpg"),
    .init(id: 3, title: "Mikhail Kashkin \"aiohttp.web: Применение сервера и клиента\" Dnepr.py #5.", image_url: "https://miro.medium.com/max/1400/0*l7AJ7Y9X3bAbkvfs"),
    .init(id: 4, title: "Джеймс Кори - \"Врата Абаддона\" Глава 48 Бык", image_url: "https://static.librebook.me/uploads/pics/02/19/349.jpg"),
    .init(id: 5, title: "Patterns for asyncio applications / Николай Новик [Python Meetup 28.10.2016]", image_url: "https://i.ytimg.com/vi/z4gKgEN3v2Q/default.jpg"),
]




struct HomeView: View {
    
    @ObservedObject var vm = GridViewModel()
    
    var body: some View {
        NavigationView{
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading){
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 22){
                            ForEach(vm.payload, id: \.self){ podcast in
                                VStack(alignment: .leading){
                                    Image(podcast.image_url)
    //                                KFImage(URL(string: podcast.image_url))
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
//                    List {
                        ForEach(episodes, id: \.id){ episode in
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
//                    }
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


//                LazyVGrid(columns: [
//                    GridItem(.flexible(minimum: 100, maximum: 200), spacing: 12),
//                    GridItem(.flexible(minimum: 100, maximum: 200), spacing: 12),
//                    GridItem(.flexible(minimum: 100, maximum: 200), alignment: .top),
//                ], spacing: 2, content: {
//                    ForEach(vm.payload, id: \.self){ podcast in
//                        VStack(alignment: .leading){
//                            KFImage(URL(string: podcast.image_url))
//                                .resizable()
//                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//                                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color.black, lineWidth: 0.5))
//                                .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//                            Text(podcast.name)
//                                .font(.system(size: 10, weight: .semibold))
//                            Text("Episodes: \(podcast.episodes_count)")
//                                .font(.system(size: 9, weight: .regular))
//                                .foregroundColor(.gray)
//                        }
//                        .padding()
//                    }
//                }).padding(.horizontal, 15)
