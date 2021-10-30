import Foundation
import KeychainAccess
import SwiftUI


class PodcastDetailsViewModel: ObservableObject{
    var sourceURL: String = ""
    @Published var podcast: PodcastDetails? = nil
    @Published var episodes: [EpisodeInList] = []
    @Published var notifyUserClipBoardCopied: Bool = false
    @Published var episodeCreating: Bool = false
    @Published var createdEpisode: EpisodeInList? = nil
    
    func getPodcast(podcastID: Int){
        // TODO: remove after implementation
        if (podcastID == TEST_PODCAST_ID){
            DispatchQueue.main.async {
                self.podcast = PodcastDetails(
                    id: TEST_PODCAST_ID,
                    name: "Test podcast",
                    description: "Only for testing new features",
                    imageUrl: "https://miro.medium.com/max/1400/1*Fx2xt6abjoAE_SbrX6s2Vg.jpeg",
                    rssLink: "https://path/to/rss/podcast-cax7j52Xha3f.rss"
                )
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
                        title: "Environment Variables are a set of key value pairs that are passed on to the process from outside of the program.",
                        imageUrl: "https://miro.medium.com/max/1400/1*Fx2xt6abjoAE_SbrX6s2Vg.jpeg",
                        status: "downloading"
                    ),
                    EpisodeInList(
                        id: 2,
                        title: "My published episode with short title",
                        imageUrl: "https://miro.medium.com/max/1400/1*Fx2xt6abjoAE_SbrX6s2Vg.jpeg",
                        status: "published"
                    ),
                    EpisodeInList(
                        id: 3,
                        title: "My error episode with short title",
                        imageUrl: "https://miro.medium.com/max/1400/1*Fx2xt6abjoAE_SbrX6s2Vg.jpeg",
                        status: "error"
                    ),
                    EpisodeInList(
                        id: 4,
                        title: "My last episode, whis wasn't downloaded",
                        imageUrl: "https://miro.medium.com/max/1400/1*Fx2xt6abjoAE_SbrX6s2Vg.jpeg",
                        status: "new"
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
        self.episodeCreating = true
        self.createdEpisode = nil
        if (self.podcast == nil) || (self.sourceURL == ""){
            print("Podcast and sourceURL are required here")
            return
        }
        EpisodeService().createEpisode(podcastID: self.podcast!.id, sourceURL: self.sourceURL){ result in
            switch result{
                case .success(let episode):
                    DispatchQueue.main.async {
                        self.createdEpisode = episode
                        self.episodeCreating = false
                        self.sourceURL = ""
                        print("Created episode \(episode) | in podcast \(self.podcast!)")
                    }
                case .failure(let error):
                    self.episodeCreating = false
                    print("API problems: \(error.localizedDescription)")
            }
        }
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
