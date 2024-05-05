//
//  ErrorView.swift
//  WeatherMyPetProject
//
//  Created by MAC on 4/21/24.
//

import Foundation
import SwiftUI

struct ErrorView: View {
    let error:MyError
    
    var body: some View {
        VStack {
            Text("ErrorView")
            
            switch error {
                case .urlError:
                    NetworkNAView()
                default:
                    Text(error.description)
            }
        }
    }
}
