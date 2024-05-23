//
//  TouristPlacesMapView.swift
//  CWK2Template
//
//  Created by girish lukka on 29/10/2023.
//

import CoreLocation
import Foundation
import MapKit
import SwiftUI

struct TouristPlacesMapView: View {
    @EnvironmentObject var weatherMapViewModel: WeatherMapViewModel
    @State var locations: [Location] = []
    @State var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.5216871, longitude: -0.1391574), latitudinalMeters: 5000, longitudinalMeters: 5000)

    @State private var selectedLocation: Location?
    @State private var showingDetail = false
    @State private var showingFullScreenMap = false

    var placesViewSheetBinding: Binding<Bool> {
        Binding(
            get: { self.showingDetail },
            set: {
                self.showingDetail = $0
                if !$0 {
                    self.selectedLocation = nil
                }
            }
        )
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 5) {
                if weatherMapViewModel.coordinates != nil {
                    ZStack(alignment: .bottomTrailing) {
                        Map(coordinateRegion: $mapRegion, showsUserLocation: true, annotationItems: locations) {
                            location in MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.coordinates.latitude, longitude: location.coordinates.longitude), tint: Color.red)
                        }
                        .edgesIgnoringSafeArea(.all)
                        .frame(height: 300)

                        Button(action: {
                            showingFullScreenMap = true
                        }) {
                            Image(systemName: "map.fill")
                                .padding()
                                .background(Color.blue.opacity(0.8))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        .padding()
                    }

                    Text("Tourist Attractions in \(weatherMapViewModel.city)")
                        .font(.system(size: 20))
                        .bold()
                        .padding(.top)
                }

                List {
                    if locations.isEmpty {
                        Spacer()
                        HStack {
                            Text("List of attractions coming soon!")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding()
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 3, x: 0, y: 2)
                        .padding()
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)

                    } else {
                        ForEach(locations) { location in
                            HStack {
                                Image(location.imageNames.first ?? "placeholder")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(5)

                                Text(location.name)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .padding(.leading)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .background(Color(UIColor.systemBackground))
                            .cornerRadius(10)
                            .shadow(color: .gray, radius: 3, x: 0, y: 2)
                            .padding()
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                self.selectedLocation = location
                                self.showingDetail = true
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal)
            }
            .sheet(isPresented: placesViewSheetBinding) {
                if let place = selectedLocation {
                    PlacesView(place: place, isPresenting: placesViewSheetBinding)
                }
            }
            .fullScreenCover(isPresented: $showingFullScreenMap) {
                FullScreenMapView(locations: locations, mapRegion: mapRegion, isPresenting: $showingFullScreenMap)
            }
        }
        .onAppear {
            // process the loading of tourist places
            if let newCoordinates = weatherMapViewModel.coordinates {
                mapRegion.center = newCoordinates
            }

            locations = weatherMapViewModel.annotations
            locations = locations.filter { $0.cityName == weatherMapViewModel.city }
        }
    }
}

struct TouristPlacesMapView_Previews: PreviewProvider {
    static var previews: some View {
        TouristPlacesMapView()
            .environmentObject(WeatherMapViewModel())
    }
}
