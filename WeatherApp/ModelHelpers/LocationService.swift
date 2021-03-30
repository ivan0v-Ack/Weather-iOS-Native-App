//
//  LocationService.swift
//  WeatherApp
//
//  Created by Ivan Ivanov on 3/24/21.
//

import Foundation


class LocationService {
    
    static var shared = LocationService()
    
    var longitude: Double!
    var latitude: Double!
    var city: String!
    var country: String!
    
}
