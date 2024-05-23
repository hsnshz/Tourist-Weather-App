//
//  PlacesDataModel.swift
//  CWK2Template
//
//  Created by girish lukka on 01/11/2023.
//

import CoreLocation
import Foundation

struct Location: Identifiable, Codable {
    var id = UUID()
    let name: String
    let cityName: String
    let coordinates: CLLocationCoordinate2D
    let description: String
    let imageNames: [String]
    let link: String

//    enum CodingKeys: String, CodingKey {
//        case name, cityName, coordinates, description, imageNames, link
    enum CodingKeys: String, CodingKey {
        case name
        case cityName
        case latitude
        case longitude
        case description
        case imageNames
        case link
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        cityName = try container.decode(String.self, forKey: .cityName)
        description = try container.decode(String.self, forKey: .description)
        imageNames = try container.decode([String].self, forKey: .imageNames)
        link = try container.decode(String.self, forKey: .link)

        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(cityName, forKey: .cityName)
        try container.encode(coordinates.latitude, forKey: .latitude)
        try container.encode(coordinates.longitude, forKey: .longitude)
        try container.encode(description, forKey: .description)
        try container.encode(imageNames, forKey: .imageNames)
        try container.encode(link, forKey: .link)
    }
}
