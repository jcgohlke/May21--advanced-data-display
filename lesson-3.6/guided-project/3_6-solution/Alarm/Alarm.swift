//
//  Alarm.swift
//  Alarm
//

import Foundation
import UserNotifications

struct Alarm: Codable {
  private var notificationId: String
  
  var date: Date
  
  init(date: Date, notificationId: String? = nil) {
    self.date = date
    self.notificationId = notificationId ?? UUID().uuidString
  }
  
  func schedule(completion: @escaping (Bool) -> ()) {
    authorizeIfNeeded { (granted) in
      guard granted else {
        DispatchQueue.main.async {
          completion(false)
        }
        
        return
      }
      
      let content = UNMutableNotificationContent()
      content.title = "Alarm"
      content.body = "Beep Beep"
      content.sound = UNNotificationSound.default
      content.categoryIdentifier = Alarm.notificationCategoryId
      
      let triggerDateComponents = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: self.date)
      let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
      
      let request = UNNotificationRequest(identifier: self.notificationId, content: content, trigger: trigger)
      
      UNUserNotificationCenter.current().add(request) { (error: Error?) in
        DispatchQueue.main.async {
          if let error = error {
            print(error.localizedDescription)
            completion(false)
          } else {
            Alarm.scheduled = self
            completion(true)
          }
        }
      }
    }
  }
  
  func unschedule() {
    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationId])
    Alarm.scheduled = nil
  }
  
  private func authorizeIfNeeded(completion: @escaping (Bool) -> ()) {
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.getNotificationSettings { (settings) in
      switch settings.authorizationStatus {
        case .authorized:
          completion(true)
          
        case .notDetermined:
          notificationCenter.requestAuthorization(options: [.alert, .sound], completionHandler: { (granted, _) in
            completion(granted)
          })
          
        case .denied, .provisional:
          completion(false)
        case .ephemeral:
          completion(true)
        @unknown default:
          fatalError()
      }
    }
  }
}

extension Alarm {
  static let notificationCategoryId = "AlarmNotification"
  static let snoozeActionID = "snooze"
  
  private static let alarmURL: URL = {
    guard let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      fatalError("Can't get URL for documents directory.")
    }
    
    return baseURL.appendingPathComponent("ScheduledAlarm")
  }()
  
  static var scheduled: Alarm? {
    get {
      guard let data = try? Data(contentsOf: alarmURL) else {
        return nil
      }
      
      return try? JSONDecoder().decode(Alarm.self, from: data)
    }
    
    set {
      if let alarm = newValue {
        let data = try? JSONEncoder().encode(alarm)
        ((try? data?.write(to: alarmURL)) as ()??)
      } else {
        try? FileManager.default.removeItem(at: alarmURL)
      }
      
      NotificationCenter.default.post(name: .alarmUpdated, object: nil)
    }
  }
}
