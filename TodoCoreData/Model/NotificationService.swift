import Foundation
import NotificationCenter


class NotificationService{
    
    static func setActionNotification(body: String?,
                                      time: Date,
                                      repeatOrNo: Bool){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        guard let body = body else{return}
        content.body = body
        let dateComponents = Calendar.current.dateComponents([.day, .hour, .minute],
                                                             from: time)
        print(dateComponents.day)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                    repeats: repeatOrNo)
        print(trigger.dateComponents)
        let request = UNNotificationRequest(identifier: body,
                                            content: content,
                                            trigger: trigger)
        center.add(request) { (error) in
            if let error = error{
                print(error.localizedDescription)
            }
        }
    }
}
