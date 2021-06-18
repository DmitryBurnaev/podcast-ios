//
//  ContentView.swift
//  podcast
//
//  Created by Dmitry Burnaev on 12.06.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, podcasts!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 11")
    }
}
