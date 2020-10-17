import UIKit
import CoreData
import NotificationCenter
class AddedViewController: UIViewController {

    @IBOutlet weak var addedButton: UIButton!
    @IBOutlet weak var actionTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var notificationTime: UIDatePicker!
    @IBOutlet weak var repeatOrNoControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationTime.minimumDate = Date()
        let tapView = UITapGestureRecognizer(target: self,
                                             action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapView )
        actionTextField.delegate = self
        addedButton.addTarget(self,
                              action: #selector(addAction),
                              for: .touchUpInside)
        addedButton.setLayerButton(button: addedButton)
        cancelButton.setLayerButton(button: cancelButton)
    }
   
    //MARK: Handlers
    @objc
    private func dismissKeyboard(){
        actionTextField.endEditing(true)
    }
    
    @objc
    private func addAction(){
        if actionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            print("empty Fields")
        }else{
            let context = PersistanceServise.context
            let action = ToDo(context: context)
            action.action = actionTextField.text
            action.isCompleted = false
            action.notificationTime = notificationTime.date
            action.id = UUID().uuidString
            print(action.id)
            let repeated = repeatOrNoControl.selectedSegmentIndex == 0 ? true : false
            guard let id = action.id else{return}
            setActionNotification(body: action.action,
                                                      time: notificationTime.date,
                                                      repeatOrNo: repeated,
                                                      id: id)
            context.insert(action)
            PersistanceServise.appDelegate.saveContext()
            dismiss(animated: true,
                    completion: nil)
        }
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
                                                options: .foreground)
        let category = UNNotificationCategory(identifier: "idC",
                                              actions: [shareAction, repeatInHour],
                                              intentIdentifiers: [],
                                              options: [])
        content.categoryIdentifier = "idC"
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                    repeats: repeatOrNo)
        let request = UNNotificationRequest(identifier: id,
                                            content: content,
                                            trigger: trigger)
        center.delegate = self
        center.add(request) { (error) in
            if let error = error{
                print(error.localizedDescription)
            }
        }
        center.setNotificationCategories([category])
        
    }


}

extension UIButton{
    fileprivate func setLayerButton(button: UIButton){
        button.layer.cornerRadius = UIButton.Appearance.cornerRadius
        button.layer.shadowOpacity = UIButton.Appearance.shadowOpicity
        button.layer.shadowOffset = UIButton.Appearance.shadowOffset
        button.layer.shadowColor = UIButton.Appearance.shadowColor
    }
    struct Appearance{
        static let shadowColor: CGColor = UIColor.lightGray.cgColor
        static let cornerRadius: CGFloat = 10
        static let shadowOpicity: Float = 0.6
        static let shadowOffset = CGSize(width: 2, height: 2)
    }
}

extension AddedViewController: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "completed":
            let requestId = response.notification.request.identifier
            let context = PersistanceServise.context
            guard let entityName = ToDo.entity().name else{return }
            let fetch = NSFetchRequest<ToDo>(entityName: entityName)
            print(requestId)
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
