import Foundation

//lat - Latitude. If you need the geocoder to automatic convert city names and zip-codes to geo coordinates and the other way around, please use our Geocoding API
//lon - Longitude. If you need the geocoder to automatic convert city names and zip-codes to geo coordinates and the other way around, please use our Geocoding API
//appid - Your unique API key (you can always find it on your account page under the "API key" tab)
//cnt - A number of days, which will be returned in the API response (from 1 to 16). Learn more

enum Endpoint {
    case forecast(lat:String,lon:String,appid:String = "8318bcaad8fb79d1e304d29c27a2e9e7")
    case images(query:String,appid:String = "OOB01xA1Odl-984HH8tHVmNv35gAynVoxoYxobpGevI")
}

extension Endpoint {
    
    var host:String {
        
        switch self {
            case .forecast:
                "api.openweathermap.org"
            case .images:
                "api.unsplash.com"
        }
    }
    
    var path:String {
        switch self {
            case .images:
                "/search/photos"
            case .forecast:
                "/data/2.5/forecast"
        }
    }
    
    var queryItems: [String:String]? {
        switch self {
            case .forecast(let lat,let lon,let appid):
                ["lat":lat,"lon":lon,"appid":appid]
            case .images(let query, let appid):
                ["query":query,"client_id":appid]
        }
    }
}

extension Endpoint {
    var url:URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = host
        urlComponents.path = path
        
        var requestQueryItems = [URLQueryItem]()
        
        queryItems?.forEach {
            requestQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        
        urlComponents.queryItems = requestQueryItems
        
        return urlComponents.url
    }
}



extension Endpoint {
    enum MethodType: Equatable {
        case GET
        case POST(data: Data?)
    }
    
    var methodType: MethodType {
        switch self {
            default:
                return .GET
        }
    }
}

