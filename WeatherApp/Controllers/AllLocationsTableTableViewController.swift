//
//  AllLocationsTableTableViewController.swift
//  WeatherApp
//
//  Created by Ivan Ivanov on 3/23/21.
//

import UIKit

protocol AllLocationsTableTableViewControllerDelegate {
    func didChooseLocatio(atIndex: Int, shouldRefresh: Bool)
}

class AllLocationsTableTableViewController: UITableViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var tempSegmentOutlet: UISegmentedControl!
    @IBOutlet weak var fotterView: UIView!
    
    // MARK: - Vars
    var savedLocation: [WeatherLoacation]?
    var weatherData: [CityTempData]?
    
    var delegate: AllLocationsTableTableViewControllerDelegate?
    var shouldRefresh = false
    let userDefaults = UserDefaults.standard
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = fotterView
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        tempSegmentOutlet.setTitleTextAttributes(titleTextAttributes, for: .normal)
        tempSegmentOutlet.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .selected)
        
        loadLocationsFromUserDefaults()
        loadTempFormatFromUserDefaults()
    }
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherData?.count ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainWeatherTableViewCell
        cell.cityTempData = weatherData![indexPath.row]
        
        return cell
    }
    // MARK: - IBActions
    
    @IBAction func tempSegmentValueChanged(_ sender: UISegmentedControl) {
        updateTempFormatInUserDefaults(newValue: sender.selectedSegmentIndex)
    }
    
    
    // MARK: - TableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didChooseLocatio(atIndex: indexPath.row, shouldRefresh: self.shouldRefresh)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let locationToDelete = weatherData?[indexPath.row]
            weatherData?.remove(at: indexPath.row)
            removeLocationFromSavedLocations(location: locationToDelete!.city)
            tableView.reloadData()
        }
    }
    
    // MARK: - Remove Locations
    private func removeLocationFromSavedLocations(location: String){
        if savedLocation != nil {
            for i in 0..<savedLocation!.count {
                let tempLocation = savedLocation![i]
                if tempLocation.city == location {
                    savedLocation!.remove(at: i)
                    saveNewLocationsToUserDefaults()
                    return
                }
            }
        }
    }
    
    
    
    // MARK: - UserDefaults
    
    private func loadLocationsFromUserDefaults(){
        if let data = userDefaults.value(forKey: "Locations") as? Data {
            savedLocation = try? PropertyListDecoder().decode([WeatherLoacation].self, from: data)
        }
    }
    
    private func saveNewLocationsToUserDefaults(){
        shouldRefresh = true
        userDefaults.setValue(try? PropertyListEncoder().encode(savedLocation!), forKey: "Locations")
        userDefaults.synchronize()
    }
    
    private func updateTempFormatInUserDefaults(newValue: Int) {
        shouldRefresh = true
        userDefaults.set(newValue, forKey: "TempFormat")
        userDefaults.synchronize()
    }
    
    private func loadTempFormatFromUserDefaults(){
        
        if let index = userDefaults.value(forKey: "TempFormat") {
            tempSegmentOutlet.selectedSegmentIndex = index as! Int
        }else {
            tempSegmentOutlet.selectedSegmentIndex = 0
        }
    }
    
    
    // MARK: - Navigation Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseLocationSeg" {
            let vc = segue.destination as! ChooseCityViewController
            vc.modalPresentationStyle = .fullScreen
            vc.delegate = self
        }
    }
}

extension AllLocationsTableTableViewController: ChooseCityViewControllerDelegate {
    func didAdd(newLocation: WeatherLoacation) {
        shouldRefresh = true
        weatherData?.append(CityTempData(city: newLocation.city, temp: 0.0))
        tableView.reloadData()
    }
}
