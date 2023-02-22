//
//  WeatherManager.swift
//  Weather-App
//
//  Created by Jordan Andrade on 2/8/23.
//

import Foundation

protocol WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager,weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
  
    var weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=a7d5976260e5eecc1cccc73535526f69&\(GlobalData.shared.units)"
    var delegate: WeatherManagerDelegate?

    func fetchWeather(cityName: String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeatherByCoordinates(lat: String, lon: String){
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        performRequest(with: urlString)
    }
      
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJson(safeData){
                        self.delegate?.didUpdateWeather(self ,weather: weather)
                    }
                }
            };
            task.resume()
        }
    }
    func parseJson(_ weatherData: Data) -> WeatherModel? {
        let decode = JSONDecoder()
        do {
            let decodedData = try decode.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let temp_min = decodedData.main.temp_min
            let temp_max = decodedData.main.temp_max
            let feels_like = decodedData.main.feels_like
            let humidity = decodedData.main.humidity
            let speed = decodedData.wind.speed
            let pressure = decodedData.main.pressure
            
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, temp_min: temp_min, temp_max: temp_max,feels_like: feels_like, humidity: humidity, speed: speed, pressure: pressure )
            print(weather.cityName)
            print(weather.temperatureString)
            print(weather.temp_min)
            print(weather.temp_max)
            print(weather.humidity)
            print(weather.speed)
            print(weather.pressure)
            print(weather.feels_like)
            return weather
        
           
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    

}
