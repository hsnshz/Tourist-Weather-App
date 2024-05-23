//
//  DailyWeatherView.swift
//  CWK2Template
//
//  Created by girish lukka on 02/11/2023.
//

import SwiftUI

struct DailyWeatherView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    var day: Daily

    var body: some View {
        HStack {
            if let iconCode = day.weather.first?.icon {
                let iconURL = weatherMapViewModel.fetchWeatherIconURL(iconCode: iconCode)
                AsyncImage(url: iconURL) {
                    image in image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
            }

            Spacer()

            VStack(alignment: .center, spacing: 5) {
                Text(day.weather.first?.weatherDescription.rawValue.capitalized(with: Locale.current) ?? "N/A")
                    .font(.system(size: 14, weight: .medium))

                let formattedDate = DateFormatterUtils.formattedDateWithWeekdayAndDay(from: TimeInterval(day.dt))
                Text(formattedDate)
                    .font(.system(size: 14, weight: .medium))
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)

            Spacer()

            Text("\(String(Int(day.temp.max.rounded())))ºC/\(String(Int(day.temp.min.rounded())))ºC")
                .font(.system(size: 14, weight: .medium))
        }
    }
}

struct DailyWeatherView_Previews: PreviewProvider {
    static var previews: some View {
        if let day = WeatherMapViewModel().weatherDataModel?.daily.first {
            DailyWeatherView(day: day)
                .environmentObject(WeatherMapViewModel())
        } else {
            Text("Data not available")
        }
    }
}
