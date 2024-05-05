//
//  MyError.swift
//  WeatherMyPetProject
//
//  Created by MAC on 5/4/24.
//

import Foundation

enum MyError:Error {
    case invalidUrl
    case invalidStatusCode(Int)
    case invalidData
    case failedToDecode(Error)
    case urlError(URLError)
    case custom(Error)
    case customString(String)
}

extension MyError {
    
    var description: String {
        switch self {
            case .invalidUrl:
                "URL isn't valid"
            case .invalidStatusCode:
                "Status code falls into the wrong range"
            case .invalidData:
                "Response data is invalid"
            case .urlError(let err):
                "\(err)"
            case .failedToDecode:
                "Failed to decode"
            case .custom(let err):
                "\(err)"
            case .customString(let description):
                description
        }
    }
}
