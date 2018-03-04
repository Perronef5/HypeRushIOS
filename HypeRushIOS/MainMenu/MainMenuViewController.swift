//
//  MainMenuViewController.swift
//  HypeRushIOS
//
//  Created by Luis F. Perrone on 3/2/18.
//  Copyright © 2018 ThemFireLabs. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit

class MainMenuViewController: UIViewController {
    
    @IBOutlet weak var coinsLabel: UILabel!
    var coins = UserDefaults().integer(forKey: "COINS")

    @IBAction func buttonAction(_ sender: Any) {
        switch ((sender as! UIButton).tag) {
            case 0:
                print("Im here!")
                 let skView = self.view as! SKView
                skView.presentScene(nil)
                let worldMenuViewController = UIStoryboard.viewControllerMain(identifier: "WorldMenuViewController") as! WorldMenuViewController
                self.navigationController?.pushViewController(worldMenuViewController, animated: false) 
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
        setCoins()
        
        if let scene = GKScene(fileNamed: "MainMenuScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! MainMenuScene? {
                
                // Copy gameplay related content over to the scene
                //                sceneNode.entities = scene.entities
                //                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                sceneNode.alpha = 0.9
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCoins() {
        coins = UserDefaults().integer(forKey: "COINS")
        coinsLabel.text = "\(coins)"
        
//        if GKLocalPlayer.localPlayer().isAuthenticated {
//            let scoreReporter = GKScore(leaderboardIdentifier: "TrumpRushHS")
//
//            scoreReporter.value = Int64(highScore)
//            let scoreArray: [GKScore] = [scoreReporter]
//            GKScore.report(scoreArray, withCompletionHandler: nil)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setCoins()

        let skView = self.view as! SKView
        if skView.scene == nil {
            if let scene = GKScene(fileNamed: "MainMenuScene") {
                
                // Get the SKScene from the loaded GKScene
                if let sceneNode = scene.rootNode as! MainMenuScene? {
                    
                    // Copy gameplay related content over to the scene
                    //                sceneNode.entities = scene.entities
                    //                sceneNode.graphs = scene.graphs
                    
                    // Set the scale mode to scale to fit the window
                    sceneNode.scaleMode = .aspectFill
                    sceneNode.alpha = 0.9
                    // Present the scene
                    if let view = self.view as! SKView? {
                        view.presentScene(sceneNode)
                        
                        view.ignoresSiblingOrder = true
                        
                        view.showsFPS = true
                        view.showsNodeCount = true
                    }
                }
            }
        }
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
