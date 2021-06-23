//
//  PlayListView.swift
//  podcast
//
//  Created by Dmitry Burnaev on 22.06.2021.
//

import SwiftUI

struct PlayListView: View {
    var body: some View {
        NavigationView{
            ScrollView{
                Divider()
                ForEach(0..<100){ num in
                    Text("Episode #\(num)")
                }
            }.navigationBarTitle(Text("Episodes"), displayMode: .inline)
        }
    }
}

struct PlayListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayListView()
            .previewLayout(.sizeThatFits)
    }
}
