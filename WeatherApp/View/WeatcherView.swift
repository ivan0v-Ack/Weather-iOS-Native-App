//
//  WeatcherView.swift
//  WeatherApp
//
//  Created by Ivan Ivanov on 3/22/21.
//

import UIKit

class WeatcherView: UIView {
    
    // MARK: - IBOutlets
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherInfoLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var infoCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    var weeklyWeatherData: [WeatherData] = []
    var dailyWeatherData: [WeatherData] = []
    var weatherInfoData: [WeatherInfo] = []
    
    var currentData: WeatherData? {
        didSet{
            guard let currentData = currentData else {return}
            cityNameLabel.text = currentData.city_name
            dateLabel.text = "Today, \(currnetDateFromUnix(currentData.ts).shortDate())"
            tempLabel.text = String(format:"%.0f%@", getTempBasedOnSettings(celsius: currentData.temp!), returnTempFormatFromUserDefaults())
            weatherInfoLabel.text = currentData.weather!.description
            
            setupWeatherInfo(currentInfo: currentData)
            infoCollectionView.reloadData()
        }
    }
    
    private func setupWeatherInfo(currentInfo: WeatherData){
        let windInfo = WeatherInfo(infoText: String(format: "%.1f m/sec", currentInfo.wind_spd!), nameText: nil, image: UIImage(named: "wind"))
        let humidity = WeatherInfo(infoText: String(format: "%.0f", currentInfo.rh!), nameText: nil, image: UIImage(named: "humidity"))
        let pressureInfo = WeatherInfo(infoText: String(format: "%.0f mb", currentInfo.pres!), nameText: nil, image: UIImage(named: "pressure"))
        let visabilityInfo = WeatherInfo(infoText: String(format: "%.0f km", currentInfo.vis!), nameText: nil, image: UIImage(named: "visibility"))
        let feelsLikeInfo = WeatherInfo(infoText: String(format: "%.1f", getTempBasedOnSettings(celsius: currentInfo.app_temp!)), nameText: nil, image: UIImage(named: "feelsLike"))
        let uvInfo = WeatherInfo(infoText: String(format: "%.1f", currentInfo.uv!), nameText: "UV Index", image: nil)
        let sunriseInfo = WeatherInfo(infoText: currentInfo.sunrise!, nameText: nil, image: UIImage(named: "sunrise"))
        let sunsetInfo = WeatherInfo(infoText: currentInfo.sunset!, nameText: nil, image: UIImage(named: "sunset"))
        weatherInfoData = [windInfo,humidity,pressureInfo,visabilityInfo,feelsLikeInfo,uvInfo,sunriseInfo,sunsetInfo]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        mainInit()
    }
    
    private func mainInit(){
        Bundle.main.loadNibNamed("WeatcherView", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        setupTableView()
        setupInfoCollectionView()
        setuoHourlyCollectionView()
        
    }
    
    private func setupTableView(){
        
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "Cell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
    }
    
    private func setuoHourlyCollectionView(){
        hourlyCollectionView.register(UINib(nibName: "ForcastCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "Cell")
        hourlyCollectionView.dataSource = self
    }
    private func setupInfoCollectionView(){
        infoCollectionView.register(UINib(nibName: "InfoCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "Cell")
        infoCollectionView.dataSource = self
    }
    
}

extension WeatcherView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyWeatherData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeatherTableViewCell
        cell.weeklyWeatherData = weeklyWeatherData[indexPath.row]
        return cell
    }
    
    
}
extension WeatcherView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hourlyCollectionView {
            return dailyWeatherData.count
            
        }else {
           
            return weatherInfoData.count
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == hourlyCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ForcastCollectionViewCell
            cell.hourlyWeatherData = dailyWeatherData[indexPath.row]
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! InfoCollectionViewCell
            cell.infoCurrentDay = weatherInfoData[indexPath.row]
            return cell
        }
    }
    
    
}


