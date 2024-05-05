//
//  Weather.swift
//  WeatherMyPetProject
//
//  Created by MAC on 4/20/24.
//

import Foundation

final class ForecastProcessing {
    
    enum ForecastDayType {
        case today
        case anotherDay(String)
        case nowAndLaterToday
    }
    
    enum ForecastDaysType {
        case all
        case withDays([String])
        case allWithoutToday
    }
    
    private var forecast:Forecast
    private var groupedByDate = [InfoWeatherDay]()
    private(set) var timeSinceLastUpdate = ""
    
    init(forecast:Forecast) {
        self.forecast = forecast
        groupedByDate = groupByDate(forecast)
    }
    
    var cityName:String {
        forecast.city.name
    }
    var countryName:String {
        forecast.city.country
    }
    var typeWeatherNow:String {
        getForecastDay(.today)?.array.first?.weather.main ?? "error nil"
    }
    
    func getForecastDays(_ type:ForecastDaysType) -> [InfoWeatherDay] {
        
        guard groupedByDate.count > 0 else { return [] }
        
        return switch type {
            case .all:
                createForecastAll()
            case .withDays(let days):
                createForecastWithDays(days)
            case .allWithoutToday:
                createForecastAllWithoutToday()
        }
    }
    
    func getForecastDay(_ type:ForecastDayType) -> InfoWeatherDay? {
        switch type {
            case .today:
                createForecastToday()
            case .anotherDay(let dayStr):
                createForecastDay(dayStr)
            case .nowAndLaterToday:
                createForecastNowAndLaterToday()
        }
    }
    
    private func createForecastDay(_ day:String) -> InfoWeatherDay? {
        groupedByDate.first { $0.day == day}
    }
    
    private func createForecastToday() -> InfoWeatherDay? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        let currentDateString = dateFormatter.string(from: Date())
        
        return groupedByDate.first { $0.day == currentDateString }
    }
    
    //MARK: sort all createForecast
    private func createForecastNowAndLaterToday() -> InfoWeatherDay? {
        let infoWeatherDay = createForecastToday()
        
        guard let infoWeatherDay else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let currentDate = Date()
        
        let filteredArray = infoWeatherDay.array
            .filter { (dateFormatter.date(from: $0.dtTxt) ?? Date()) > currentDate }
        
        //MARK: sort like here
        let sortedArray = filteredArray.sorted {
            let date1 = dateFormatter.date(from: $0.dtTxt) ?? Date()
            let date2 = dateFormatter.date(from: $1.dtTxt) ?? Date()
            return date1 < date2
        }
        
        return InfoWeatherDay(day: infoWeatherDay.day, array: sortedArray)
    }
    
    private func createForecastAllWithoutToday() -> [InfoWeatherDay] {
        let currentDateString = convertDateToString(date: Date(), dateFormat: .day)
        
        let filteredArray = groupedByDate.filter { $0.day != currentDateString }
        
        return sortInfoWeatherDay(filteredArray)
    }
    
    private func createForecastAll() -> [InfoWeatherDay] {
        groupedByDate
    }
    
    private func createForecastWithDays(_ days:[String]) -> [InfoWeatherDay] {
        var result = [InfoWeatherDay]()
        
        for day in days {
            if let infoWeatherDay = groupedByDate.first(where: { $0.day == day}) {
                result.append(infoWeatherDay)
            }
        }
        
        return result
    }
    
    func setForecast(_ forecast:Forecast) {
        self.forecast = forecast
        groupedByDate = groupByDate(forecast)
    }
    
    func takeForecast(day:String) -> [InfoWeatherTime] {
        groupedByDate.first {$0.day == day}?.array ?? []
    }
    
    private func sortInfoWeatherDay(_ array:[InfoWeatherDay]) -> [InfoWeatherDay] {
        array.sorted {
            day1, day2 in
            convertStringToDate(str: day1.day, dateFormat: .day)! <  convertStringToDate(str: day2.day, dateFormat: .day)!
        }
    }
    
    private func groupByDate(_ forecast:Forecast) -> [InfoWeatherDay] {

        var forecastsGroupedByDate: [String: [InfoWeatherTime]] = [:]
        
        for item in forecast.list {
            
            if let date = convertStringToDate(str: item.dtTxt,dateFormat: .long) {
                
                let key = convertDateToString(date: date, dateFormat: .day)
                
                if forecastsGroupedByDate[key] != nil {
                    forecastsGroupedByDate[key]!.append(item)
                } else {
                    forecastsGroupedByDate[key] = [item]
                }
                
            }
        }
        
        var resultArray = [InfoWeatherDay]()
        
        for key in forecastsGroupedByDate.keys {
            resultArray.append(InfoWeatherDay(day: key, array: forecastsGroupedByDate[key]!))
        }

        return sortInfoWeatherDay(resultArray)
    }
}

extension ForecastProcessing {
    
    enum DateFormatType {
        case long
        case day
        
        var string:String {
            switch self {
                case .day:
                    "MM-dd"
                case .long:
                    "yyyy-MM-dd HH:mm:ss"
            }
        }
    }
    
    func convertStringToDate(str:String,dateFormat:DateFormatType) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.string
        return dateFormatter.date(from: str)
    }
    
    func convertDateToString(date:Date,dateFormat:DateFormatType) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat.string
        return dateFormatter.string(from: date)
    }
    
}
