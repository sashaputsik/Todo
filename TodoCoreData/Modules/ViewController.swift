import UIKit
import CoreData

class ViewController: UIViewController {
    var toDoList = [ToDo]()
    var comp = [Any]()
    @IBOutlet private(set) var tableView: UITableView!
    
    @IBOutlet weak var showCompletedActionButton: UIBarButtonItem!
    fileprivate var isShowCompletedAction = false
    
    override func viewWillAppear(_ animated: Bool) {
        let predicate = NSPredicate(format: "isCompleted == NO")
        fetchRequest(predicate: predicate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func fetchRequest(predicate: NSPredicate?){
        let context = PersistanceServise.context
        guard let name = ToDo.entity().name else{return }
        let sort = NSSortDescriptor(key: "isCompleted", ascending: true)
        let fetchRequest = NSFetchRequest<ToDo>(entityName: name)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = predicate
        do{
            toDoList = try context.fetch(fetchRequest)
            print(toDoList)
        }catch let error as NSError{
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    
    @IBAction func reload(_ sendet: UIBarButtonItem){
        for action in toDoList{
            print(action.isCompleted, action.isFault)
        }
        if !isShowCompletedAction{
            fetchRequest(predicate: nil)
        }else{
            let predicate = NSPredicate(format: "isCompleted == NO")
            fetchRequest(predicate: predicate)
        }
        isShowCompletedAction = !isShowCompletedAction
    }
    @IBAction override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        guard let vc = unwindSegue.source as? AddedViewController else{return}
        tableView.reloadData()
        isShowCompletedAction = false
        print(vc)
    }
    @IBAction func cancelUnwind(segue: UIStoryboardSegue){
        guard let vc = segue.source as? AddedViewController else{return }
        print(vc)
    }

}

