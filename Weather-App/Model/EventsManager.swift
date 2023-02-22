//
//  EventsManager.swift
//  Weather-App
//
//  Created by Jordan Andrade on 2/15/23.
//

import UIKit
import EventKit
class EventsManager{
    let defaults = UserDefaults.standard
    let keys = Keys()
    let eventStore = EKEventStore()
    func requestAccessToCalendar() {
        eventStore.requestAccess(to: .event) { [weak self] (granted, error) in
            guard let self = self else { return }
            if granted && error == nil {
                print("Access granted to calendar")
                self.getEvents(for: Date())
            } else {
                print("Access denied to calendar")
            }
        }
    }
    func getEvents(for date: Date) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted, error == nil {
                let calendar = Calendar.current
                let today = Date()
                let tomorrow = calendar.date(byAdding: .day, value: 1, to: today)!
                let startOfTomorrow = calendar.startOfDay(for: tomorrow)
                let startDate = startOfTomorrow
                let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)!
                let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: nil)
                let events = eventStore.events(matching: predicate).sorted { $0.startDate < $1.startDate }
                
                for event in events {
            //        print(event.title)
                //    print(event.startDate)
                //    print(event.endDate)
                 //   print(event.location ?? "")
                }
           
            }
        }
    }
    func getNextFiveEventLocations() {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { (granted, error) in
            if granted, error == nil {
                let now = Date()
                let endDate = Date.distantFuture // Use distant future as end date
                let predicate = eventStore.predicateForEvents(withStart: now, end: endDate, calendars: nil)
                var eventsData = [(title: String, location: String)]() // Initialize empty array of event data
                let events = eventStore.events(matching: predicate).filter { $0.endDate > now }.sorted { $0.startDate < $1.startDate }
                let numberOfEvents = events.count > 5 ? 5 : events.count // Limit to 5 events
                for i in 0..<numberOfEvents {
                    let event = events[i]
                    let eventData: (title: String, location: String) = (title: event.title, location: event.location ?? "")
                    eventsData.append(eventData) // Add event data to the array
                }
                GlobalData.shared.eventsData = eventsData // Update GlobalData with event data
            }
        }
    }
}

extension Date {
    func endOfDay() -> Date {
        let calendar = Calendar.current
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: self)!
        return endOfDay
    }
}
