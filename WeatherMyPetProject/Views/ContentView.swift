//
//  ContentView.swift
//  WeatherMyPetProject
//
//  Created by MAC on 4/19/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
           HomeView()
                .navigationTitle("Forecast")
        }
    }
}

#Preview {
    ContentView()
}
