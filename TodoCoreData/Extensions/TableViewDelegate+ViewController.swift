import Foundation
import UIKit

//MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TableViewCell else{return UITableViewCell()}
        let action = toDoList[indexPath.row]
        cell.actionLabel.text = action.action
        cell.actionLabel.textColor = action.isCompleted ? .lightGray : .black
       
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


