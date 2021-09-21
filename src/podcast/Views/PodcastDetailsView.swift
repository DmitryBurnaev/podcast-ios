import SwiftUI

import Kingfisher

struct PodcastDetailsView: View {
    @StateObject private var podcastVM = PodcastListViewModel()
    var podcast: PodcastDetails? = nil
    
    init(podcastID: Int = 0) {
        // todo: fix escaping closure captures mutating self
        PodcastService().getPodcastDetails(podcastID: podcastID){ result in
            switch result{
            case .success(let podcastDetails):
                DispatchQueue.main.async {
                    self.podcast = podcastDetails
                }
            case .failure(let err):
                print("Podcast Details: failed: \(err)")
            }
        }
    }
    
    var body: some View {
        NavigationView{
            if (self.podcast != nil) {
                Text("Podcast \(self.podcast!.name)")
            }
            else {
                Text("Unknown podcast")
            }
        }
    }
}

struct PodcastDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastDetailsView()
            .previewLayout(.sizeThatFits)
    }
}
