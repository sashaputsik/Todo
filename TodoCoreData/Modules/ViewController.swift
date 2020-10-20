import UIKit
import CoreData

class ViewController: UIViewController {

    var fetchResultController: NSFetchedResultsController<ToDo>?
    var dateFormatter: DateFormatter{
        let dateF = DateFormatter()
        dateF.locale = Locale(identifier: "ru_RU")
        dateF.dateFormat = "E, d MMM HH:mm"
        return dateF
    }
    
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
    
    func setActionNotification(body: String?,
                                      time: Date,
                                      repeatOrNo: Bool,
                                      id: String){
        var center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        guard let body = body else{return}
        content.body = body
        let dateComponents = Calendar.current.dateComponents([.day,
                                                              .hour,
                                                              .minute],
                                                            from: time)
        
        let shareAction = UNNotificationAction(identifier: "completed",
                                               title: "Выполнено",
                                               options: .foreground)
        let repeatInHour = UNNotificationAction(identifier: "repeatInHour",
                                                title: "Повторить через час",
                                                options: .destructive)
        let category = UNNotificationCategory(identifier: "idC",
                                              actions: [shareAction, repeatInHour],
                                              intentIdentifiers: [],
                                              options: [])
        content.categoryIdentifier = "idC"
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,
                                                    repeats: repeatOrNo)

        let request = UNNotificationRequest(identifier: id,
                                            content: content,
                                            trigger: trigger)
        center.delegate = self
        center.add(request) { (error) in
            if let error = error{
                print(error.localizedDescription)
            }
        }
        center.setNotificationCategories([category])
        
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



extension ViewController: UNUserNotificationCenterDelegate{
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "completed":
            print("fsdfds")
            let requestId = response.notification.request.identifier
            print(requestId)
            let context = PersistanceServise.context
            guard let entityName = ToDo.entity().name else{return }
            let fetch = NSFetchRequest<ToDo>(entityName: entityName)
            let list = try? context.fetch(fetch)
            for action in list!{
                print(action.id)
                if action.id == requestId{

                    print(true)
                    action.isCompleted = true
                    PersistanceServise.appDelegate.saveContext()
                }
            }
        case "repeatInHour":
            let content = response.notification.request.content
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600,
                                                            repeats: false)
            center.removeDeliveredNotifications(withIdentifiers: [response.notification.request.identifier])
            let request = UNNotificationRequest(identifier: response.notification.request.identifier,
                                                content: content,
                                                trigger: trigger)
            center.add(request, withCompletionHandler: nil)
            
            print("")
        default:
            print("default")
        }
    }
}


