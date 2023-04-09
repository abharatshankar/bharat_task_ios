//
//  WeatherInteractor.swift
//  WeatherAppTask
//
//  Created by Bharath Shankar on 08/04/23.
//

import Foundation
import UIKit

protocol WeatherMangerDelegate {
    func didUpdateWeatherInteractor(_ weatherInteractor: WeatherInteractor, weather: WeatherData)
    func didReceivedImage(_ image: UIImage)
    func didFailWithError(error: Error)
}

struct WeatherInteractor {
    
    var weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=9a6c05d32c3934fc279ce91492f8014e&units=metric"
    
    var imageUrl = "https://openweathermap.org/img/wn/"
    
    var delegate: WeatherMangerDelegate?
    
    func fetchWeather(_ cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude lat: Double , longitude lon: Double){
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)
    }
    
    func fetchImageFromName(_ imageName: String){
        let urlString = "\(imageUrl)\(imageName)@2x.png"
        performRequestForImage(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        // Create a URL
        if let url = URL(string: urlString) {
            // Create a URLsession
            let session = URLSession(configuration: .default)
            
            // Create a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                }
                
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(WeatherData.self, from: safeData)
                        delegate?.didUpdateWeatherInteractor(self, weather: decodedData)
                        guard let iconArr = decodedData.weather?[0] else { return }
                        self.fetchImageFromName(iconArr.icon)
                    } catch  {
                        delegate?.didFailWithError(error: error)
                    }
                }
            }
            // Start the task
            task.resume()
        }
    }
    
    func performRequestForImage(with urlString: String) {
        // Create a URL
        if let url = URL(string: urlString) {
            
            // Create a URLsession
            let session = URLSession(configuration: .default)
            
            // Create a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                }
                
                if let safeData = data {
                    let image = UIImage(data: safeData)
                    delegate?.didReceivedImage((image ?? UIImage(named: "03n")) ?? UIImage())
                }
            }
            // Start the task
            task.resume()
        }
    }
}
