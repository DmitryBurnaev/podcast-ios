import SwiftUI

struct Tab: Identifiable{
    var id: String
    
    let label, icon: String
}

let tabs: [Tab] = [
    .init(id: "home",     label: "Home",        icon: "house"),
    .init(id: "podcasts", label: "Podcasts",    icon: "filemenu.and.selection"),
    .init(id: "add",      label: "Add Episode", icon: "plus.app.fill"),
    .init(id: "playlist", label: "Playlist",    icon: "play.rectangle"),
    .init(id: "profile",  label: "Profile",     icon: "person"),
]



struct TabView: View {
    @Binding var selectedTab: String
    @Binding var shouldShowModal: Bool

    var body: some View {
        HStack{
            ForEach(tabs, id: \.id){ tab in
                Button(action: {
                    if tab.id == "add" {
                        shouldShowModal.toggle()
                        return
                    }
                    selectedTab = tab.id
                }, label: {
                    Spacer()
                    if tab.id == "add" {
                        Image(systemName: tab.icon)
                            .font(.system(size: 44))
                            .foregroundColor(.red)
                    } else {
                        Image(systemName: tab.icon)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(selectedTab == tab.id ? Color(.label) : .init(white: 0.8))
                    }
                    Spacer()
                })
            }
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TabView(selectedTab: Binding.constant("home"), shouldShowModal: Binding.constant(false))
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            TabView(selectedTab: Binding.constant("home"), shouldShowModal: Binding.constant(false))
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
            TabView(selectedTab: Binding.constant("home"), shouldShowModal: Binding.constant(false))
                .previewLayout(.sizeThatFits)
            TabView(selectedTab: Binding.constant("home"), shouldShowModal: Binding.constant(false))
                .previewLayout(.sizeThatFits)
        }
    }
}
