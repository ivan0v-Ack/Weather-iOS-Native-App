//
//  GlobalHelpers.swift
//  WeatherApp
//
//  Created by Ivan Ivanov on 3/22/21.
//

import Foundation
import UIKit

func currnetDateFromUnix(_ unixDate: Double?) -> Date {
    if unixDate != nil {
        return Date(timeIntervalSince1970: unixDate!)
    }
    return Date()
}

func fahrenheitFrom(celsius: Double) -> Double {
    return (celsius * 9/5) + 32
}

func getTempBasedOnSettings(celsius: Double) -> Double {
 
    let format = returnTempFormatFromUserDefaults()
    return format == TempFormat.celsius ? celsius : fahrenheitFrom(celsius: celsius)
}

func returnTempFormatFromUserDefaults() -> String{
    if let tempFormat = UserDefaults.standard.value(forKey: "TempFormat"){
        return tempFormat as! Int == 0 ? TempFormat.celsius : TempFormat.fahrenheit
    }else {
        return TempFormat.celsius
    }
}

