import SwiftUI
import Kingfisher

struct HomeView: View {
    @StateObject private var podcastVM = PodcastListViewModel()

    var body: some View {
        NavigationView{
            ScrollView(showsIndicators: false){
                VStack(alignment: .leading){
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 22){
                            if podcastVM.podcasts.count > 0 {
                                ForEach(podcastVM.podcasts, id: \.self){ podcast in
                                    VStack(alignment: .leading){
                                        KFImage(URL(string: podcast.imageUrl ?? ""))
                                            .resizable()
                                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color.black, lineWidth: 0.5))
                                            .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        Text(podcast.name)
                                            .font(.system(size: 10, weight: .semibold))
                                        Text("Episodes: \(podcast.episodesCount)")
                                            .font(.system(size: 9, weight: .regular))
                                            .foregroundColor(.gray)
                                    }.onTapGesture {
                                        print("Open view with podcast #\(podcast.id)")
                                    }
                                }
                            } else {
                                Image("cover-default")
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                    .frame(width: 100, height: 100, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .opacity(0.4)
                            }
                        }
                    }.padding()
                    if podcastVM.episodes.count > 0 {
                        Text("Recent episodes")
                            .font(.system(size: 20, weight: .semibold))
                            .padding()
                        ForEach(podcastVM.episodes, id: \.id){ episode in
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
                    
                }
            }.navigationTitle("Your podcasts")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
