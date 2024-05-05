//
//  HorizontalView.swift
//  WeatherMyPetProject
//
//  Created by MAC on 4/19/24.
//

import SwiftUI

struct HorizontalView: View {
    
    let infoWeatherTimeArray:[InfoWeatherTime]
    
    @EnvironmentObject var forecastVM:ForecastViewModel
    
    @State var showDescriptionView = false
    @State var choosenInfoWeatherTime:InfoWeatherTime?
    
    var body: some View {
        
        ScrollView(.horizontal,showsIndicators: false) {
            
            HStack {
                HStack(spacing:35) {
                    ForEach(infoWeatherTimeArray,id:\.dtTxt) { infoWeatherTime in
                        
                        Button {
                            showDescriptionView = true
                            choosenInfoWeatherTime = infoWeatherTime
                        } label: {
                            FormView(infoWeatherTime: infoWeatherTime)
                        }
                        .sheet(isPresented: $showDescriptionView) {
                            
                            if let forecastProcessing = forecastVM.forecastProcessing {
                                DescriptionView(infoWeatherTime: $choosenInfoWeatherTime,forecastProcessing: forecastProcessing)
                            }
                        }
                    }
                }
                .padding()
            }
            .foregroundStyle(.white)
            .background(.black.opacity(0.8))
            .clipShape(
                RoundedRectangle(cornerRadius: 10)
            )
        }
    }
}

#Preview {
    ContentView()
}
