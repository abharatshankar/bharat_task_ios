//
//  WeatherViewModel.swift
//  WeatherAppTask
//
//  Created by Bharath Shankar on 08/04/23.
//

import Foundation
import UIKit

class WeatherViewModel{
    var weatherInteractor = WeatherInteractor()
    
    private var weatherModel : WeatherData?
    private var cityName: String {
        get {
            guard let weatherModel = weatherModel else { return ""}
            return weatherModel.name
        }
    }

    private var temperatureString: String {
        guard let weatherModel = weatherModel else { return "0"}
        return String(format: "%.1f", weatherModel.main.temp)
    }
    
    private var weatherConditionIcon: String{
        guard let weatherModel = weatherModel, let iconArr = weatherModel.weather?[0] else { return "0"}
        return iconArr.icon
    }
    
    var updateWithLatestData:((String, String) -> Void)?
    var updateWeatherIcon:((UIImage) -> Void)?

    init() {
       weatherInteractor.delegate = self
    }
    
    func fetchWeather(latitude lat: Double , longitude lon: Double){
        weatherInteractor.fetchWeather(latitude: lat, longitude: lon)
    }
    
    func fetchWeather(_ cityName: String) {
        weatherInteractor.fetchWeather(cityName)
    }
    
    func fetchImageFromName(_ imageName: String){
        weatherInteractor.fetchImageFromName(imageName)
    }
        
    func saveDefaultLocation(_ lat: Double?,_ lon: Double?) {
        if let lat = lat, let lon = lon {
            Util.setValue(lat, forKey: WeatherAppContants.UserDefaults.savedLat)
            Util.setValue(lon, forKey: WeatherAppContants.UserDefaults.savedLon)
        }
    }
}

extension WeatherViewModel: WeatherMangerDelegate {
    
    func didUpdateWeatherInteractor(_ weatherManager: WeatherInteractor, weather: WeatherData) {
        print("---received response---")
        DispatchQueue.main.sync {
            // self.fetchImageFromName(weatherConditionIcon)
            self.saveDefaultLocation(weather.coord.lat, weather.coord.lon)
            self.weatherModel = weather
            self.updateWithLatestData?( self.temperatureString, self.cityName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func didReceivedImage(_ image: UIImage) {
        DispatchQueue.main.sync {
            self.updateWeatherIcon?(image)
        }
    }
}


