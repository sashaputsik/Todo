import UIKit
import CoreData
import NotificationCenter
class AddedViewController: BaseViewController {

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
