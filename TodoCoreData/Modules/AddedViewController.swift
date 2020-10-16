import UIKit
import CoreData
import NotificationCenter
class AddedViewController: UIViewController {

    @IBOutlet weak var addedButton: UIButton!
    @IBOutlet weak var actionTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nofiticationTime: UIDatePicker!
    @IBOutlet weak var repeatOrNoControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapView = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapView )
        actionTextField.delegate = self
        addedButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
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
        let context = PersistanceServise.context
        let action = ToDo(context: context)
        action.action = actionTextField.text
        action.isCompleted = false
        action.notificationTime = nofiticationTime.date
        let repeated = repeatOrNoControl.selectedSegmentIndex == 0 ? true : false
        NotificationService.setActionNotification(body: action.action, time: nofiticationTime.date, repeatOrNo: repeated, complitionHandler: { (center) in
            center.delegate = self
        })
        context.insert(action)
        PersistanceServise.appDelegate.saveContext()
        dismiss(animated: true, completion: nil)
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
