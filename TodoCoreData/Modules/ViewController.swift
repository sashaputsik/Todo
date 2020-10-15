import UIKit
import CoreData

class ViewController: UIViewController {
    var toDoList = [ToDo]()
    var comp = [Any]()
    var dateFormatter: DateFormatter{
        let dateF = DateFormatter()
        dateF.locale = Locale(identifier: "ru_RU")
        dateF.dateFormat = "E, d MMM HH:mm"
        return dateF
    }
    @IBOutlet private(set) var tableView: UITableView!
    @IBOutlet private(set) var showCompletedActionButton: UIButton!
    fileprivate var isShowCompletedAction = false
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        let predicate = NSPredicate(format: "isCompleted == NO")
       try? fetchRequest(predicate: predicate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func fetchRequest(predicate: NSPredicate?) throws{
        let context = PersistanceServise.context
        guard let name = ToDo.entity().name else{ throw ErrorHander.emptyEntityName}
        let sort = NSSortDescriptor(key: "isCompleted", ascending: true)
        let fetchRequest = NSFetchRequest<ToDo>(entityName: name)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = predicate
        do{
            toDoList = try context.fetch(fetchRequest)
            print(toDoList)
        }catch let error as NSError{
            print(error.localizedDescription)
            throw ErrorHander.fetchRequest
        }
        tableView.reloadData()
    }
    
    
//MARK: IBAction
    @IBAction func showCompletedAction(_ sender: UIButton) {
        showCompletedActionButton.setTitle(!isShowCompletedAction ? "Скрыть завершенные" : "Показать завершенные", for: .normal)
        let predicate = NSPredicate(format: "isCompleted == NO")
       try? fetchRequest(predicate: !isShowCompletedAction ? nil : predicate)
        isShowCompletedAction = !isShowCompletedAction
    }
    
//MARK: UnwindSegue
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
    
    @IBAction func chagneUnwind(segue: UIStoryboardSegue){
        guard let vc = segue.source as? AddedViewController else{return }
        print(vc)
       }
}

