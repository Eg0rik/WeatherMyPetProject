//
//  File.swift
//  WeatherMyPetProject
//
//  Created by MAC on 5/4/24.
//

import Foundation
import Network

final class NetworkingMonitor:ObservableObject {
    
    static let shared = NetworkingMonitor()
    
    private let monitor = NWPathMonitor()
    
    @Published private(set) var isNetworkConnected = false
    
    private init() {
        startMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isNetworkConnected = path.status == .satisfied
            }
        }
        
        monitor.start(queue: .global())
    }
}
