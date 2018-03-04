//
//  MiamiLevelMenuViewController.swift
//  HypeRushIOS
//
//  Created by Luis F. Perrone on 3/4/18.
//  Copyright © 2018 ThemFireLabs. All rights reserved.
//

import UIKit
import GameplayKit

class MiamiLevelMenuViewController: UIViewController {

    @IBAction func buttonAction(_ sender: Any) {
        let skView = self.view as! SKView
        skView.presentScene(nil)
        
        switch ((sender as! UIButton).tag) {
        case 0:
            let level1 = UIStoryboard.viewControllerMain(identifier: "level1") as! LevelOneViewController
            self.navigationController?.present(level1, animated: false, completion: nil)
            break
        case 1:
            let level2 = UIStoryboard.viewControllerMain(identifier: "level2") as! LevelTwoViewController
            self.navigationController?.present(level2, animated: false, completion: nil)
            break
        case 2:
            let level3 = UIStoryboard.viewControllerMain(identifier: "level3") as! LevelThreeViewController
            self.navigationController?.present(level3, animated: false, completion: nil)
            break
        case 3:
            if let nav = self.navigationController {
                nav.popViewController(animated: false)
            } else {
                self.dismiss(animated: false, completion: nil)
            }
            
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
