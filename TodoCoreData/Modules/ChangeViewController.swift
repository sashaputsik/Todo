import UIKit
import CoreData
class ChangeViewController: UIViewController {
    var index = 0
    @IBOutlet weak var changeActionTextField: UITextField!
    @IBOutlet weak var changeDatePicker: UIDatePicker!
    @IBOutlet weak var changeActionButton: UIButton!
    @IBOutlet weak var repeatOrNoControl: UISegmentedControl!
    var toDoList = [ToDo]()
    
    override func viewWillAppear(_ animated: Bool) {
        let action = toDoList[index]
        changeActionTextField.text = action.action
        changeActionTextField.delegate = self
        changeDatePicker.date = action.notificationTime
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        changeActionButton.layer.cornerRadius = UIButton.Appearance.cornerRadius
        changeActionButton.layer.shadowOffset = UIButton.Appearance.shadowOffset
        changeActionButton.layer.shadowOpacity = UIButton.Appearance.shadowOpicity
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(index)
        changeActionButton.addTarget(self, action: #selector(setChangeAction), for: .touchUpInside)
    }
    
    //MARK: Handler
    @objc
    private func setChangeAction(){
        guard let action = changeActionTextField.text else{return}
        toDoList[index].action = action
        toDoList[index].isCompleted = false
        toDoList[index].notificationTime = changeDatePicker.date
        PersistanceServise.appDelegate.saveContext()
        let repeated = repeatOrNoControl.selectedSegmentIndex == 0 ? true : false
        NotificationService.setActionNotification(body: action, time: changeDatePicker.date, repeatOrNo: repeated, complitionHandler: {
            center in
            center.delegate = self
        })
    }
    
    @objc
    private func dismissKeyboard(){
        changeActionTextField.endEditing(true)
    }
    
}

extension ChangeViewController: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "completed":
            let requestId = response.notification.request.identifier
            let context = PersistanceServise.context
            guard let entityName = ToDo.entity().name else{return }
            let fetch = NSFetchRequest<ToDo>(entityName: entityName)
            let list = try? context.fetch(fetch)
            for action in list!{
                if action.action == requestId{
                    print(true)
                    action.isCompleted = true
                }
            }
            PersistanceServise.appDelegate.saveContext()
        default:
            print("default")
        }
    }
}
