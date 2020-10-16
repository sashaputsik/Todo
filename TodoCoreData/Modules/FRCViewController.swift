import UIKit
import CoreData
class FRCViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    fileprivate var frc: NSFetchedResultsController<ToDo>?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let context = PersistanceServise.context
        guard let name = ToDo.entity().name else{return }
        let fetchRequest = NSFetchRequest<ToDo>(entityName: name)
        let sort = NSSortDescriptor(key: "action", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        let fetchRC = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchRC.delegate = self
        
        do {
            try fetchRC.performFetch()
            frc = fetchRC
            print(frc?.fetchedObjects)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    

}

extension FRCViewController: UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sections = frc?.sections
        let section = sections![section]
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let action = frc?.object(at: indexPath)
        cell.textLabel?.text = action?.action
        print(action?.action)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = frc?.object(at: indexPath)
        
        action?.action = "dddddd"
        PersistanceServise.appDelegate.saveContext()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    
    
    
}
