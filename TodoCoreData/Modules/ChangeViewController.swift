import UIKit
import CoreData
class ChangeViewController: BaseViewController {
    
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
    

    
}
