//
//  PlacesView.swift
//  CWK2Template
//
//  Created by Hassan Shahzad on 05/12/2023.
//
//

import MapKit
import SwiftUI

struct PlacesView: View {
    var place: Location
    @Binding var isPresenting: Bool

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    ImageCarouselView(imageNames: place.imageNames)

                    Text(place.name)
                        .font(.headline)
                        .padding()

                    Text(place.description)
                        .font(.subheadline)
                        .padding()

                    Link("Wikipedia", destination: URL(string: place.link) ?? URL(string: "https://www.wikipedia.org")!)
                        .font(.subheadline)
                        .padding()

                    MapView(place: place)
                }
                .navigationTitle(place.cityName)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Back") { isPresenting = false }
                    }
                }
            }
        }
    }
}

struct MapView: View {
    var place: Location

    var body: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: place.coordinates, span: MKCoordinateSpan(latitudeDelta: 0.015, longitudeDelta: 0.015))),
            annotationItems: [place])
        { _ in
            MapMarker(coordinate: place.coordinates, tint: .red)
        }
        .frame(height: 300)
        .edgesIgnoringSafeArea(.all)
    }
}

struct ImageCarouselView: View {
    var imageNames: [String]
    @State private var selectedImageIndex: Int = 0

    var body: some View {
        TabView(selection: $selectedImageIndex) {
            ForEach(imageNames.indices, id: \.self) { index in
                Image(imageNames[index])
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.main.bounds.width, height: 300)
                    .clipped()
                    .tag(index)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(width: UIScreen.main.bounds.width, height: 300)

        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(imageNames.indices, id: \.self) { index in
                    Image(imageNames[index])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedImageIndex == index ? Color.blue : Color.clear, lineWidth: 3)
                        )
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                selectedImageIndex = index
                            }
                        }
                }
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
        }
    }
}
