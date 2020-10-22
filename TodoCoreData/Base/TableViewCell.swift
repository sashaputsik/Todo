import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var timeNotifivationLabel: UILabel!
    
    var dateFormatter: DateFormatter{
        let dateF = DateFormatter()
        dateF.locale = Locale(identifier: "ru_RU")
        dateF.dateFormat = "E, d MMM HH:mm"
        return dateF
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setInfo(of action: ToDo){
        actionLabel.text = action.action
        timeNotifivationLabel.text = "Напомнить в: "+dateFormatter.string(from: action.notificationTime)
        actionLabel.textColor = action.isCompleted ? .lightGray : .black
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }

}
