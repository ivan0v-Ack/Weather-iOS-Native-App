//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by Ivan Ivanov on 3/22/21.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    
    var weeklyWeatherData: WeatherData? {
        didSet {
            
            guard let weeklyWeatherData = weeklyWeatherData else {return}
            dayOfTheWeek.text = currnetDateFromUnix(weeklyWeatherData.ts).dayOfTheWeek()
            tempLabel.text = String(format:"%.f%@",getTempBasedOnSettings(celsius: weeklyWeatherData.temp!), returnTempFormatFromUserDefaults())
            weatherImageIconView.image = UIImage(named: weeklyWeatherData.weather!.icon!)
        }
    }

    @IBOutlet weak var dayOfTheWeek: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImageIconView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
