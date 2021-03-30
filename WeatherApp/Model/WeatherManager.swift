//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Ivan Ivanov on 3/21/21.
//

import Foundation
import CoreLocation

class Service: NSObject {
    
    static let shared = Service()
    
    
    let currentBaseURL = "https://api.weatherbit.io/v2.0/current?&key=83cc397e72434b31b26bd6fa6786c536"
    let currentWeeklyBaseURL = "https://api.weatherbit.io/v2.0/forecast/daily?&key=83cc397e72434b31b26bd6fa6786c536&days=7"
    let currentDailyBaseURL = "https://api.weatherbit.io/v2.0/forecast/hourly?&key=83cc397e72434b31b26bd6fa6786c536&hours=24"
    let baseURLHourly = "https://api.weatherbit.io/v2.0/forecast/hourly?key=83cc397e72434b31b26bd6fa6786c536&hours=24&lat=\(String(LocationService.shared.latitude!))&lon=\(String(LocationService.shared.longitude!))"
    let baseURLDaily = "https://api.weatherbit.io/v2.0/forecast/daily?key=83cc397e72434b31b26bd6fa6786c536&days=7&lat=\(String( LocationService.shared.latitude!))&lon=\(String(LocationService.shared.longitude!))"
    let coorditaneBaseUrl = "https://api.weatherbit.io/v2.0/current?key=83cc397e72434b31b26bd6fa6786c536&lat=\(String( LocationService.shared.latitude))&lon=\(String(LocationService.shared.longitude))"
    
    
    func fetchDataFunc(withURL: String, completion: @escaping (Result<ArrData, Error>)-> Void){
        
        guard let url = URL(string: withURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                }
                
                guard let urlResponse = response as? HTTPURLResponse, (200...299).contains(urlResponse.statusCode),
                      let data = data
                else { return }
                do {
                    
                    let parseData = try JSONDecoder().decode(ArrData.self, from: data)
                    
                    completion(.success(parseData))
                }catch let parseError {
                    
                    completion(.failure(parseError))
                }
            }
        }.resume()
    }
}


