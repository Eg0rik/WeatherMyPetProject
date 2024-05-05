//
//  Settings.swift
//  WeatherMyPetProject
//
//  Created by MAC on 5/4/24.
//

import Foundation

final class Settings {
    
    static let shared = Settings()
    private init() { }
    
    var isForecastLoad:Bool {
        get {
            UserDefaults.standard.bool(forKey: "isForecastLoad")
        }
        set {
            UserDefaults.standard.setValue(true, forKey: "isForecastLoad")
        }
    }
    
    var selectedCity:String {
        get {
            UserDefaults.standard.string(forKey: "selectedCity")!
        } set {
            UserDefaults.standard.setValue(newValue, forKey: "selectedCity")
        }
    }
    
    var savedForecast:Forecast? {
        get {
            guard let savedData = UserDefaults.standard.data(forKey: "forecast") else { return nil }
            
            let forecast = try! JSONDecoder().decode(Forecast.self, from: savedData)
            return forecast
        } set {
            let data = try! JSONEncoder().encode(newValue)
            UserDefaults.standard.setValue(data, forKey: "forecast")
        }
    }
    
    private func removeFirstLoad() {
        UserDefaults.standard.removeObject(forKey: "firstLoad")
    }
}
