import SwiftUI

struct Tab: Identifiable{
    var id: String
    
    let label, icon: String
}

let tabs: [Tab] = [
    .init(id: "home",     label: "Home",        icon: "house"),
    .init(id: "podcasts", label: "Podcasts",    icon: "filemenu.and.selection"),
    .init(id: "add",      label: "Add",         icon: "plus.app.fill"),
    .init(id: "playlist", label: "Playlist",    icon: "play.rectangle"),
    .init(id: "profile",  label: "Profile",     icon: "person"),
]



struct TabBarView: View {
    @Binding var selectedTab: String
    @Binding var shouldShowModal: Bool
//    @Binding private var shareScreenOpened: Bool
    @Namespace private var currentTab
    @ObservedObject var shareVM: ShareViewModel = ShareViewModel()

    var body: some View {
        HStack(alignment: .bottom){
            ForEach(tabs, id: \.id){ tab in
                GeometryReader{ geometry in
                    VStack(spacing: 4){
//                        if (selectedTab == tab.id && tab.id != "add"){
//                            Color(.label)
//                                .frame(height: 2)
//                                .offset(y: -8)
//                                .matchedGeometryEffect(id: "currentTab", in: currentTab)
//                        }
                        if (tab.id == "add"){
                            Image(systemName: tab.icon)
                                .frame(height: 44).font(.system(size: 34))
                        }
                        else {
                            Image(systemName: tab.icon)
                                .frame(height: 20)
                            Text(tab.label)
                                .font(.caption)
                                .fixedSize()
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(width: geometry.size.width / 2, height: 44, alignment: .bottom)
                    .padding(.horizontal)
                    .foregroundColor(selectedTab == tab.id ? Color(.label) : .secondary)
                    .onTapGesture{
                        selectedTab = tab.id
//                        withAnimation{
//                            selectedTab = tab.id
//                        }
                    }
                }.frame(height: 44, alignment: .bottom)
            }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TabBarView(selectedTab: Binding.constant("home"), shouldShowModal: Binding.constant(false))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            TabBarView(selectedTab: Binding.constant("home"), shouldShowModal: Binding.constant(false))
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
        }
    }
}
