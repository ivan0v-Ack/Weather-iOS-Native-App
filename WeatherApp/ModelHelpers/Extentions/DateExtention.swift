//
//  DateExtention.swift
//  WeatherApp
//
//  Created by Ivan Ivanov on 3/22/21.
//

import Foundation

extension Date {
    
    func shortDate() -> String {
        
       // dateFormatter.dateFormat = "MM/dd/yyyy"
        // short date format
        
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .none
//        let dateString = dateFormatter.string(from: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: self)
        
    }
    
    func justTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
    
    func dayOfTheWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
}
