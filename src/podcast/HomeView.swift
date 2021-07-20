import SwiftUI


struct PodcastsList: Decodable{
    let payload: [PodcastItem]
}

struct PodcastItem: Decodable, Hashable {
    let id: Int
    let name, image_url: String
}

class GridViewModel: ObservableObject{
    @Published var podcasts = 0..<5
    @Published var payload = [PodcastItem]()
    

    init() {
//        Timer.scheduledTimer(withTimeInterval: 2, repeats: false){(_) in
//            self.podcasts = 0..<15
//        }
//
        guard let url = URL(string: "http://192.168.1.6:8001/api/podcasts/") else {
            return
        }
        URLSession.shared.dataTask(with: url){ (data, resp, err) in
            guard let data = data else { return }
            do {
                let res = try JSONDecoder().decode(PodcastsList.self, from: data)
                self.payload = res.payload
            } catch {
                print("Failed to decode: \(err) \(data)")
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
                    GridItem(.flexible(minimum: 100, maximum: 200)),
                ], spacing: 12, content: {
                    ForEach(vm.payload, id: \.self){ num in
                        VStack(alignment: .leading){
                            Spacer()
                                .frame(width: 90, height: 90)
                                .background(Color.blue)
                            Text("Podcast name")
                                .font(.system(size: 10, weight: .semibold))
                        }
                        .padding()
                        .background(Color.gray)

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
