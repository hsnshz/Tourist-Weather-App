//
//  CWK2TemplateApp.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import SwiftUI

@main
struct CWK2TemplateApp: App {
    @StateObject var weatherMapViewModel = WeatherMapViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(weatherMapViewModel)
        }
    }
}
