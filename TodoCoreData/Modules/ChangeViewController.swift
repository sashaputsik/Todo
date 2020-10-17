import UIKit
import CoreData
class ChangeViewController: UIViewController {
    
    @IBOutlet weak var changeActionTextField: UITextField!
    @IBOutlet weak var changeDatePicker: UIDatePicker!
    @IBOutlet weak var changeActionButton: UIButton!
    @IBOutlet weak var repeatOrNoControl: UISegmentedControl!
    var action: ToDo?
    
    override func viewWillAppear(_ animated: Bool) {
        changeActionTextField.text = action?.action
        changeActionTextField.delegate = self
        changeDatePicker.date = action!.notificationTime
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        changeActionButton.layer.cornerRadius = UIButton.Appearance.cornerRadius
        changeActionButton.layer.shadowOffset = UIButton.Appearance.shadowOffset
        changeActionButton.layer.shadowOpacity = UIButton.Appearance.shadowOpicity
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(index)
        changeActionButton.addTarget(self,
                                     action: #selector(setChangeAction),
                                     for: .touchUpInside)
    }
    
    //MARK: Handler
    @objc
    private func setChangeAction(){
        guard let actionText = changeActionTextField.text else{return}
        action?.action = actionText
        action?.isCompleted = false
        action?.notificationTime = changeDatePicker.date
        PersistanceServise.appDelegate.saveContext()
        let repeated = repeatOrNoControl.selectedSegmentIndex == 0 ? true : false
        guard let id = action?.id else{return}
        setActionNotification(body: action?.action,
                                                  time: changeDatePicker.date,
                                                  repeatOrNo: repeated,
                                                  id: id)
    }
    
    @objc
    private func dismissKeyboard(){
        changeActionTextField.endEditing(true)
    }
    
    func setActionNotification(body: String?,
                                      time: Date,
                                      repeatOrNo: Bool,
                                      id: String){
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        guard let body = body else{return}
        content.body = body
        let dateComponents = Calendar.current.dateComponents([.day,
                                                              .hour,
                                                              .minute],
                                                            from: time)
        
        let shareAction = UNNotificationAction(identifier: "completed",
                                               title: "Выполнено",
                                               options: .foreground)
        let repeatInHour = UNNotificationAction(identifier: "repeatInHour",
                                                title: "Повторить через час",
                                                options: .destructive)
        let category = UNNotificationCategory(identifier: "idC",
                                              actions: [shareAction, repeatInHour],
                                              intentIdentifiers: [],
                                              options: [])
        content.categoryIdentifier = "idC"
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                    repeats: repeatOrNo)
        print(trigger.dateComponents)
        let request = UNNotificationRequest(identifier: id,
                                            content: content,
                                            trigger: trigger)
        center.add(request) { (error) in
            if let error = error{
                print(error.localizedDescription)
            }
        }
        center.setNotificationCategories([category])
        
    }
    
}

extension ChangeViewController: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "completed":
            let requestId = response.notification.request.identifier
            let context = PersistanceServise.context
            guard let entityName = ToDo.entity().name else{return  }
            let fetch = NSFetchRequest<ToDo>(entityName: entityName)
            let list = try? context.fetch(fetch)
            for action in list!{
                if action.id == requestId{
                    action.isCompleted = true
                    PersistanceServise.appDelegate.saveContext()
                }
            }
        case "repeatInHour":
            let content = response.notification.request.content
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10,
                                                          repeats: false)
            center.removeDeliveredNotifications(withIdentifiers: [response.notification.request.identifier])
            let request = UNNotificationRequest(identifier: response.notification.request.identifier,
                                              content: content,
                                              trigger: trigger)
            center.add(request, withCompletionHandler: nil)

            print("")
        default:
            print("default")
        }
    }
}
