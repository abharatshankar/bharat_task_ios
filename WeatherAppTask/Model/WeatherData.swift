//
//  WeatherData.swift
//  WeatherAppTask
//
//  Created by Bharath Shankar on 08/04/23.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]?
    let coord: coord
}

struct Main: Decodable {
    let temp: Float
}

struct Weather: Decodable {
    let id: Int
    let icon: String
}

struct coord: Decodable {
    let lon: Double
    let lat: Double
}
