//
//  NetworkNA.swift
//  WeatherMyPetProject
//
//  Created by MAC on 5/4/24.
//

import Foundation
import SwiftUI

struct NetworkNAView: View {
    
    var body: some View {
        VStack {
            Image(systemName: "wifi.slash")
                .font(.system(size: 50))
                .frame(width: 50, height: 50, alignment: .center)
                .padding(.bottom, 24)
            Text("Network not available")
                .alert(isPresented: .constant(true)) {
                    Alert(title: Text("Network not available"), message: Text("Turn on mobile data or use Wi-Fi to access data"), dismissButton: .default(Text("OK")))
                }
        }
    }
}

#Preview {
    ContentView()
}
