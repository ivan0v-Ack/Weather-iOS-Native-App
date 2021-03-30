//
//  InfoCollectionViewCell.swift
//  WeatherApp
//
//  Created by Ivan Ivanov on 3/22/21.
//

import UIKit

class InfoCollectionViewCell: UICollectionViewCell {

    var infoCurrentDay: WeatherInfo? {
        didSet {
            
            guard let infoCurrentDay = infoCurrentDay else {return}
            infoLabel.text = infoCurrentDay.infoText
            infoLabel.adjustsFontSizeToFitWidth = true
            
            if infoCurrentDay.image != nil {
                nameLabel.isHidden = true
                infoImageView.isHidden = false
               infoImageView.image = infoCurrentDay.image
            }else {
                nameLabel.isHidden = false
                infoImageView.isHidden = true
                nameLabel.text = infoCurrentDay.nameText
                nameLabel.adjustsFontSizeToFitWidth = true
                
            }
        
            
        }
    }
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var infoImageView: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func genereteCell(weatherInfo: WeatherInfo) {
        
    }

}
