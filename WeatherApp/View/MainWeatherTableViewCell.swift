//
//  MainWeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Ivan Ivanov on 3/24/21.
//

import UIKit

class MainWeatherTableViewCell: UITableViewCell {
    
    var cityTempData: CityTempData? {
        didSet {
            guard let cityTempData = cityTempData else {return}
            cityLabel.text = cityTempData.city
            cityLabel.adjustsFontSizeToFitWidth = true
            temperatureLabel.text = String(format: "%.0f%@", getTempBasedOnSettings(celsius: cityTempData.temp), returnTempFormatFromUserDefaults())
        }
    }

    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
