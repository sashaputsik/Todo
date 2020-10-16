import Foundation
import UIKit

//MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchResultController?.sections else{return 0}
        let section = sections[section]
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                       for: indexPath) as? TableViewCell else{return UITableViewCell()}
    
        let action = fetchResultController?.object(at: indexPath)
        cell.actionLabel.text = action?.action
        cell.timeNotifivationLabel.text = "Напомнить в: "+dateFormatter.string(from: action!.notificationTime)
        cell.actionLabel.textColor = action!.isCompleted ? .lightGray : .black
        return cell
    }

}

//MARK: UITableViewDelegate

extension ViewController: UITableViewDelegate{

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sections = fetchResultController?.sections else{return ""}
        let title = sections[section].name
        return title
    }
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var editTitle = ""
        guard let actionOne = fetchResultController?.object(at: indexPath) else{return []}
        editTitle = actionOne.isCompleted ? "Не выполнить" : "Вополнить"
        let completedAction = UITableViewRowAction(style: .default,
                                                   title: editTitle,
                                                   handler: {[weak self] (action, indexPath) in
            guard let self = self else{return }
                                                    guard let action = actionOne.action else{return }
                                                    actionOne.isCompleted = !actionOne.isCompleted
            PersistanceServise.appDelegate.saveContext()
            let center = UNUserNotificationCenter.current()
            if actionOne.isCompleted{
                center.removeDeliveredNotifications(withIdentifiers: [action])
                print("deleted notification")
            }else{
                guard let id = actionOne.id else{return }
                NotificationService.setActionNotification(body: action,
                                                          time: actionOne.notificationTime,
                                                          repeatOrNo: true,
                                                          id: id,
                                                          complitionHandler: {center in })
            }
            tableView.reloadData()
        })
     
        completedAction.backgroundColor = #colorLiteral(red: 0.2153312262, green: 0.6583518401, blue: 0.4810098751, alpha: 1)
        let deleteAction = UITableViewRowAction(style: .default,
                                                title: "Удалить",
                                                handler: {[weak self] (action, indexPath) in
            let context = PersistanceServise.context
            context.delete(actionOne)
            PersistanceServise.appDelegate.saveContext()
        })
        deleteAction.backgroundColor = UIColor.red
        let editAction = UITableViewRowAction(style: .default,
                                              title: "Изменить") {[weak self] (action, indexPath) in
            guard let self = self else{return}
            let backItem = UIBarButtonItem()
            backItem.title = " "
            self.navigationItem.backBarButtonItem = backItem
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangeViewController") as? ChangeViewController else{return }
            vc.action = self.fetchResultController?.object(at: indexPath)
            vc.modalPresentationStyle = .fullScreen
            self.show(vc, sender: nil)
        }
        editAction.backgroundColor = .orange
        return [completedAction,
                editAction,
                deleteAction]
    }
  
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
}


