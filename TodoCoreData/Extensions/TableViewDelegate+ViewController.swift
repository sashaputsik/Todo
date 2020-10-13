import Foundation
import UIKit

//MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let action = toDoList[indexPath.row]
        cell.textLabel?.text = action.action
        if action.isCompleted{
            cell.textLabel?.textColor = .lightGray
        }else{
            cell.textLabel?.textColor = .black
        }
        return cell
    }
    
    
    
}

//MARK: UITableViewDelegate

extension ViewController: UITableViewDelegate{

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toDoList[indexPath.row].isCompleted = !toDoList[indexPath.row].isCompleted
        print(toDoList[indexPath.row].isCompleted)
        PersistanceServise.appDelegate.saveContext()
        tableView.reloadData()
    }
    
  
}


