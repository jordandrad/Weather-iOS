//
//  EventsViewController.swift
//  Weather-App
//
//  Created by Jordan Andrade on 2/15/23.
//

import UIKit

class EventsViewController: UIViewController {

    @IBOutlet weak var EventTitleLabel1: UILabel!
    @IBOutlet weak var EventTitleLabel2: UILabel!
    @IBOutlet weak var EventTitleLabel3: UILabel!
    @IBOutlet weak var EventTitleLabel4: UILabel!
    @IBOutlet weak var EventTitleLabel5: UILabel!
    @IBOutlet weak var EventCityLabel1: UILabel!
    @IBOutlet weak var EventCityLabel2: UILabel!
    @IBOutlet weak var EventCityLabel3: UILabel!
    @IBOutlet weak var EventCityLabel4: UILabel!
    @IBOutlet weak var EventCityLabel5: UILabel!
    @IBOutlet weak var EventTempLabel1: UILabel!
    @IBOutlet weak var EventTempLabel2: UILabel!
    @IBOutlet weak var EventTempLabel3: UILabel!
    @IBOutlet weak var EventTempLabel4: UILabel!
    @IBOutlet weak var EventTempLabel5: UILabel!
    @IBOutlet weak var EventImage1: UIImageView!
    @IBOutlet weak var EventImage2: UIImageView!
    @IBOutlet weak var EventImage3: UIImageView!
    @IBOutlet weak var EventImage4: UIImageView!
    @IBOutlet weak var EventImage5: UIImageView!
    
    
    
    let eventManager = EventsManager()
    var weatherManager = WeatherManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        let eventsData = GlobalData.shared.eventsData
        for (i, data) in eventsData.enumerated() {
            let eventTitleLabel = self.eventTitleLabel(forIndex: i)
            let eventCityLabel = self.eventCityLabel(forIndex: i)
            eventTitleLabel.text = data.title
            eventCityLabel.text = data.location
        }
        let eventCount = eventsData.count
           if eventCount > 0 {
               weatherManager.fetchWeather(cityName: GlobalData.shared.eventsData[0].location.components(separatedBy: "\n")[0])
           }
           if eventCount > 1 {
               weatherManager.fetchWeather(cityName: GlobalData.shared.eventsData[1].location.components(separatedBy: "\n")[0])
           }
           if eventCount > 2 {
               weatherManager.fetchWeather(cityName: GlobalData.shared.eventsData[2].location.components(separatedBy: "\n")[0])
           }
           if eventCount > 3 {
               weatherManager.fetchWeather(cityName: GlobalData.shared.eventsData[3].location.components(separatedBy: "\n")[0])
           }
           if eventCount > 4 {
               weatherManager.fetchWeather(cityName: GlobalData.shared.eventsData[4].location.components(separatedBy: "\n")[0])
           }
       }
    @IBAction func BackClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    func eventTitleLabel(forIndex index: Int) -> UILabel {
        switch index {
        case 0: return EventTitleLabel1
        case 1: return EventTitleLabel2
        case 2: return EventTitleLabel3
        case 3: return EventTitleLabel4
        case 4: return EventTitleLabel5
        default: fatalError("Invalid event index")
        }
    }

    func eventCityLabel(forIndex index: Int) -> UILabel {
        switch index {
        case 0: return EventCityLabel1
        case 1: return EventCityLabel2
        case 2: return EventCityLabel3
        case 3: return EventCityLabel4
        case 4: return EventCityLabel5
        default: fatalError("Invalid event index")
        }
    }
}

// MARK: - WeatherManagerDelegate
extension EventsViewController: WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        print("Did Update Weather called!")
        DispatchQueue.main.async {
            let cityName = weather.cityName
                 let temperature = weather.temperatureString
                 guard let eventIndex = GlobalData.shared.eventsData.firstIndex(where: { $0.location.contains(cityName) }) else {
                     return
                 }
                 switch eventIndex {
                 case 0:
                     self.EventTempLabel1.text = "\(temperature)°"
                     self.EventImage1.image = UIImage(systemName: weather.conditionName)
                 case 1:
                     self.EventTempLabel2.text = "\(temperature)°"
                     self.EventImage2.image = UIImage(systemName: weather.conditionName)
                 case 2:
                     self.EventTempLabel3.text = "\(temperature)°"
                     self.EventImage3.image = UIImage(systemName: weather.conditionName)
                 case 3:
                     self.EventTempLabel4.text = "\(temperature)°"
                     self.EventImage4.image = UIImage(systemName: weather.conditionName)
                 case 4:
                     self.EventTempLabel5.text = "\(temperature)°"
                     self.EventImage5.image = UIImage(systemName: weather.conditionName)
                 default:
                     break
                 }
                 }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func eventTempLabel(forIndex index: Int) -> UILabel {
        switch index {
        case 0: return EventTempLabel1
        case 1: return EventTempLabel2
        case 2: return EventTempLabel3
        case 3: return EventTempLabel4
        case 4: return EventTempLabel5
        default: fatalError("Invalid event index")
        }
    }
}
