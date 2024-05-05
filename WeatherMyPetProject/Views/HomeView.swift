//
//  HomeView.swift
//  WeatherMyPetProject
//
//  Created by MAC on 4/19/24.
//

import SwiftUI

struct HomeView: View {
    
    let settings = Settings.shared
    
    @StateObject var networkingMonitor = NetworkingMonitor.shared
    @StateObject var forecastVM = ForecastViewModel()
    @StateObject var backgroundVM = BackgroundViewModel()
    
    var body: some View {
        
        ScrollView {
            
            switch forecastVM.state {
                case .loaded:
                    loadedView()
                case .error(let err):
                    ErrorView(error:err)
                default:
                    VStack {
                        Text("loading forecast")
                        ProgressView()
                    }
            }
        }
        .onAppear {
            if networkingMonitor.isNetworkConnected {
                forecastVM.fetchForecastServer()
            } else if settings.isForecastLoad {
                forecastVM.fetchForecastLocal()
            } else {
                forecastVM.showNetworkNA = true
            }
        }
        .onChange(of:networkingMonitor.isNetworkConnected) { isConnected in
            if isConnected {
                forecastVM.fetchForecastServer()
            }
        }
        .toolbar {
            Button {
                forecastVM.fetchForecastServer()
            } label: {
                HStack {
                    Text("refresh")
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
    
    func loadedView() -> some View {
        VStack {
            CitySelector()
            
            Text("forecast was loaded at:\n\(forecastVM.timeSavedForecast)")
            
            if forecastVM.showImage {
                BackgroundView(query:forecastVM.cityCurrent.rawValue)
            }
            
            ForecastVerticalView(infoWeatherDayArray: forecastVM.forecastDaysAll)
                .padding(.leading)
        }
        .environmentObject(backgroundVM)
        .environmentObject(forecastVM)
    }
}

#Preview {
    ContentView()
}
