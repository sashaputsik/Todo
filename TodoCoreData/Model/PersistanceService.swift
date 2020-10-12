import CoreData
import Foundation
import UIKit

var toDoList = [ToDo]()

class PersistanceServise{
    
    static var context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return NSManagedObjectContext()}
        return appDelegate.persistentContainer.viewContext
    }()
    static var appDelegate: AppDelegate{
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return AppDelegate()}
        return appDelegate
    }
   
}
