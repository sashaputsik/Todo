import Foundation
import UIKit

//MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                       for: indexPath) as? TableViewCell else{return UITableViewCell()}
    
        let action = toDoList[indexPath.row]
        cell.actionLabel.text = action.action
        cell.timeNotifivationLabel.text = "Напомнить в: "+dateFormatter.string(from: action.notificationTime)
        cell.actionLabel.textColor = action.isCompleted ? .lightGray : .black
        return cell
    }

}

//MARK: UITableViewDelegate

extension ViewController: UITableViewDelegate{

    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        var editTitle = ""
        editTitle = toDoList[indexPath.row].isCompleted ? "Не выполнить" : "Вополнить"
        let completedAction = UITableViewRowAction(style: .default,
                                                   title: editTitle,
                                                   handler: {[weak self] (action, indexPath) in
            guard let self = self else{return }
            guard let action = self.toDoList[indexPath.row].action else{return }
            self.toDoList[indexPath.row].isCompleted = !self.toDoList[indexPath.row].isCompleted
            print(self.toDoList[indexPath.row].isCompleted)
            PersistanceServise.appDelegate.saveContext()
            let center = UNUserNotificationCenter.current()
            if self.toDoList[indexPath.row].isCompleted{
                
                center.removeDeliveredNotifications(withIdentifiers: [action])
                print("deleted notification")
            }else{
                NotificationService.setActionNotification(body: action, time: self.toDoList[indexPath.row].notificationTime, repeatOrNo: true, complitionHandler: {center in })
            }
            tableView.reloadData()
        })
     
        completedAction.backgroundColor = #colorLiteral(red: 0.2153312262, green: 0.6583518401, blue: 0.4810098751, alpha: 1)
        let deleteAction = UITableViewRowAction(style: .default, title: "Удалить", handler: {[weak self] (action, indexPath) in
            guard let self = self else{return }
            let context = PersistanceServise.context
            let action = self.toDoList[indexPath.row]
            context.delete(action)
            self.toDoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            tableView.reloadData()
            PersistanceServise.appDelegate.saveContext()
        })
        deleteAction.backgroundColor = UIColor.red
        let editAction = UITableViewRowAction(style: .default, title: "Изменить") {[weak self] (action, indexPath) in
            guard let self = self else{return}
            let backItem = UIBarButtonItem()
            backItem.title = " "
            self.navigationItem.backBarButtonItem = backItem
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ChangeViewController") as? ChangeViewController else{return }
            vc.index = indexPath.row
            vc.toDoList = self.toDoList
            vc.modalPresentationStyle = .fullScreen
            self.show(vc, sender: nil)
        }
        editAction.backgroundColor = .orange
        return [completedAction, editAction, deleteAction]
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65.0
    }
}


