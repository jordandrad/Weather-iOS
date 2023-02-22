//
//  SettingsManager.swift
//  Weather-App
//
//  Created by Jordan Andrade on 2/13/23.
//

import UIKit

struct SettingsManager{
    let defaults = UserDefaults.standard
    let keys = Keys()
    func checkUnitsSelected(){
        if GlobalData.shared.selectedUnitIndex == 0{
            defaults.set("units=imperial", forKey: keys.UNITS)
            defaults.set("mph", forKey: keys.SPEED_LABEL)
          
        }
        else {
            defaults.set("units=metric", forKey: keys.UNITS)
            defaults.set("m/s", forKey: keys.SPEED_LABEL)
        }
    }
}

protocol UpdateWeather{
   func UpdateWeatherData()
}
