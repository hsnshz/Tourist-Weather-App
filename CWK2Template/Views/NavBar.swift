//
//  NavBar.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import SwiftUI

struct NavBar: View {
    var body: some View {
        TabView {
            WeatherNowView()
                .tabItem {
                    Label("City", systemImage: "magnifyingglass")
                }
            WeatherForecastView()
                .tabItem {
                    Label("Forecast", systemImage: "calendar")
                }
            TouristPlacesMapView()
                .tabItem {
                    Label("Place Map", systemImage: "map")
                }
        }
    }
}

struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBar()
            .environmentObject(WeatherMapViewModel())
    }
}
