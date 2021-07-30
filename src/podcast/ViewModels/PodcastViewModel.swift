import Foundation



class PodcastListViewModel: ObservableObject {
    var podcasts: [PodcastItem] = []
    
    func getPodcasts(){
        
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "accessToken") else {
            print("No access token found")
            return
        }
                
        WebService().getPodcasts(token: token){ result in
            switch result{
                case .success(let podcasts):
                    print("Found podcasts \(podcasts)")
                    defaults.setValue(token, forKey: "accessToken")
                    DispatchQueue.main.async {
                        self.podcasts = podcasts
                    }
                case .failure(let error):
                    print("API problems: \(error.localizedDescription)")
            }
            
        }
    }
    
}

//
//class PodcastViewModel{
//    let podcast: PodcastItem? = nil
//    let id = UUID()
//    var name: String {
//        return podcast.name
//    }
//}
