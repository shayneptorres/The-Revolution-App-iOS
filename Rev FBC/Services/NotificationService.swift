//
//  NotificationService.swift
//  Rev FBC
//
//  Created by Shayne Torres on 9/27/17.
//  Copyright © 2017 sptorres. All rights reserved.
//

import Foundation
import Realm
import NotificationCenter
import UserNotifications
import UserNotificationsUI

enum NoticationPreference : Int {
    case def = 30
}

class NotificationService {
    
    static let instance = NotificationService()
    var center = UNUserNotificationCenter.current()
    
    func requestPermission() {
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
    }
    
    func sycnNotifications() {
        
    }
    
    func addNotification(forEvent event: Event) {
        let note = UNMutableNotificationContent()
        note.title = "\(event.name)"
        note.body = "\(event.name) is coming up in 30 minutes!"
        note.sound = UNNotificationSound.default()
        
        let triggerDate = (event.startDate - 30.minutes)
        
        
        let dateComponents = DateComponents(year: triggerDate.year, month: triggerDate.month, day: triggerDate.day, hour: triggerDate.hour, minute: triggerDate.minute, second: triggerDate.second)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let req = UNNotificationRequest(identifier: event.id, content: note, trigger: trigger)
        center.add(req) { err in
            if err != nil {
                print("There was an error at create local notification")
            }
        }
    }
    
    func getNotifications() -> Promise<[UNNotificationRequest]> {
        return Promise<[UNNotificationRequest]>(work: ({ fulfill, reject in
            self.center.getPendingNotificationRequests { notifications in
                fulfill(notifications)
            }
        }))
    }
    
    func checkNotifications(forEvent event: Event) {
        getNotifications().then({ notifications in
            if !notifications.isEmpty {
                // if the current notifications contain one matching the given event id
                guard
                    let notification = notifications.filter({ $0.identifier == event.id }).first,
                    let trig = notification.trigger as? UNCalendarNotificationTrigger
                    else {
                        // if none, add the notifications
                        self.addNotification(forEvent: event)
                        return
                }
                
                let trigDate = event.startDate - 30.minutes
                
                if trig.dateComponents.day == trigDate.day,
                    trig.dateComponents.hour == trigDate.hour,
                    trig.dateComponents.minute == trigDate.minute {
                    // the notification is up to date, do nothing
                } else {
                    // if the dates are conflicting remove, the old notification and add a new one
                    self.center.removePendingNotificationRequests(withIdentifiers: [notification.identifier])
                    self.addNotification(forEvent: event)
                }
            } else {
                self.addNotification(forEvent: event)
            }
        })
    }
    
    func removeNotification(forEvent event: Event) {
        center.removePendingNotificationRequests(withIdentifiers: [event.id])
    }
    
}
