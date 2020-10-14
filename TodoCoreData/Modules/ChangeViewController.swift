import UIKit

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
        NotificationService.setActionNotification(body: action, time: changeDatePicker.date, repeatOrNo: repeated)
    }
    
    @objc
    private func dismissKeyboard(){
        changeActionTextField.endEditing(true)
    }
    
}
