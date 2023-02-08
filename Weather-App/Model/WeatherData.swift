//
//  WeatherData.swift
//  Weather-App
//
//  Created by Jordan Andrade on 2/8/23.
//

import Foundation

struct WeatherData : Codable{
    let name: String
    let main: Main
    let weather: [weather]
}

struct Main: Codable{
    let temp: Double
}

struct weather : Codable{
    let description: String
    let id: Int
}
