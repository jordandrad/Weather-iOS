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
    let wind: Wind
}

struct Main: Codable{
    let temp: Double
    let temp_min: Double
    let temp_max: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
}

struct weather : Codable{
    let description: String
    let id: Int
}

struct Wind: Codable{
    let speed: Double
}
