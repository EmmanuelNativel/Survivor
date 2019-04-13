import UIKit

class ScoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableViewScore: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewScore.delegate = self
        tableViewScore.dataSource = self
        tableViewScore.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Score.scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CelluleScore", for: indexPath) as! CustomTableViewCell
        
        cell.scorePseudo.text = Score.scores[indexPath.row].0
        cell.scoreVal.text = "\(Score.scores[indexPath.row].1)"
        cell.scoreDate.text = Score.scores[indexPath.row].2
        cell.tableView = tableViewScore
        
        return cell
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .all
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

}
