//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Ivan Ivanov on 3/22/21.
//

import UIKit
import CoreLocation


class WeatherViewController: UIViewController {
    
    let weatherView = WeatcherView()
    var weatherLocation: WeatherLoacation!
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - Vars
    let userDefaults = UserDefaults.standard
    var locationManager: CLLocationManager?
    var currnetLocation: CLLocationCoordinate2D!
    
    var allLocations: [WeatherLoacation] = []
    var allWeatherViews: [WeatcherView] = []
    var allWeatherData: [CityTempData] = []
    
    var shouldRefresh = true
    
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManagerStart()
        scrollView.delegate = self
   
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldRefresh {
            
            allLocations = []
            allWeatherViews = []
            removeViewSFromScrollView()
            
            locationAuthCheck()
            
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManagerStop()
    }
    
    // MARK: - Download Weather
    
    
    private func getWeather(){
        loadlocationsFromUserDefaults()
        createWeatherView()
        addWeatherToScrollView()
        setPageCronrollPageNumber()
        
    }
    
    
    func getCurrentData(location : WeatherLoacation, view: WeatcherView){
        var CityUrl = ""
        if location.isCurrentLocation {
            CityUrl = Service.shared.coorditaneBaseUrl
        }else {
            CityUrl = Service.shared.currentBaseURL + "&city=" + location.city + "," + location.country
        }
        
        Service.shared.fetchDataFunc(withURL: CityUrl) { (res) in
            switch res {
            case .failure(let err):
                print("I can't fatch data ", err)
            case .success(let result):
                view.currentData = result.data[0]
                self.generateWeatherList()
                
                
            }
        }
    }
    
    func getWeeklyWeather(location : WeatherLoacation, view: WeatcherView){
        var CityUrl = ""
        if location.isCurrentLocation {
            CityUrl = Service.shared.baseURLDaily
        }else {
            CityUrl = Service.shared.currentWeeklyBaseURL + "&city=" + location.city + "," + location.country
            
        }
        Service.shared.fetchDataFunc(withURL: CityUrl) { (res) in
            switch res {
            case .failure(let err):
                print("I can't fatch data ", err)
            case .success(let result):
                view.weeklyWeatherData = result.data
                view.weeklyWeatherData.remove(at: 0)
                view.tableView.reloadData()
                
            }
        }
        
    }
    func getDailyWeather(location : WeatherLoacation, view: WeatcherView){
        var CityUrl = ""
        if location.isCurrentLocation {
            CityUrl = Service.shared.baseURLHourly
        }else {
            CityUrl = Service.shared.currentDailyBaseURL + "&city=" + location.city + "," + location.country
        }
        
        Service.shared.fetchDataFunc(withURL: CityUrl) { (res) in
            switch res {
            case .failure(let err):
                print("I can't fatch data ", err)
            case .success(let result):
                view.dailyWeatherData = result.data
                view.hourlyCollectionView.reloadData()
                
            }
        }
        
    }
    
    
    private func removeViewSFromScrollView(){
        print("ScrollViewCounts = \(scrollView.subviews.count)")
        for subview in scrollView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    private func createWeatherView(){
        for _ in allLocations {
            allWeatherViews.append(WeatcherView())
        }
    }
    
    private func addWeatherToScrollView(){
        print(" AllWeatherScrollView has \(allWeatherViews.count)")
        for i in 0..<allWeatherViews.count {
            print("I is \(i)")
            let weatherView = allWeatherViews[i]
            let location = allLocations[i]
            
            
            getCurrentData(location: location, view: weatherView)
            getWeeklyWeather(location: location, view: weatherView)
            getDailyWeather(location: location, view: weatherView)
            
            let xPos = self.view.frame.width * CGFloat(i)
            weatherView.frame = CGRect(x: xPos, y: 0, width: scrollView.bounds.width, height: scrollView.bounds.height)
            scrollView.addSubview(weatherView)
            scrollView.contentSize.width = weatherView.frame.width * CGFloat(i + 1)
        }
    }
    
    // MARK: - Load Locations from UserDefaults
    
    private func loadlocationsFromUserDefaults () {
        
        let currentLocation = WeatherLoacation(city: "", country: "", countryCode: "", isCurrentLocation: true)
        
        if let data = userDefaults.value(forKey: "Locations") as? Data{
            allLocations = try! PropertyListDecoder().decode([WeatherLoacation].self, from: data)
            allLocations.insert(currentLocation, at: 0)
            
            
        }else {
            print("No UserData in UserDefaults!")
            allLocations.append(currentLocation)
        }
    }
    
    // MARK: - PageControl
    
    private func setPageCronrollPageNumber(){
        print("We Have \(allWeatherViews.count) pages in ScrollView")
        pageControl.numberOfPages = allWeatherViews.count
    }
    
    private func updatePageConrolSelectedPage(currentPage: Int){
        pageControl.currentPage = currentPage
        pageControl.currentPageIndicatorTintColor = .darkGray
    }
    
    // MARK: - Location Manager
    
    private func locationManagerStart(){
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
            locationManager!.delegate = self
        }
        locationManager!.startMonitoringSignificantLocationChanges()
    }
    private func locationManagerStop(){
        if locationManager != nil {
            locationManager!.stopMonitoringSignificantLocationChanges()
        }
    }
    private func locationAuthCheck(){
        
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            currnetLocation = locationManager?.location?.coordinate
            if currnetLocation != nil {
                
                LocationService.shared.latitude = currnetLocation.latitude
                LocationService.shared.longitude = currnetLocation.longitude
                getWeather()
                
            }else {
                locationAuthCheck()
            }
        }else {
            locationManager?.requestWhenInUseAuthorization()
            locationAuthCheck()
        }
    }
    
    private func generateWeatherList(){
        allWeatherData = []
        for weatherView in allWeatherViews {
            guard let infoData = weatherView.currentData else {return}
            let tempData = CityTempData(city: infoData.city_name!, temp: infoData.temp!)
            allWeatherData.append(tempData)
            
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allLocationSeg" {
            let vc = segue.destination as! AllLocationsTableTableViewController
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self
            vc.weatherData = allWeatherData
        }
    }
}


extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Faild to get location ", error.localizedDescription)
    }
}

extension WeatherViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x / scrollView.frame.size.width
        updatePageConrolSelectedPage(currentPage: Int(round(value)))
    }
}

extension WeatherViewController: AllLocationsTableTableViewControllerDelegate {
    func didChooseLocatio(atIndex: Int, shouldRefresh: Bool) {
        let viewNumber = CGFloat(integerLiteral: atIndex)
        let newOffSet = CGPoint(x: (scrollView.frame.width + 1.0) * viewNumber, y: 0)
        scrollView.setContentOffset(newOffSet, animated: true)
        updatePageConrolSelectedPage(currentPage: atIndex)
        self.shouldRefresh = shouldRefresh
    }
    
    
}
