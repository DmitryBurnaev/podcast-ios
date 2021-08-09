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
        let keychain = Keychain(service: "com.podcast")
        guard let token = try? keychain.get("accessToken") else {
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
        
//        let defaults = UserDefaults.standard
        let keychain = Keychain(service: "com.podcast")
        guard let token = try? keychain.get("accessToken") else {
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
