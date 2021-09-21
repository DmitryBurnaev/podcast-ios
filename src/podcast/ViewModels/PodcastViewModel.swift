import Foundation
import KeychainAccess


class PodcastListViewModel: ObservableObject {
    @Published var podcasts: [PodcastInList] = []
    @Published var episodes: [EpisodeInList] = []

    init() {
        self.getPodcasts()
        // todo: move to another model
        self.getAllEpisodes(limit: 5)
    }
    
    func getPodcasts(){
        PodcastService().getPodcasts(){ result in
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
        EpisodeService().getEpisodes(limit: limit){ result in
            switch result{
                case .success(let episodes):
                    DispatchQueue.main.async {
                        self.episodes = episodes
                        print("Found episodes \(self.episodes)")
                    }
                case .failure(let error):
                    print("API problems: \(error.localizedDescription)")
            }
        }
    }
    
    
}
