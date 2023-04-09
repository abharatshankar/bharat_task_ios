//
//  WeatherAppConstants.swift
//  WeatherAppTask
//
//  Created by Bharath Shankar on 08/04/23.
//

import Foundation
import UIKit

struct WeatherAppContants {
    struct Storyboard {
        struct MainStoryBoard {
            static let kStoryboardName = "Main"
            struct ViewContollerIdentifier {
                static let kHomePage = "WeatherHomeViewController"
            }
        }
    }
    
    struct UserDefaults {//helps to save pervious search
        static let savedLat = "WeatherAppSavedLat"
        static let savedLon = "WeatherAppSavedLon"
    }
}
