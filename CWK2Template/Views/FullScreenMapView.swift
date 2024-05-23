//
//  FullScreenMapView.swift
//  CWK2Template
//
//  Created by Hassan Shahzad on 05/12/2023.
//

import CoreLocation
import Foundation
import MapKit
import SwiftUI

struct FullScreenMapView: View {
    var locations: [Location]
    @State var mapRegion: MKCoordinateRegion
    @Binding var isPresenting: Bool

    var body: some View {
        ZStack {
            Map(coordinateRegion: $mapRegion, showsUserLocation: true, annotationItems: locations) { location in
                MapMarker(coordinate: location.coordinates, tint: .red)
            }
            .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Button(action: {
                        isPresenting = false
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    .padding()
                    Spacer()
                }
                Spacer()
            }
        }
    }
}
