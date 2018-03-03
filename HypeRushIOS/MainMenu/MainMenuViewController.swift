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

class MainMenuViewController: UIViewController {
    
    @IBAction func buttonAction(_ sender: Any) {
        switch ((sender as! UIButton).tag) {
            case 0:
                print("Im here!")
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
