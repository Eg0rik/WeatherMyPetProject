//
//  BackgroundView.swift
//  WeatherMyPetProject
//
//  Created by MAC on 4/20/24.
//

import SwiftUI

struct BackgroundView: View {
    @EnvironmentObject var backgroundVM:BackgroundViewModel
    
    var query:String
    
    var body: some View {
        VStack {
            if let image = backgroundVM.image {
                image
                    .resizable()
            } else {
                ProgressView()
            }
        }
        .frame(height: 200)
        .onAppear {
            backgroundVM.loadImages(query: query)
        }
    }
}

#Preview {
    ContentView()
}
