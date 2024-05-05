//
//  CitySelector.swift
//  WeatherMyPetProject
//
//  Created by MAC on 5/4/24.
//

import Foundation
import SwiftUI

struct CitySelector:View {
    @EnvironmentObject var forecastVM:ForecastViewModel
    
    var body: some View {
        Picker("",selection: $forecastVM.cityCurrent) {
            ForEach(CityType.allCases,id:\.rawValue) { item in
                Text(item.rawValue)
                    .tag(item)
                    .onChange(of:forecastVM.cityCurrent) {
                        forecastVM.fetchForecastServer()
                    }
            }
        }
        .pickerStyle(.menu)
    }
}

#Preview {
    ContentView()
}
