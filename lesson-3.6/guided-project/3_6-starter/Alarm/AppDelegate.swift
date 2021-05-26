//
//  AppDelegate.swift
//  Alarm
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    let center = UNUserNotificationCenter.current()
    
    let snoozeAction = UNNotificationAction(identifier: Alarm.snoozeActionId, title: "Snooze", options: [])
    
    let alarmCategory = UNNotificationCategory(identifier: Alarm.notificationCategoryId, actions: [snoozeAction], intentIdentifiers: [], options: [])
    
    center.setNotificationCategories([alarmCategory])
    center.delegate = self
    
    return true
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    if response.actionIdentifier == Alarm.snoozeActionId {
      let snoozeDate = Date().addingTimeInterval(9 * 60) // This is 9 minutes in the future
      let alarm = Alarm(date: snoozeDate)
      alarm.schedule { wasScheduled in
        if wasScheduled == false {
          print("Can't schedule snooze because notification permissions were revoked.")
        }
      }
    }
    
    completionHandler()
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.list, .sound])
    Alarm.scheduled = nil
  }
}

