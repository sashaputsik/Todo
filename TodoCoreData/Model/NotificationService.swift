import Foundation
import NotificationCenter


class NotificationService{
    
    static func setActionNotification(body: String?, time: Date){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        guard let body = body else{return}
        content.body = body
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        print(trigger.dateComponents)
        let request = UNNotificationRequest(identifier: body, content: content, trigger: trigger)
        center.add(request) { (error) in
            if let error = error{
                print(error.localizedDescription)
            }
        }
    }
}
