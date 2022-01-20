//
//  ViewController.swift
//  Project_21
//
//  Created by Lui on 17/01/22.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        
    }
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Permissions granted")
            } else {
                print("Permissions denied")
            }
        }
    }
    
    @objc func scheduleLocal(sender: Any) {
        var time = 10.0
        if sender is UIBarButtonItem {
            print("called by button")
        } else {
            print("called by not a button")
            time = 30.0
        }
        registerCategories()
        let center = UNUserNotificationCenter.current()
        //we can remove all the pending notifications, that is, the notification which trigger hasn't been activated
        center.removeAllPendingNotificationRequests()
        
        //content of the notification
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "You're late...."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData":"The information to show or use in case the app was launched from the notification"]
        content.sound = .default
        // content end
        //trigger to determine when to show a notification
        //this will generate a scheduled notification
//        var dateComponents = DateComponents()
//        dateComponents.hour = 10
//        dateComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //on the other hand, we can also set a notification to be triggered within certain time interval
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: time, repeats: false)
        
        //trigger end
        //binding trigger and content
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        //binding end
        
    }
    
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more!", options: .foreground)
        let remindMeLater = UNNotificationAction(identifier: "later", title: "Remind me later", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show, remindMeLater], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if let customData = userInfo["customData"] as? String {
            print("custom data received \(customData)")
            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("Default")
                let ac = UIAlertController(title: "Opened from notification", message: "I was summoned by the Default notification", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Got it", style: .default))
                present(ac, animated: true)
            case "show":
                print("We will show more info according to the provided custom data")
                let ac = UIAlertController(title: "Opened from notification", message: "I was summoned by the Show option", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Showy...", style: .default))
                present(ac, animated: true)
            case "later":
                print("The user wants to be reminded later")
                let ac = UIAlertController(title: "Opened from notification", message: "I was summoned by the later option", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Sleepy...", style: .destructive, handler: { [weak self] actionWhoCalled in
                    self?.scheduleLocal(sender: actionWhoCalled)
                }))
                present(ac, animated: true)
                
                
            default:
                break
            }
        }
        
        completionHandler()
    }
    

}

