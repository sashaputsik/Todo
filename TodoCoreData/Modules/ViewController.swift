import UIKit
import CoreData

class ViewController: UIViewController {
    
    
    @IBOutlet private(set) var tableView: UITableView!
    @IBOutlet private(set) var showComplitedActionButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        let context = PersistanceServise.context
        guard let name = ToDo.entity().name else{return }
        let fetchRequest = NSFetchRequest<ToDo>(entityName: name)
        let predicate = NSPredicate(format: "isComplited == NO")
        fetchRequest.predicate = predicate
        do{
            toDoList = try context.fetch(fetchRequest)
           
            print(toDoList)
        }catch let error as NSError{
            print(error.localizedDescription)
        }
         tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showComplitedActionButton.addTarget(self, action: #selector(reload), for: .touchUpInside)
        tableView.reloadData()
        tableView.delegate = self
        tableView.dataSource = self
    }
    @objc func reload(){
        let context = PersistanceServise.context
        guard let name = ToDo.entity().name else{return }
        let fetchRequest = NSFetchRequest<ToDo>(entityName: name)
        do{
           toDoList = try context.fetch(fetchRequest)
          
           print(toDoList)
        }catch let error as NSError{
           print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    @IBAction override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        guard let vc = unwindSegue.source as? ViewController else{return}
        tableView.reloadData()
        print(vc)
    }

}

