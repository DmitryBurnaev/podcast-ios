import Foundation



class PodcastListViewModel: ObservableObject {
    var podcasts: [PodcastItem] = []
    var episodes: [Episode] = []
    
    init() {
        self.getPodcasts()
        self.getAllEpisodes(limit: 5)
    }
    
    func getPodcasts(){
        
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "accessToken") else {
            print("No access token found")
            return
        }
        
        WebService().getPodcasts(token: token){ result in
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
        
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "accessToken") else {
            print("No access token found")
            return
        }
        
        WebService().getEpisodes(limit: limit, token: token){ result in
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
