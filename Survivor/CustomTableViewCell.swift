import UIKit

class CustomTableViewCell : UITableViewCell {
    
    @IBOutlet weak var scorePseudo:UILabel!
    @IBOutlet weak var scoreVal:UILabel!
    @IBOutlet weak var scoreDate:UILabel!
    
    var tableView : UITableView!
    
    
    @IBAction func OnClickBtnFermer(_ sender: Any) {
        for i in 0...Score.scores.count-1 {
            if(Score.scores[i].0 == scorePseudo.text && Score.scores[i].1 == (Int)(scoreVal.text!) && Score.scores[i].2 == scoreDate.text){
                Score.scores.remove(at: i)
                tableView.reloadData()
                return
            }
        }
    }
    
}
