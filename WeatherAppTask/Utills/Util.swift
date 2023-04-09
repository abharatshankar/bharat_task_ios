//
//  Util.swift
//  WeatherAppTask
//
//  Created by Bharath Shankar on 08/04/23.
//

import Foundation
import UIKit

class Util {
    private static var standardDefault = UserDefaults.standard

    //MARK: - User Defaults
    static func setValue(_ value: Any?, forKey key: String) {
        standardDefault.setValue(value, forKey: key)
        standardDefault.synchronize()
    }
    
    static func getValue(_ key: String) -> Any? {
        return standardDefault.value(forKey: key)
    }
    
    static func loadViewController(_ storyboardName: String, vcIdentifier: String? = nil) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        if let vcIdentifier = vcIdentifier {
            return storyboard.instantiateViewController(withIdentifier: vcIdentifier)
        } else {
            return storyboard.instantiateInitialViewController()
        }
    }
}
