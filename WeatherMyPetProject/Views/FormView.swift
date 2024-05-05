//
//  FormView.swift
//  WeatherMyPetProject
//
//  Created by MAC on 4/26/24.
//

import SwiftUI

struct FormView:View {
    
    let infoWeatherTime:InfoWeatherTime
    
    var time:String {
        infoWeatherTime.time
    }
    var temp:String {
        infoWeatherTime.main.tempCelsius
    }
    var icon:Image {
        Image(systemName: infoWeatherTime.weather.iconSystemName)
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(time)
            icon
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width:30,height: 40)
            Text(temp)
        }
        .foregroundStyle(.white)
    }
}

#Preview {
    ContentView()
}
