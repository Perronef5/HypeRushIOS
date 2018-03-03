//
//  WorldMenuViewController.swift
//  HypeRushIOS
//
//  Created by Luis F. Perrone on 3/3/18.
//  Copyright © 2018 ThemFireLabs. All rights reserved.
//

import UIKit

class WorldMenuViewController: UIViewController {

    @IBOutlet weak var world1: UIButton!
    @IBOutlet weak var world2: UIButton!
    @IBOutlet weak var world3: UIButton!
    
    
    @IBAction func buttonAction(_ sender: Any) {
        switch ((sender as! UIButton).tag) {
        case 0:
            let level1 = UIStoryboard.viewControllerMain(identifier: "level1") as! GameViewController
            self.navigationController?.present(level1, animated: false, completion: nil)
            break
        case 1:
            break
        case 2:
            break
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
