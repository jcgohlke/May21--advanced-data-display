//
//  ViewController.swift
//  Alarm
//

import UIKit

class ViewController: UIViewController {
  
  private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter
  }()
  
  @IBOutlet var datePicker: UIDatePicker!
  
  @IBOutlet var alarmLabel: UILabel!
  
  @IBOutlet var scheduleButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateUI()
    
    NotificationCenter.default.addObserver(self, selector: #selector(updateUI), name: .alarmUpdated, object: nil)
  }
  
  @objc func updateUI() {
    if let scheduledAlarm = Alarm.scheduled {
      let formattedAlarm = dateFormatter.string(from: scheduledAlarm.date)
      alarmLabel.text = "Your alarm is scheduled for \(formattedAlarm)"
      datePicker.isEnabled = false
      scheduleButton.setTitle("Remove Alarm", for: .normal)
    } else {
      alarmLabel.text = "Set an alarm below"
      datePicker.isEnabled = true
      scheduleButton.setTitle("Set Alarm", for: .normal)
    }
  }
  
  func presentNeedAuthorizationAlert() {
    let alert = UIAlertController(title: "Authorization Needed", message: "Alarms don't work without notifications, and it looks like you haven't granted us permission to send you those. Please go to the iOS Settings app and grant us notification permissions.", preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
    
    alert.addAction(okAction)
    
    present(alert, animated: true, completion: nil)
  }
  
  @IBAction func setAlarmButtonTapped(_ sender: UIButton) {
    if let alarm = Alarm.scheduled {
      alarm.unschedule()
    } else {
      let alarm = Alarm(date: datePicker.date)
      alarm.schedule { [weak self] (permissionGranted) in
        if !permissionGranted {
          self?.presentNeedAuthorizationAlert()
        }
      }
    }
  }
}

