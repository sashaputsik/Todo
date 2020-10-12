import UIKit

class AddedViewController: UIViewController {

    @IBOutlet weak var addedButton: UIButton!
    @IBOutlet weak var actionTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        addedButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
    }
   
    @objc
    func addAction(){
        let context = PersistanceServise.context
        let action = ToDo(context: context)
        action.action = actionTextField.text
        action.isComplited = false
        context.insert(action)
        toDoList.append(action)
        PersistanceServise.appDelegate.saveContext()
        dismiss(animated: true, completion: nil)
    }
    


}
