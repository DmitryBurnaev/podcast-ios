import SwiftUI
import Kingfisher

struct PodcastDetailsView: View {
    @ObservedObject private var podcastVM = PodcastDetailsViewModel()
    @Environment(\.colorScheme) var colorScheme

    init(podcastID: Int) {
        self.podcastVM.getPodcast(podcastID: podcastID)
        self.podcastVM.getEpisodes(podcastID: podcastID)
    }
        
    var body: some View {
        if (self.podcastVM.podcast != nil) {
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading) {
                    Text(self.podcastVM.podcast!.name)
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                        .padding(.top)
                        .padding(.leading)
                    
                    HStack(alignment: .top) {
                        VStack {
                            KFImage(URL(string: self.podcastVM.podcast!.imageUrl ?? ""))
                                .resizable()
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color.black, lineWidth: 0.5))
                                .frame(width: 190, height: 190, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)

                        }
                        VStack{

                        }
                    }.padding(.leading)
                    Form{
                        TextField("New episode's source URL", text: $podcastVM.sourceURL)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                        HStack{
                            Spacer()
                            Button("Create Episode"){
                                podcastVM.createEpisode()
                            }
                            Spacer()
                        }

                    }.frame(height: 150)
                    if podcastVM.episodes.count > 0 {
                        ForEach(podcastVM.episodes, id: \.id){ episode in
                            EpisodeRow(episode: episode)
                        }
                    }
                }
            }

        } else {
            Text("Unknown podcast")
        }
    }
}

struct EpisodeRow: View {
    @Environment(\.colorScheme) var colorScheme

    let episode: EpisodeInList
    
    var body: some View{
        HStack{
            KFImage(URL(string: episode.imageUrl))
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color.black, lineWidth: 1))
                .frame(width: 70, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            VStack (alignment: .leading){
                Text(episode.title)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.gray)
            }.padding(.leading, 8)
        }.padding(.init(top: 0, leading: 15, bottom: 0, trailing: 15))
    }
}




struct PodcastDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastDetailsView(podcastID: TEST_PODCAST_ID)
            .previewLayout(.sizeThatFits)
    }
}
