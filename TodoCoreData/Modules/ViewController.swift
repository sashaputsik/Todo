import UIKit
import CoreData

class ViewController: BaseViewController {

    var fetchResultController: NSFetchedResultsController<ToDo>?

    @IBOutlet private(set) var tableView: UITableView!
    @IBOutlet private(set) var showCompletedActionButton: UIButton!
    fileprivate var isShowCompletedAction = false
    
    @IBOutlet weak var backView: UIView!
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        let predicate = NSPredicate(format: "isCompleted == NO")
        try? fetchRequest(predicate: predicate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backView.layer.cornerRadius = 120
        tableView.delegate = self
        tableView.dataSource = self
        tableView.clipsToBounds = false
        tableView.layer.masksToBounds = false
        tableView.layer.shadowOffset = UITableView.Appearance.shadowOffset
        tableView.layer.shadowRadius = 10
        tableView.layer.shadowOpacity = UITableView.Appearance.shadowOpacity
       
    }
    
    func fetchRequest(predicate: NSPredicate?) throws{
        let context = PersistanceServise.context
        guard let name = ToDo.entity().name else{ throw ErrorHander.emptyEntityName}
        let sort = NSSortDescriptor(key: "isCompleted",
                                    ascending: true)
        let fetchRequest = NSFetchRequest<ToDo>(entityName: name)
        fetchRequest.sortDescriptors = [sort]
        fetchRequest.predicate = predicate
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest,
                                             managedObjectContext: context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        frc.delegate = self
        do{
            try frc.performFetch()
            fetchResultController = frc
        }catch let error as NSError{
            print(error.localizedDescription)
            throw ErrorHander.fetchRequest
        }
        tableView.reloadData()
    }
    
//MARK: IBAction
    @IBAction func showCompletedAction(_ sender: UIButton) {
        showCompletedActionButton.setTitle(!isShowCompletedAction ? "Скрыть завершенные" : "Показать завершенные",
                                           for: .normal)
        let predicate = NSPredicate(format: "isCompleted == NO")
       try? fetchRequest(predicate: !isShowCompletedAction ? nil : predicate)
        isShowCompletedAction = !isShowCompletedAction
    }
    
//MARK: UnwindSegue
    @IBAction override func unwind(for unwindSegue: UIStoryboardSegue,
                                   towards subsequentVC: UIViewController) {
        guard let vc = unwindSegue.source as? AddedViewController else{return}
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


//MARK: BaseViewController
//MARK: added segue to action notification

