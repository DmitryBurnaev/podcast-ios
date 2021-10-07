import SwiftUI
import Kingfisher

struct PodcastDetailsView: View {
    @ObservedObject private var podcastVM = PodcastDetailsViewModel()
    @Environment(\.colorScheme) var colorScheme

    init(podcastID: Int) {
        self.podcastVM.getPodcast(podcastID: podcastID)
    }
        
    var body: some View {
        if (self.podcastVM.podcast != nil) {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    VStack {
                        KFImage(URL(string: self.podcastVM.podcast!.imageUrl ?? ""))
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color.black, lineWidth: 0.5))
                            .frame(width: 200, height: 200, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

                        Spacer()
                    }
                    VStack{
                        Text(self.podcastVM.podcast!.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        Text(self.podcastVM.podcast!.description)
                            .font(.system(size: 10))
                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)

                    }
                }.padding()
            }
        } else {
            Text("Unknown podcast")
        }
    }
}

struct PodcastDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastDetailsView(podcastID: TEST_PODCAST_ID)
            .previewLayout(.sizeThatFits)
    }
}
