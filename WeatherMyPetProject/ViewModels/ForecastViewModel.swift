//
//  MainViewModel.swift
//  WeatherMyPetProject
//
//  Created by MAC on 4/20/24.
//

import Foundation
import SwiftUI

enum CityType: String, CaseIterable {
    case minsk = "Minsk"
    case london = "London"
    case newYork = "New-York"
    case paris = "Paris"
    case rome = "Rome"
    
    var coordinates:(lat:String,lon:String) {
        switch self {
            case .minsk:
                (lat: "53.906761", lon: "27.561822")
            case .london:
                (lat: "51.507351",lon: "-0.127696")
            case .newYork:
                (lat: "40.714627",lon: "-74.002863")
            case .paris:
                (lat: "48.856663",lon: "2.351556")
            case .rome:
                (lat: "41.887064",lon: "12.504809")
        }
    }
}

final class ForecastViewModel:ObservableObject {
    
    let settings = Settings.shared
    
    private(set) var forecastProcessing:ForecastProcessing?
    var forecastDaysAll:[InfoWeatherDay] {
        forecastProcessing?.getForecastDays(.all) ?? []
    }
    
    @AppStorage("timeSavedForecast") private(set) var timeSavedForecast = "load forecast"
    
    private func saveTimeForecast() {
        timeSavedForecast = DateFormatter.localizedString(from: Date() , dateStyle: .medium, timeStyle: .short)
    }
    
    @Published private(set) var state = DataState.na("N/A data")
    @Published private(set) var showImage = false
    @Published var showNetworkNA = false
    
    @Published var cityCurrent:CityType = .minsk {
        willSet {
            settings.selectedCity = newValue.rawValue
        }
    }
    
    init() {
        if let city = CityType(rawValue: settings.selectedCity) {
            cityCurrent = city
        }
    }
        
    
    func fetchForecastServer() {
        state = .loading
        
        NetworkingService.shared.dataTask(.forecast(lat: cityCurrent.coordinates.lat, lon: cityCurrent.coordinates.lon), type: Forecast.self) { [weak self] result in
            
            guard let self else { return }
            
            DispatchQueue.main.async {
                
                switch result {
                    case .success(let successForecast):
                        self.settings.savedForecast = successForecast
                        self.settings.isForecastLoad = true
                        self.saveTimeForecast()
                        
                        self.forecastProcessing = ForecastProcessing(forecast: successForecast)
                        self.showImage = true
                        self.showNetworkNA = false
                        self.state = .loaded
                    case .failure(let err):
                        self.state = .error(err)
                }
            }
        }
    }
    
    func fetchForecastLocal() {
        showImage = false
        
        state = .loading
        
        if let forecast = settings.savedForecast {
            self.forecastProcessing = ForecastProcessing(forecast: forecast)
            self.showNetworkNA = false
            state = .loaded
        } else {
            state = .error(.customString("There isn't saved forecast!"))
        }
    }
}

private extension ForecastViewModel {
    func fetchForecastLocalJSON() {
          state = .loading
  
          guard let path = Bundle.main.path(forResource: "TestJSON", ofType: "json") else {
              state = .error(.customString("Файл не найден"))
              return
          }
  
          do {
              let url = URL(fileURLWithPath: path)
              let data = try Data(contentsOf: url)
              let decodedData = try JSONDecoder().decode(Forecast.self, from: data)
              
              forecastProcessing = ForecastProcessing(forecast: decodedData)
              state = .loaded
          } catch {
              state = .error(.customString("Ошибка при чтении файла: \(error)"))
          }
      }
}
