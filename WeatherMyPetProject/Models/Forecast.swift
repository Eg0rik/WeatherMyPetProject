//
//  Model.swift
//  WeatherMyPetProject
//
//  Created by MAC on 4/19/24.
//

import Foundation

// MARK: - Forecast
struct Forecast: Codable {
//    let cod: String
//    let message, cnt: Int
    var list: [InfoWeatherTime]
    let city: City
}

// MARK: - City
struct City: Codable {
//    let id: Int
    let name: String
    let coord: Coord
    let country: String
//    let population, timezone, sunrise, sunset: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double
}

// MARK: - List
struct InfoWeatherTime: Codable {
//    let dt: Int
    let main: Main
    let weatherArray: [Weather]
//    let clouds: Clouds
    let wind: Wind
//    let visibility: Int?
//    let pop: Double
//    let rain: Rain?
//    let sys: Sys
    let dtTxt: String  //"2024-04-19 15:00:00" to "15:00"

    enum CodingKeys: String, CodingKey {
        case main,wind
        case dtTxt = "dt_txt"
        case weatherArray = "weather"
    }
}

extension InfoWeatherTime {
    var weather:Weather {
        weatherArray.first!
    }
    var dayAndTime:String {
        day + time
    }
    var time:String {
        String(dtTxt.dropFirst(11).dropLast(3))
    }
    var day:String {
        String(dtTxt.dropFirst(8).dropLast(9))
    }
    var month:String {
        String(dtTxt.dropFirst(5).dropLast(12))
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Main
struct Main: Codable {
    let temp, feelsLike: Double
    let humidity:Int
//    let pressure, seaLevel, grndLevel, humidity: Int
//    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp,humidity
        case feelsLike = "feels_like"
//        case tempMin = "temp_min"
//        case tempMax = "temp_max"
//        case pressure
//        case seaLevel = "sea_level"
//        case grndLevel = "grnd_level"
//        case tempKf = "temp_kf"
    }
}

extension Main {
    var tempCelsius:String {
        String(format: "%.0fc",temp - 273)
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: String
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int
    let main, description, icon: String
}

extension Weather {
    
    private enum IconName:String  {
        
        case rain = "Rain"
        case sun = "Sun"
        case clouds = "Clouds"
        case snow = "Snow"
        case clear = "Clear"
        
        var iconSystemName:String {
            switch self {
                case .rain:
                    "cloud.rain.fill"
                case .sun:
                    "sun.max.fill"
                case .clouds:
                    "smoke.fill"
                case .snow:
                    "cloud.snow.fill"
                case .clear:
                    "sun.min.fill"
            }
        }
    }

    var iconSystemName:String {
        IconName(rawValue: main)?.iconSystemName ?? "questionmark"
    }
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double
//    let deg: Int
//    let gust: Double
}
