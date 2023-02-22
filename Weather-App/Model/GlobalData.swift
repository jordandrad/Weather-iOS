//
//  GlobalData.swift
//  Weather-App
//
//  Created by Jordan Andrade on 2/13/23.
//

import UIKit

class GlobalData {
    let defaults = UserDefaults.standard
    let keys = Keys()
    class var shared : GlobalData{
        struct data {
            static let instance = GlobalData()
        }
        return data.instance
    }
    
    var selectedUnitIndex: Int{
        get {
            defaults.integer(forKey: keys.UNITS_SELECTED)
        }
    }
    
    var units: String{
        get{
            defaults.string(forKey: keys.UNITS) ?? "units=imperial"
        }
    }
    
    var speedLabel: String{
        get {
            defaults.string(forKey: keys.SPEED_LABEL) ?? "mph"
        }
    }
    var eventsData: [(title: String, location: String)] = []
    var eventDataList: [(title: String, location: String)] = []
}
