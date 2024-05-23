//
//  WeatherForcastView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import SwiftUI

struct WeatherForecastView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "sun.min.fill")

                        VStack {
                            Text("Weather Forecast for \(weatherMapViewModel.city)")
                                .font(.title3)
                                .fontWeight(.bold)
                        }
                    }
                    .padding(.leading)

                    if let hourlyData = weatherMapViewModel.weatherDataModel?.hourly {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(hourlyData) { hour in
                                    HourWeatherView(current: hour)
                                        .frame(width: 150, height: 145)
                                        .padding()
                                }
                                .background(Color.teal)
                                .cornerRadius(10)
                            }
                            .padding(.horizontal, 16)
                        }
                        .frame(height: 180)
                    }

                    Divider()
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                }
                .padding(.horizontal, 16)
                .padding(.top, 40)
                .frame(height: 340)
                .background(Color.blue.opacity(0.3))

                VStack {
                    List {
                        ForEach(weatherMapViewModel.weatherDataModel?.daily ?? []) { day in
                            DailyWeatherView(day: day)
                        }
                        .background(
                            Image("background")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .scaledToFill()
                                .opacity(0.3)
                        )
                    }

                    .listStyle(GroupedListStyle())
                    .frame(height: 500)
                }
            }
            .ignoresSafeArea(edges: .all)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct WeatherForcastView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherForecastView()
            .environmentObject(WeatherMapViewModel())
    }
}
