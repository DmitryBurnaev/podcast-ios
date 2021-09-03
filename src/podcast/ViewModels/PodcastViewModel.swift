import Foundation
import KeychainAccess


class PodcastListViewModel: ObservableObject {
    @Published var podcasts: [PodcastItem] = []
    @Published var episodes: [Episode] = []

    init() {
        self.getPodcasts()
        self.getAllEpisodes(limit: 5)
    }
    
    func getPodcasts(){
        WebService().getPodcasts(){ result in
            switch result{
                case .success(let podcasts):
                    DispatchQueue.main.async {
                        self.podcasts = podcasts
                        print("Found podcasts \(self.podcasts)")
                    }
                case .failure(let error):
                    print("API problems: \(error.localizedDescription)")
            }
        }
    }

    func getAllEpisodes(limit: Int = 5){
        WebService().getEpisodes(limit: limit){ result in
            switch result{
                case .success(let episodes):
                    DispatchQueue.main.async {
                        self.episodes = episodes.items
                        print("Found episodes \(self.episodes)")
                    }
                case .failure(let error):
                    print("API problems: \(error.localizedDescription)")
            }
        }
    }
    
    
}
