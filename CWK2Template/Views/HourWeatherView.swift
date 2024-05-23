//
//  HourWeatherView.swift
//  CWK2Template
//
//  Created by girish lukka on 02/11/2023.
//

import SwiftUI

struct HourWeatherView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    var current: Current

    var body: some View {
        let formattedDate = DateFormatterUtils.formattedDateWithDay(from: TimeInterval(current.dt))
        VStack(alignment: .center, spacing: 5) {
            Text(formattedDate)
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal)
                // .background(Color.white)
                .foregroundColor(.black)

            if let iconCode = current.weather.first?.icon {
                let iconURL = weatherMapViewModel.fetchWeatherIconURL(iconCode: iconCode)

                AsyncImage(url: iconURL) {
                    image in image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
                .padding(.horizontal)
            }

            Text("\(String(Int(current.temp.rounded())))ºC")
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal)

            Text(current.weather.first?.weatherDescription.rawValue.capitalized(with: Locale.current) ?? "N/A")
                .font(.system(size: 14, weight: .medium))
                .padding(.horizontal)
        }
    }
}
