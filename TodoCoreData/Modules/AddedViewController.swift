import UIKit
import NotificationCenter
class AddedViewController: UIViewController {

    @IBOutlet weak var addedButton: UIButton!
    @IBOutlet weak var actionTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var nofiticationTime: UIDatePicker!
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
        setActionNotification(body: action.action, time: nofiticationTime.date)
        context.insert(action)
        let vc = ViewController()
        vc.toDoList.append(action)
        PersistanceServise.appDelegate.saveContext()
        dismiss(animated: true, completion: nil)
    }
   
    func setActionNotification(body: String?, time: Date){
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        guard let body = body else{return}
        content.body = body
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: time)
        print(dateComponents.hour, dateComponents.minute)
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
