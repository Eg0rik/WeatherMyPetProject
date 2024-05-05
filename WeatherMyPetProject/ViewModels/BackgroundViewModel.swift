//
//  WeatherViewModel.swift
//  WeatherMyPetProject
//
//  Created by MAC on 4/19/24.
//

import Foundation
import SwiftUI

final class BackgroundViewModel:ObservableObject {
    
    @Published var dataState = DataState.na("nil image")
    
    private(set) var images = [Image]()
    private var page:PhotoResults?
    
    var image:Image? {
        images.randomElement()
    }
    
    private let networkingService = NetworkingService.shared
    
    func loadImages(query:String) {
        
        dataState = .loading
        
        networkingService.dataTask(.images(query: query), type: PhotoResults.self) { [weak self] result in
            
            DispatchQueue.main.async {
                switch result {
                    case .success(let successPage):
                        self?.page = successPage
                        self?.loadImagesServer()
                    case .failure(let err):
                        self?.dataState = .error(err)
                        print(err)
                }
            }
        }
    }
    
    private func loadImagesServer() {
        
        guard let page else { return }
        
        var imagesLoading = [Image]()
        let dispatchGroup = DispatchGroup()
        
        for result in page.results {
            let urlStr = result.urls.small
            
            dispatchGroup.enter()
            
            networkingService.dowloadImage(urlStr: urlStr) { result in
                
                switch result {
                    case .success(let uiImage):
                        imagesLoading.append(Image(uiImage: uiImage))
                    case .failure(let err):
                        print(err)
                }
                
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            self.images = imagesLoading
            self.dataState = .loaded
        }
    }
}
