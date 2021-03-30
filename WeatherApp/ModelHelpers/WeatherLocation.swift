//
//  WeatherLocation.swift
//  WeatherApp
//
//  Created by Ivan Ivanov on 3/23/21.
//

import Foundation


struct WeatherLoacation:Codable, Equatable {
    var city: String
    var country:String
    var countryCode: String
    var isCurrentLocation: Bool
}
