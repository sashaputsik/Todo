import Foundation
import NotificationCenter


class NotificationService{
   
    
    static func setActionNotification(body: String?,
                                      time: Date,
                                      repeatOrNo: Bool,
                                      id: String,
                                      complitionHandler: @escaping (UNUserNotificationCenter) -> ()){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        guard let body = body else{return}
        content.body = body
        let dateComponents = Calendar.current.dateComponents([.day, .hour, .minute],
                                                            from: time)
        
        let shareAction = UNNotificationAction(identifier: "completed", title: "Comleted", options: .foreground)
        let category = UNNotificationCategory(identifier: "idC", actions: [shareAction], intentIdentifiers: [], options: [])
        content.categoryIdentifier = "idC"
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                    repeats: repeatOrNo)
        print(trigger.dateComponents)
        let request = UNNotificationRequest(identifier: id,
                                            content: content,
                                            trigger: trigger)
        complitionHandler(center)
        center.add(request) { (error) in
            if let error = error{
                print(error.localizedDescription)
            }
        }
        center.setNotificationCategories([category])
        
    }
}
