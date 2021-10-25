//
//  PlayListView.swift
//  podcast
//
//  Created by Dmitry Burnaev on 22.06.2021.
//

import SwiftUI

struct TaskRow: View {
    var body: some View {
        Text("Task data goes here")
    }
}

struct PlayListView: View {
    var body: some View {
        NavigationView{

            List {
                
                Section(header: Text("Other tasks")) {
                    TaskRow()
                    TaskRow()
                    TaskRow()
                }

                Section(header: Text("Other tasks")) {
                    TaskRow()
                    TaskRow()
                    TaskRow()
                }
                
            }
            Text("Playlist")
        }
    }
}

struct PlayListView_Previews: PreviewProvider {
    static var previews: some View {
        PlayListView()
            .previewLayout(.sizeThatFits)
    }
}
