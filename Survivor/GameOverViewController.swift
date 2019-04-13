//
//  GameViewController.swift
//  
//
//  Created by Emmanuel Nativel on 3/23/19.
//  Copyright © 2019 Emmanuel Nativel. All rights reserved.
//

import UIKit

class GameOverViewController: UIViewController {
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var pseudoInput: UITextField!
    //var score:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scoreLabel.text = "Score : \(Score.scoreCurrent)"
    }
    
    
    @IBAction func OnClickBtnValider(_ sender: Any) {
        if((pseudoInput.text?.isEmpty)!){
            pseudoInput.backgroundColor = UIColor.red
        } else {
            let now = Date();
            let formatDate       = DateFormatter()
            formatDate.dateStyle = .medium
            formatDate.timeStyle = .medium
            formatDate.locale    = Locale(identifier: "FR-fr")
            let date:String = formatDate.string(from: now)
            Score.scores.append((pseudoInput.text!, Score.scoreCurrent, date))
            let vc = self.storyboard!.instantiateViewController(withIdentifier: "Menu")
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    
    
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
