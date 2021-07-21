import SwiftUI
import Kingfisher


struct PodcastsList: Decodable{
    let payload: [PodcastItem]
}

struct PodcastItem: Decodable, Hashable {
    let id, episodes_count: Int
    let name, image_url: String
}

class GridViewModel: ObservableObject{
    @Published var podcasts = 0..<5
    @Published var payload = [PodcastItem]()
    

    init() {
        guard let url = URL(string: "http://192.168.1.6:8001/api/podcasts/") else {
            return
        }
        URLSession.shared.dataTask(with: url){ (data, resp, err) in
            guard let data = data else { return }
            do {
                let res = try JSONDecoder().decode(PodcastsList.self, from: data)
                self.payload = res.payload
            } catch {
                print("Failed to decode: \(error) \(data)")
            }
        }.resume()
    
    }
}

struct HomeView: View {
    
    @ObservedObject var vm = GridViewModel()
    
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVGrid(columns: [
                    GridItem(.flexible(minimum: 100, maximum: 200), spacing: 12),
                    GridItem(.flexible(minimum: 100, maximum: 200), spacing: 12),
                    GridItem(.flexible(minimum: 100, maximum: 200), alignment: .top),
                ], spacing: 2, content: {
                    ForEach(vm.payload, id: \.self){ podcast in
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
                        .padding()
                    }
                }).padding(.horizontal, 15)
            }.navigationTitle("Your podcasts")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
