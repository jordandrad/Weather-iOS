//
//  WeatherViewController.swift
//  Weather-App
//
//  Created by Jordan Andrade on 2/8/23.
//




import UIKit
import CoreLocation
import EventKit
import Network

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var feels_likeLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    
    
    var WeatherManagerr = WeatherManager()
    let locationManager = CLLocationManager()
    var longitude: String?
    var latitude: String?
    let eventsManager = EventsManager()
    let pathMonitor = NWPathMonitor()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.checkNetworkConnection()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        WeatherManagerr.delegate = self
        searchTextField.delegate = self
        
        // Do any additional setup after loading the view.
        eventsManager.requestAccessToCalendar()
        eventsManager.getNextFiveEventLocations()
    }
    
    
    @IBAction func GPSButtonClicked(_ sender: UIButton) {
        if let safeLat = latitude, let safeLon = longitude{
            WeatherManagerr.fetchWeatherByCoordinates(lat: safeLat , lon: safeLon)
        }
    }
    
    @IBAction func SettingsButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToSettings", sender: self)
    }
    
    @IBAction func EventsButtonClicked(_ sender: UIButton) {
        performSegue(withIdentifier: "GoToEvents", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToSettings"{
            if let SettingsVC = segue.destination as? SettingsViewController{
                SettingsVC.delegate = self
            }
        }}
    
    func checkNetworkConnection(){
        pathMonitor.start(queue: DispatchQueue.global())
        pathMonitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Connected")
            } else {
                print("Not connected")
                DispatchQueue.main.async {
                           let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again.", preferredStyle: .alert)
                           let action = UIAlertAction(title: "OK", style: .default)
                           alert.addAction(action)
                           self.present(alert, animated: true, completion: nil)
                       }
            }
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
            self.temperatureLabel.text = "\(weather.temperatureString)°"
            self.cityLabel.text = weather.cityName
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.minTempLabel.text = "\(weather.temp_min)°"
            self.maxTempLabel.text = "\(weather.temp_max)°"
            self.humidityLabel.text = "\(weather.humidity)%"
            self.windSpeedLabel.text = "\(Int(weather.speed)) \(GlobalData.shared.speedLabel)"
            self.feels_likeLabel.text = "\(weather.feels_like)°"
            self.pressureLabel.text = "\(weather.pressure) hPa"
            
          
            
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

// MARK: - UpdateWeatherDelegate

extension WeatherViewController: UpdateWeather{
   @IBAction func UpdateWeatherData() {
       WeatherManagerr.weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=a7d5976260e5eecc1cccc73535526f69&\(GlobalData.shared.units)"
        if let safeLat = latitude, let safeLon = longitude{
            WeatherManagerr.fetchWeatherByCoordinates(lat: safeLat , lon: safeLon)
        }
    }
}

    


