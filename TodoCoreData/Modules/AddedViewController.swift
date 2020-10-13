import UIKit

class AddedViewController: UIViewController {

    @IBOutlet weak var addedButton: UIButton!
    @IBOutlet weak var actionTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapView = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapView )
        actionTextField.delegate = self
        addedButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
        addedButton.setLayerButton(button: addedButton)
        cancelButton.setLayerButton(button: cancelButton)
    }
   
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
        context.insert(action)
        let vc = ViewController()
        vc.toDoList.append(action)
        PersistanceServise.appDelegate.saveContext()
        dismiss(animated: true, completion: nil)
    }
    
    


}

extension UIButton{
    fileprivate func setLayerButton(button: UIButton){
        button.layer.cornerRadius = UIButton.Appearance.cornerRadius
        button.layer.shadowOpacity = UIButton.Appearance.shadowOpicity
        button.layer.shadowOffset = UIButton.Appearance.shadowOffset
    }
    struct Appearance{
        static let cornerRadius: CGFloat = 10
        static let shadowOpicity: Float = 0.4
        static let shadowOffset = CGSize(width: 1, height: 1)
    }
}
