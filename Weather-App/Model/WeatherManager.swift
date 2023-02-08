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
  
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=a7d5976260e5eecc1cccc73535526f69&units=metric"
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
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            print(weather.cityName)
            print(weather.temperatureString)
            return weather
        
           
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    

}

