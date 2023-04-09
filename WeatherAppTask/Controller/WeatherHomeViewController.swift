//
//  ViewController.swift
//  WeatherAppTask
//
//  Created by Bharath Shankar on 08/04/23.
//

import UIKit
import CoreLocation

class WeatherHomeViewController: UIViewController {
    
    @IBOutlet weak var currentWeatherConditionImageView: UIImageView!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var currentCityLabel: UILabel!
    @IBOutlet weak var textFieldLabel: UITextField!
    
    var lat: Double = 0.0
    var lon: Double = 0.0
    var isUserUpdatedLocation = false
    var viewModel:WeatherViewModel?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        bindViewModelInfo()
        textFieldLabel.delegate = self
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        #if targetEnvironment(simulator)
        if let defaultLocaionLat = Util.getValue(WeatherAppContants.UserDefaults.savedLat) as? Double, let defaultLocaionLon = Util.getValue(WeatherAppContants.UserDefaults.savedLon) as? Double {
            lat = defaultLocaionLat
            lon = defaultLocaionLon
            viewModel?.fetchWeather(latitude: defaultLocaionLat, longitude: defaultLocaionLon)
        }
        #else
        #endif
        
    }
    
    private func bindViewModelInfo(){
        viewModel = WeatherViewModel()
        viewModel?.updateWithLatestData = { [weak self] (temperatureValue, cityName) in
            self?.currentTemperatureLabel.text = temperatureValue
            self?.currentCityLabel.text = cityName
        }
        viewModel?.updateWeatherIcon = { [weak self] (imageIcon) in
            self?.currentWeatherConditionImageView.image = imageIcon
        }
        
    }
    
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        viewModel?.fetchWeather(latitude: lat, longitude: lon)
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        textFieldLabel.endEditing(true)
        print(textFieldLabel.text!)
    }    
}

// MARK: - UITextFieldDelegate
extension WeatherHomeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldLabel.endEditing(true)
        print(textFieldLabel.text!)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cityName = textField.text {
            viewModel?.fetchWeather(cityName)
        }
        textField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            textField.placeholder = "Search"
            return true
        } else {
            textField.placeholder = "Please enter a city name"
            return false
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension WeatherHomeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var serviceParamLat = 0.0
        var serviceParamLon = 0.0
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            lat = Double(location.coordinate.latitude)
            lon = Double(location.coordinate.longitude)
            if isUserUpdatedLocation {
                return
            }
            serviceParamLat = lat
            serviceParamLon = lon
            isUserUpdatedLocation = true
        }
        if let defaultLocaionLat = Util.getValue(WeatherAppContants.UserDefaults.savedLat) as? Double, let defaultLocaionLon = Util.getValue(WeatherAppContants.UserDefaults.savedLon) as? Double {
            serviceParamLat = defaultLocaionLat
            serviceParamLon = defaultLocaionLon
        }
        viewModel?.fetchWeather(latitude: serviceParamLat, longitude: serviceParamLon)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Swift.Error) {
        print("Error is: \(error)")
    }
}

