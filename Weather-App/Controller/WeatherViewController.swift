//
//  WeatherViewController.swift
//  Weather-App
//
//  Created by Jordan Andrade on 2/8/23.
//

import Foundation


import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    
    var WeatherManagerr = WeatherManager()
    let locationManager = CLLocationManager()
    var longitude: String?
    var latitude: String?
 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        WeatherManagerr.delegate = self
        searchTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func GPSButtonClicked(_ sender: UIButton) {
        if let safeLat = latitude, let safeLon = longitude{
            WeatherManagerr.fetchWeatherByCoordinates(lat: safeLat , lon: safeLon)
        }
}
    }
    


// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate{
    

    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }
        else {
            textField.placeholder = "Type something"
            return false
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text{
            WeatherManagerr.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
}

// MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    func didFailWithError(error: Error) {
        print(error)
    }
}

// MARK: - CLLocationmanagerDelegate

extension WeatherViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            WeatherManagerr.fetchWeatherByCoordinates(lat:String(lat), lon: String(lon))
            latitude = String(lat)
            longitude = String(lon)
           
            
            
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


    

