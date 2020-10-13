import Foundation
import UIKit

extension AddedViewController: UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.endEditing(true)
    }
}
