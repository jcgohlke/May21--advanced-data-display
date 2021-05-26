//
//  AppDelegate.swift
//  BillManager
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    private let remindActionID = "RemindAction"
    private let markAsPaidActionID = "MarkAsPaidAction"

    var window: UIWindow?
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let id = response.notification.request.identifier
        guard var bill = Database.shared.getBill(notificationID: id) else { completionHandler(); return }
        
        switch response.actionIdentifier {
        case remindActionID:
            let newRemindDate = Date().addingTimeInterval(60 * 60)
            
            bill.scheduleReminder(on: newRemindDate) { (updatedBill) in
                Database.shared.updateAndSave(updatedBill)
            }
        case markAsPaidActionID:
            bill.paidDate = Date()
            Database.shared.updateAndSave(bill)
        default:
            break
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound])
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let remindAction = UNNotificationAction(identifier: remindActionID, title: "Remind me later", options: [])
        let markAsPaidAction = UNNotificationAction(identifier: markAsPaidActionID, title: "Mark as paid", options: [.authenticationRequired])
        
        let category = UNNotificationCategory(identifier: Bill.notificationCategoryID, actions: [remindAction, markAsPaidAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }
}

