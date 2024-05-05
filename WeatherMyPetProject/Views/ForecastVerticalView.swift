//
//  VerticalView.swift
//  WeatherMyPetProject
//
//  Created by MAC on 4/22/24.
//

import Foundation
import SwiftUI

struct ForecastVerticalView: View {
    
    var infoWeatherDayArray:[InfoWeatherDay]
    
    var body: some View {
        LazyVStack {
            ForEach(infoWeatherDayArray,id:\.day) { infoWeatherDay in
                Text(infoWeatherDay.day)
                HorizontalView(infoWeatherTimeArray: infoWeatherDay.array)
            }
        }
    }
}

#Preview {
    ContentView()
}
