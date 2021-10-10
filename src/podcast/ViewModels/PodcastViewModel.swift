import Foundation
import KeychainAccess
import SwiftUI


class PodcastDetailsViewModel: ObservableObject{
    var sourceURL: String = ""
    @Published var podcast: PodcastDetails? = nil
    @Published var episodes: [EpisodeInList] = []
    @Published var notifyUserClipBoardCopied: Bool = false
    
    func getPodcast(podcastID: Int){
        // TODO: remove after implementation
        if (podcastID == TEST_PODCAST_ID){
            DispatchQueue.main.async {
                self.podcast = PodcastDetails(
                    id: TEST_PODCAST_ID,
                    name: "Test podcast",
                    description: "Only for testing new features",
                    imageUrl: "https://storage.yandexcloud.net/podcast-media/images/podcast-cax7j52Xha3f.jpg",
                    rssLink: "https://storage.yandexcloud.net/podcast-media/rss/podcast-cax7j52Xha3f.rss"
                )
                print("Set test podcast \(self.podcast)")
            }
            return
        }
        
        PodcastService().getPodcastDetails(podcastID: podcastID){ result in
            switch result{
                case .success(let podcast):
                    DispatchQueue.main.async {
                        self.podcast = podcast
                        print("Found podcast details \(podcast)")
                    }
                case .failure(let error):
                    print("API problems: \(error.localizedDescription)")
            }
        }
    }
    
    func getEpisodes(podcastID: Int){
        if (podcastID == TEST_PODCAST_ID){
            DispatchQueue.main.async {
                self.episodes = [
                    EpisodeInList(
                        id: 1,
                        title: "Test episode",
                        imageUrl: "https://storage.yandexcloud.net/podcast-media/images/podcast-cax7j52Xha3f.jpg"
                    )
                ]
            }
            return
        }
        EpisodeService().getEpisodes(podcastID: podcastID){ result in
            switch result{
                case .success(let episodes):
                    DispatchQueue.main.async {
                        self.episodes = episodes
                        print("Found podcast episodes \(episodes)")
                    }
                case .failure(let error):
                    print("API problems: \(error.localizedDescription)")
            }
        }
    }
    
    func createEpisode(){
        print("===> Creating episode with URL \(self.sourceURL)")
    }
    
    func copyRSSLink(){
        if (self.podcast != nil){
            UIPasteboard.general.string = podcast!.rssLink
            self.notifyUserClipBoardCopied = true
            print("Copied \(podcast!.rssLink)")
        } else {
            print("Nothing to copy (podcast is null)")
        }
    }
    
}



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
