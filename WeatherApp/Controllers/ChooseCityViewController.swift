//
//  ChooseCityViewController.swift
//  WeatherApp
//
//  Created by Ivan Ivanov on 3/23/21.
//

import UIKit

protocol ChooseCityViewControllerDelegate {
    func didAdd(newLocation: WeatherLoacation)
}

class ChooseCityViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Vars
    var delegate: ChooseCityViewControllerDelegate?
    
    var allLocations:[WeatherLoacation] = []
    var filteredLocations:[WeatherLoacation] = []
    
    var savedLocations: [WeatherLoacation]?
    let userDefaults = UserDefaults.standard
    
    let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        setupSearchController()
        tableView.tableHeaderView = searchController.searchBar
        
        setupUpGesture()
        loadLocationsFromCSV()
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadFormUserDefaults()
    }
    
    private func setupSearchController(){
        
        searchController.searchBar.placeholder = "City or Country"
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchController.searchBar.sizeToFit()
        searchController.searchBar.backgroundImage = UIImage()
        
        if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = UIColor.white
            textfield.textColor = .black
        }
        
    }
    
    // MARK: - Gesture Recognise
    
    private func setupUpGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView?.addGestureRecognizer(tap)
    }
    
    @objc func tableTapped(){
        dissmisView()
    }
    
    // MARK: - Get Locations
    
    private func loadLocationsFromCSV(){
        if let path = Bundle.main.path(forResource: "location", ofType: "csv"){
            parseSCVAt(url: URL(fileURLWithPath: path))
        }
    }
    
    private func parseSCVAt(url: URL) {
        do{
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8 )
            
            if let dataArr = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: ",")}) {
                var i = 0
                for line in dataArr {
                    if line.count > 2 && i != 0 {
                        createLocation(line: line)
                    }
                    i += 1
                }
            }
        } catch {
            print("Error reading CSV file, ", error.localizedDescription)
        }
    }
    
    private func createLocation(line: [String] ){
        allLocations.append(WeatherLoacation(city: line[1], country: line[4], countryCode: line[3], isCurrentLocation: false))
    }
    
    // MARK: - UserDefaults
    
    private func saveToUserDefaults(location: WeatherLoacation){
        if savedLocations != nil {
            if !savedLocations!.contains(location){
                savedLocations!.append(location)
            }
        }else {
            savedLocations = [location]
        }
        userDefaults.setValue(try? PropertyListEncoder().encode(savedLocations!), forKey: "Locations")
        userDefaults.synchronize()
        
    }
    
    private func loadFormUserDefaults(){
        if let data = userDefaults.value(forKey: "Locations") as? Data {
            savedLocations = try? PropertyListDecoder().decode([WeatherLoacation].self, from: data)
        }
    }
    
    private func dissmisView(){
        if searchController.isActive {
            searchController.dismiss(animated: true) {
                self.dismiss(animated: true, completion: nil)
            }
        }else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
}

extension ChooseCityViewController: UISearchResultsUpdating {
    
    func filterContentForSearchText(searchText: String, scope:String = "All"){
        filteredLocations = allLocations.filter({ (location) -> Bool in
            
            return location.city.lowercased().contains(searchText.lowercased()) ||
                location.country.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    
}

extension ChooseCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = filteredLocations[indexPath.row].city
        cell.detailTextLabel?.text = filteredLocations[indexPath.row].country
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("click")
        saveToUserDefaults(location: filteredLocations[indexPath.row])
        delegate?.didAdd(newLocation: filteredLocations[indexPath.row])
        dissmisView()
    }
}
