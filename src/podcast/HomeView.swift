//
//  HomeView.swift
//  podcast
//
//  Created by Dmitry Burnaev on 22.06.2021.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView{
            ScrollView{
                LazyVGrid(columns: [
                    GridItem(.flexible(minimum: 100, maximum: 200), spacing: 12),
                    GridItem(.flexible(minimum: 100, maximum: 200), spacing: 12),
                    GridItem(.flexible(minimum: 100, maximum: 200)),
                ], spacing: 12, content: {
                    ForEach(0..<20, id: \.self){ num in
                        VStack(alignment: .leading){
                            Spacer()
                                .frame(width: 90, height: 90)
                                .background(Color.blue)
                            Text("Podcast name")
                                .font(.system(size: 10, weight: .semibold))
                        }
                        .padding()
                        .background(Color.gray)

                    }
                }).padding(.horizontal, 15)
            }.navigationTitle("Favorite podcast")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
