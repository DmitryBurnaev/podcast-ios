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
                        List{
                            Button(action: {
                                print("RSS COPY button was tapped")
                                self.podcastVM.copyRSSLink()
                            }) {
                                HStack(spacing: 7) {
                                    Image(systemName: "square.and.arrow.up.on.square")
                                        .frame(height: 20)
                                    Text("RSS")
                                }
                            }
                            .padding(.init(top: 0, leading: 3, bottom: 0, trailing: 5))
                            .listRowBackground(Color(UIColor.systemGroupedBackground))
                            .alert(isPresented: $podcastVM.notifyUserClipBoardCopied) {
                                Alert(
                                    title: Text(""),
                                    message: Text("RSS link copied!"),
                                    dismissButton: .default(Text("Got it!"))
                                )
                            }
                            Button(action: {
                                print("EDIT button was tapped")
                            }) {
                                HStack(spacing: 7) {
                                    Image(systemName: "pencil")
                                        .frame(height: 20)
                                    Text("Edit").padding(.init(top: 0, leading: 3, bottom: 0, trailing: 0))
                                }
                                
                            }.padding(.init(top: 0, leading: 5, bottom: 0, trailing: 5))
                            .listRowBackground(Color(UIColor.systemGroupedBackground))
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
                    ActivityIndicatorView(isPresented: $podcastVM.episodeCreating)
                    if (podcastVM.createdEpisode != nil){
                        EpisodeRow(episode: podcastVM.createdEpisode!)
                    }
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
        HStack(){
            KFImage(URL(string: episode.imageUrl))
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(Color.black, lineWidth: 1))
                .frame(width: 70, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            VStack (alignment: .leading){
                Text(episode.title)
                    .font(.system(size: 16, weight: .regular))
                    .truncationMode(.tail)
                    .padding(.init(top: 0, leading: 3, bottom: 0, trailing: 10))
                    .frame(height: 60, alignment: .top)
            }
                .padding(.leading, 0)
            Spacer()
            switch episode.status{
                case "downloading":
                    ProgressView{}
                        .padding(.init(top: 0, leading: 3, bottom: 0, trailing: 5))
                case "published":
                    Image(systemName: "checkmark")
                        .frame(height: 20)
                        .foregroundColor(Color(.green))
                case "error":
                    Image(systemName: "xmark.icloud")
                        .frame(height: 20)
                        .foregroundColor(Color(.red))
                default:
                    Image(systemName: "square.and.pencil")
                        .frame(height: 20)
            }            
        }.padding(.init(top: 0, leading: 15, bottom: 0, trailing: 15))
    }
}

struct ActivityIndicatorView: View {
    @Binding var isPresented:Bool
    var body: some View {
        if isPresented{
            ZStack{
                RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.1))
                ProgressView {
                    Text("Episode's creation...")
                        .font(.title3)
                }
            }.frame(height: 100, alignment: .center)
            .padding(.init(top: -10, leading: 15, bottom: 10, trailing: 15))
//            .padding(.leading)
//            .background(RoundedRectangle(cornerRadius: 25).stroke(Color.gray, lineWidth: 2))
        }
    }
}

struct PodcastDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PodcastDetailsView(podcastID: TEST_PODCAST_ID)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}

//                            Text("Copy RSS")
//                                .frame(width: 100)
//                                .padding(5)
//                                .background(Color(white: 0.9))
//                                .cornerRadius(10)
//                                .frame(width: 100)
//                                .onTapGesture {
//                                    print("RSS COPY button was tapped")
//                                }
