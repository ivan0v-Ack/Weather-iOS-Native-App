//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Ivan Ivanov on 3/21/21.
//

import Foundation


struct ArrData: Decodable{
    let data: [WeatherData]

}

struct WeatherData: Decodable {
    let city_name: String? // CityName
    let ts: Double? // ast observation time (Unix timestamp).
    let temp: Double? //  Temperature (default Celcius).
    let app_temp: Double? //Feels Like" temperature (default Celcius).
    let pres: Double? // presure //mb
    let rh: Double? // humidity (%).
    let wind_spd : Double? // wind Speed meter/sec
    let vis: Double? //Visibility (default KM).
    let uv: Double? //UV Index (0-11+).
    let sunrise: String? // Sunrise time (HH:MM).
    let sunset: String? // Sunset time (HH:MM).
    let weather: Weather?
    
    
    
}

struct Weather: Decodable {
    let icon: String? // Weather icon code.
    let code: Int? // Weather code.
    let description: String? //Text weather description.
}





