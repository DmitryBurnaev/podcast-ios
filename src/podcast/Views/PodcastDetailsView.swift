import SwiftUI
import Kingfisher

struct PodcastDetailsView: View {
    @StateObject private var podcastVM = PodcastDetailsViewModel()
    
    init(podcastID: Int) {
        self.podcastVM.getPodcast(podcastID: podcastID)
    }
        
    var body: some View {
        NavigationView{
            if (self.podcastVM.podcast != nil) {
                Text("Podcast \(self.podcastVM.podcast!.name)")
            }
            else {
                Text("Unknown podcast")
            }
        }
    }
}

struct PodcastDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastDetailsView(podcastID: TEST_PODCAST_ID)
            .previewLayout(.sizeThatFits)
    }
}
