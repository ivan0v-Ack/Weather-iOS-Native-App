//
//  ForcastCollectionViewCell.swift
//  WeatherApp
//
//  Created by Ivan Ivanov on 3/22/21.
//

import UIKit

class ForcastCollectionViewCell: UICollectionViewCell {
    
    var hourlyWeatherData: WeatherData? {
        didSet {
            
            guard let hourlyWeatherData = hourlyWeatherData else {return}
            timeLabel.text = currnetDateFromUnix(hourlyWeatherData.ts).justTime()
            temperatureLabel.text = String(format:"%.0f%@", getTempBasedOnSettings(celsius: hourlyWeatherData.temp!), returnTempFormatFromUserDefaults())
            imageView.image = UIImage(named: hourlyWeatherData.weather!.icon!)
        }
    }
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
