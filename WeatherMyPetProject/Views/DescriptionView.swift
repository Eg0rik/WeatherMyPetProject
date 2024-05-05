//
//  DescriptionView.swift
//  WeatherMyPetProject
//
//  Created by MAC on 4/27/24.
//

import SwiftUI

struct DescriptionView: View {
    
    @Environment(\.dismiss) var dismiss
    @Binding var infoWeatherTime:InfoWeatherTime?
    
    @EnvironmentObject var backgroundVM:BackgroundViewModel
    @EnvironmentObject var forecastVM:ForecastViewModel
    
    var forecastProcessing:ForecastProcessing
    
    var city:String {
        forecastProcessing.cityName
    }
    var country:String {
        forecastProcessing.countryName
    }
    var icon:String {
        infoWeatherTime!.weather.icon
    }
    var main:String {
        infoWeatherTime!.weather.main
    }
    var description:String {
        infoWeatherTime!.weather.description
    }
    var iconName:String {
        infoWeatherTime!.weather.iconSystemName
    }
    var day:String {
        infoWeatherTime!.day
    }
    var time:String {
        infoWeatherTime!.time
    }
    var month:String {
        infoWeatherTime!.month
    }
    var infoTime:String {
        """
    month - \(month)
    day - \(day)
    time - \(time)
    """
    }
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
            
            VStack(spacing:15) {
                
                Button("--- exit view ---") {
                    dismiss()
                }
                .padding(.bottom)
                
                Text(city)
                
                if forecastVM.showImage {
                    ScrollView(.horizontal,showsIndicators: false) {
                        HStack {
                            ForEach(backgroundVM.images.indices,id:\.self) { index in
                                backgroundVM.images[index]
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width:200,height: 200)
                            }
                        }
                    }
                }
                
                Text(country)
                Text(infoTime)
                Text(main)
                Text(description)
                Image(systemName: iconName)
            }
            .foregroundStyle(.white)
        }
    }
}

#Preview {
    ContentView()
}
