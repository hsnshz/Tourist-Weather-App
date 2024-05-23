//
//  WeatherNowView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import CoreLocation
import Foundation
import MapKit
import SwiftUI

struct WeatherNowView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    @State private var isLoading = false
    @State private var temporaryCity = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        ZStack {
            Image("sky")
                .resizable()
                .edgesIgnoringSafeArea(.top)
                .opacity(0.5)

            VStack {
                HStack {
                    Text("Change Location")

                    TextField("Enter New Location", text: $temporaryCity)
                        .onSubmit {
                            let geocoder = CLGeocoder()
                            geocoder.geocodeAddressString(temporaryCity) { placemarks, error in
                                if let _ = error {
                                    alertMessage = "Invalid city name. Please enter a valid location."
                                    showingAlert = true
                                    temporaryCity = ""
                                    return
                                } else if let placemarks = placemarks, !placemarks.isEmpty {
                                    weatherMapViewModel.city = temporaryCity.capitalized(with: Locale.current)

                                    Task {
                                        do {
                                            // write code to process user change of location
                                            try await weatherMapViewModel.getCoordinatesForCity()

                                            if let coordinates = weatherMapViewModel.coordinates {
                                                let weatherData = try await weatherMapViewModel.loadData(lat: coordinates.latitude, lon: coordinates.longitude)

                                                weatherMapViewModel.weatherDataModel = weatherData
                                            }
                                            isLoading = true

                                            temporaryCity = ""

                                        } catch {
                                            print("Error: \(error)")
                                            isLoading = false
                                        }
                                    }
                                } else {
                                    print("No results found for the city name")
                                }
                            }
                        }
                }
                .bold()
                .font(.system(size: 20))
                .padding(10)
                .shadow(color: .blue, radius: 10)
                .cornerRadius(10)
                .fixedSize()
                .font(.custom("Arial", size: 26))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .cornerRadius(15)

                VStack {
                    HStack {
                        Text("Current Location: \(weatherMapViewModel.city)")
                    }
                    .bold()
                    .font(.system(size: 20))
                    .padding(10)
                    .shadow(color: .blue, radius: 10)
                    .cornerRadius(10)
                    .fixedSize()
                    .font(.custom("Arial", size: 26))
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .cornerRadius(15)

                    let timestamp = TimeInterval(weatherMapViewModel.weatherDataModel?.current.dt ?? 0)

                    let formattedDate = DateFormatterUtils.formattedDateTime(from: timestamp, timezoneOffset: weatherMapViewModel.weatherDataModel?.timezoneOffset ?? 0)

                    Text(formattedDate)
                        .padding()
                        .font(.title)
                        .foregroundColor(.black)
                        .shadow(color: .black, radius: 1)

                    Spacer()
                        .frame(height: 40)

                    HStack {
                        var weatherDescription: String {
                            if let firstWeather = weatherMapViewModel.weatherDataModel?.current.weather.first {
                                return firstWeather.weatherDescription.rawValue
                            } else {
                                return "N/A"
                            }
                        }

                        if let iconCode = weatherMapViewModel.weatherDataModel?.current.weather.first?.icon {
                            let iconURL = weatherMapViewModel.fetchWeatherIconURL(iconCode: iconCode)
                            AsyncImage(url: iconURL) {
                                image in image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 50, height: 50)
                            .padding(.leading, 45)
                        }

                        Text(weatherDescription.capitalized(with: Locale.current))
                            .font(.system(size: 25, weight: .medium))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(2)

                    HStack {
                        var tempString: String {
                            if let forecast = weatherMapViewModel.weatherDataModel {
                                return "Temp: \(String(format: "%.2f", forecast.current.temp)) ºC"
                            } else {
                                return "Temp: N/A"
                            }
                        }

                        Label(title: { Text(tempString)
                                .font(.system(size: 25, weight: .medium))
                        }, icon: { Image("temperature")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .padding(.leading, 50)
                        })
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)

                    HStack {
                        let humidity = "Humidity: " + String(weatherMapViewModel.weatherDataModel?.current.humidity ?? 0) + "%"

                        Label(title: { Text(humidity)
                                .font(.system(size: 25, weight: .medium))
                        }, icon: { Image("humidity")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .padding(.leading, 50)
                        })
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)

                    HStack {
                        let pressure = "Pressure: " + String(weatherMapViewModel.weatherDataModel?.current.pressure ?? 0) + " hPa"

                        Label(title: { Text(pressure)
                                .font(.system(size: 25, weight: .medium))
                        }, icon: { Image("pressure")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .padding(.leading, 50)
                        })
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)

                    HStack {
                        let windspeed = "Windspeed: " + String(weatherMapViewModel.weatherDataModel?.current.windSpeed ?? 0) + " mph"

                        Label(title: { Text(windspeed)
                                .font(.system(size: 25, weight: .medium))
                        }, icon: { Image("windSpeed")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .padding(.leading, 50)
                        })
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                } // VS2
            } // VS1
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
}

struct WeatherNowView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherNowView()
            .environmentObject(WeatherMapViewModel())
    }
}
