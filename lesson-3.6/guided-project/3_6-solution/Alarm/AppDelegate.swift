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
    
    let snoozeAction = UNNotificationAction(identifier: Alarm.snoozeActionID, title: "Snooze", options: [])
    
    let alarmCategory = UNNotificationCategory(identifier: Alarm.notificationCategoryId, actions: [snoozeAction], intentIdentifiers: [], options: [])
    
    center.setNotificationCategories([alarmCategory])
    center.delegate = self
    
    return true
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse,    withCompletionHandler completionHandler: @escaping () -> Void) {
    if response.actionIdentifier == Alarm.snoozeActionID {
      let snoozeDate = Date().addingTimeInterval(9 * 60) //TimeInterval represents seconds
      let alarm = Alarm(date: snoozeDate)
      alarm.schedule { granted in
        if !granted {
          print("Can't schedule snooze because notification permissions were revoked.")
        }
      }
    }
    
    completionHandler()
  }
  
  func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler     completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    completionHandler([.banner, .sound])
    Alarm.scheduled = nil
  }
}

