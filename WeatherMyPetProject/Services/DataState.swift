//
//  DataState.swift
//  WeatherMyPetProject
//
//  Created by MAC on 4/26/24.
//

import Foundation

enum DataState {
    
    case na(String)
    case loading
    case loaded
    case error(MyError)
    
    var descriptoin:String {
        switch self {
            case .na(let str):
                "N/A - \(str)"
            case .loading:
                "loading data"
            case .loaded:
                "success data"
            case .error(let err):
                err.description
        }
    }
}
