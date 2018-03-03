//
//  BaseGameScene.swift
//  HypeRushIOS
//
//  Created by Luis F. Perrone on 2/27/18.
//  Copyright © 2018 ThemFireLabs. All rights reserved.
//

import SpriteKit
import GameplayKit
import AudioToolbox
import UIKit

class BaseGameScene: SKScene {
    
    var hypeBeast = SKSpriteNode()
    var scoreLabel = SKLabelNode(fontNamed:"PhosphateInline")
    var gameOverLabel = SKLabelNode(fontNamed:"Helvetica Bold")
    var highScoreLabel = SKLabelNode(fontNamed:"Helvetica Bold")
    var tapToPlayLabel = SKLabelNode(fontNamed:"Helvetica Bold")
    var score = 0
    var timer = Timer()
    var gameStarted = false
    var pauseNode = SKSpriteNode()
    var pauseButton = UIButton()
    var pauseChildren: [SKNode] = []
    var pauseButtonTouched = false
    var highScore = UserDefaults().integer(forKey: "HIGHSCORE")
    var firstRound = true
    var currentTheme = UserDefaults().integer(forKey: "THEMENUMBER")
    var rockTileMap: SKTileMapNode!
    var waterTileMap: SKTileMapNode!
    var groundTileSet: SKTileSet!
    var resumeClicked = false
    var rockTileMapStartingPosition: CGPoint!
    var cam: SKCameraNode?
    var positionChanged = false
    
    var bg = SKSpriteNode()
    
    enum ColliderType: UInt32{
        case HypeBeast = 1
        case Object = 2
        case Ground = 4
        case Gap = 8
        case Wall = 16
        case Coin = 32
    }
    
    var gameOver = false
    var jumpCounter = 0
    var speedVariable1: CGFloat = 100.0
    var speedVariable2: CGFloat = 120.0
    var speedVariable3: CGFloat = 80.0
    var speedVariable4: CGFloat = 60.0
    
    var creationRateVariable: CGFloat = -2.0
    
    
  
    
    func setupPauseScreen() {
        
        let restartButton = SKShapeNode(rect: CGRect(x: -self.frame.width/4, y: -70, width: self.frame.width/2, height: 140), cornerRadius: 6)
        restartButton.fillColor = UIColor.black
        restartButton.name = "restartButton"
        
        let restartLabel = SKLabelNode(fontNamed:"Helvetica Bold")
        restartLabel.fontSize = 36
        restartLabel.text = "RESTART"
        restartLabel.position = CGPoint(x: 0, y: (restartButton.frame.height/2) - (restartLabel.frame.height/2) - 70)
        restartLabel.name = "restartLabel"
        
        let resumeButton = SKShapeNode(rect: CGRect(x: -self.frame.width/4, y: restartButton.frame.height - 40, width: self.frame.width/2, height: 140), cornerRadius: 6)
        resumeButton.fillColor = UIColor.black
        resumeButton.name = "resumeButton"
        
        let resumeLabel = SKLabelNode(fontNamed:"Helvetica Bold")
        resumeLabel.fontSize = 36
        resumeLabel.text = "RESUME"
        resumeLabel.position = CGPoint(x: 0, y: resumeButton.frame.height + (resumeButton.frame.height/2) - (resumeLabel.frame.height/2) - 40)
        resumeLabel.name = "resumeLabel"
        
        let quitButton = SKShapeNode(rect: CGRect(x: -self.frame.width/4, y: -restartButton.frame.height - 40 - restartButton.frame.height/2, width: self.frame.width/2, height: 140), cornerRadius: 6)
        quitButton.fillColor = UIColor.black
        quitButton.name = "quitButton"
        
        let quitLabel = SKLabelNode(fontNamed:"Helvetica Bold")
        quitLabel.fontSize = 36
        quitLabel.text = "QUIT"
        let y = -quitButton.frame.height - (quitButton.frame.height/2) + (quitLabel.frame.height/2)
        quitLabel.position = CGPoint(x: 0, y: y)
        quitLabel.name = "quitLabel"
        
        let pauseFrame = SKShapeNode(rect: self.frame)
        //        restartButton.fillColor = UIColor.black
        pauseFrame.name = "pauseFrame"
        
        restartButton.addChild(restartLabel)
        pauseFrame.addChild(restartButton)
        resumeButton.addChild(resumeLabel)
        pauseFrame.addChild(resumeButton)
        quitButton.addChild(quitLabel)
        pauseFrame.addChild(quitButton)
        
        self.addChild(pauseFrame)
        pauseFrame.zPosition = 1.0
        hypeBeast.zPosition = 0.0
        pauseChildren.append(pauseFrame)
        //        pauseChildren.append(restartButton)
        //        pauseChildren.append(resumeButton)
        //        pauseChildren.append(quitButton)
    }
    
    func removePauseScreen() {
        //        self.removeChildren(in: pauseChildren)
        self.removeChildren(in: pauseChildren)
        self.speed = 1
        pauseChildren = []
    }
    
    func tileMapPhysics(name: SKTileMapNode) {
        let tileMap = name
        
        let tileSize = tileMap.tileSize
        let halfWidth = CGFloat(tileMap.numberOfColumns) / 2.0 * tileSize.width
        let halfHeight = CGFloat(tileMap.numberOfRows) / 2.0 * tileSize.height
        
        for col in 0..<tileMap.numberOfColumns {
            for row in 0..<tileMap.numberOfRows {
                let tileDefinition = tileMap.tileDefinition(atColumn: col, row: row)
                let isEdgeTile = tileDefinition?.name
                print(tileDefinition?.name)
                if (isEdgeTile == "sand_tile") {
                    let x = CGFloat(col) * tileSize.width - halfWidth
                    let y = CGFloat(row) * tileSize.height - halfHeight
                    let rect = CGRect(x: 0, y: 0, width: tileSize.width, height: tileSize.height)
                    let tileNode = SKShapeNode(rect: rect)
                    tileNode.position = CGPoint(x: x, y: y + tileNode.frame.height - 4)
                    tileNode.physicsBody = SKPhysicsBody.init(rectangleOf: tileSize, center: CGPoint(x: tileSize.width / 2.0, y: tileSize.height / 2.0))
                    tileNode.physicsBody?.isDynamic = false
                    tileNode.alpha = 0
                    tileNode.physicsBody?.friction = 0
                    tileNode.physicsBody?.usesPreciseCollisionDetection = true
                    tileNode.physicsBody?.contactTestBitMask = ColliderType.HypeBeast.rawValue
                    tileNode.physicsBody?.collisionBitMask = ColliderType.HypeBeast.rawValue
                    tileNode.physicsBody?.categoryBitMask = ColliderType.Ground.rawValue
                    //                    tileNode.fillColor = UIColor.red
                    tileMap.addChild(tileNode)
                } else if (isEdgeTile == "empty_tile") {
                    print("Im here!")
                    let x = CGFloat(col) * tileSize.width - halfWidth
                    let y = CGFloat(row) * tileSize.height - halfHeight
                    let rect = CGRect(x: 0, y: 0, width: tileSize.width, height: tileSize.height)
                    let tileNode = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "Hype_Coin")), size: CGSize(width: 12, height: 12))
                    tileNode.position = CGPoint(x: x, y: y)
                    tileNode.physicsBody = SKPhysicsBody.init(rectangleOf: tileSize, center: CGPoint(x: tileSize.width / 2.0, y: tileSize.height / 2.0))
//                    tileNode.fillTexture = SKTexture(image: #imageLiteral(resourceName: "tile_50"))
                    tileNode.physicsBody?.isDynamic = false
                    tileNode.alpha = 1
                    tileNode.physicsBody?.friction = 0
                    tileNode.physicsBody?.contactTestBitMask = ColliderType.HypeBeast.rawValue
                    tileNode.physicsBody?.categoryBitMask = ColliderType.Coin.rawValue
                    
                    tileMap.addChild(tileNode)
                }
            }
        }
    }
    
    func setupGame() {
        
        cam = SKCameraNode()
        self.camera = cam
        self.addChild(cam!)
        
//        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
//        self.physicsBody = borderBody
//        self.physicsBody?.friction = 0
//        borderBody.contactTestBitMask = ColliderType.HypeBeast.rawValue //Contact will be detected when red or green ball hit the wall
//        borderBody.categoryBitMask = ColliderType.Wall.rawValue
//        borderBody.collisionBitMask = ColliderType.Wall.rawValue // Collisions between RedBall GreenBall and a Wall will be detected
        
        let bgTexture = SKTexture(imageNamed: "Miami_Level1_Draft.png")
//        bgTexture.size.height = bgTexture.siz.height + 200

        
        let moveBGAnimation = SKAction.move(by: CGVector(dx: -bgTexture.size().width, dy: 0), duration: 120)
        let shiftBGAnimation = SKAction.move(by: CGVector(dx: bgTexture.size().width, dy: 0), duration: 0)
        let moveBGForever = SKAction.repeatForever(SKAction.sequence([moveBGAnimation, shiftBGAnimation]))
        
        var i: CGFloat = 0
        
        while i < 3 {
            
            bg = SKSpriteNode(texture: bgTexture)
            
            bg.position = CGPoint(x: bgTexture.size().width * i, y: self.frame.midY)
            
//            bg.size.height = self.frame.height
            
            bg.run(moveBGForever)
            
            bg.zPosition = -1
            
            self.addChild(bg)
            
            i += 1
        }
        
        var parentNodeWidth: CGFloat = 0.0
        
        for node in self.children {
            parentNodeWidth += node.frame.width
            if node.name == "Rock Map Node" {
                rockTileMap = node as? SKTileMapNode
                tileMapPhysics(name: rockTileMap)
                rockTileMapStartingPosition = rockTileMap.position
                let moveBGAnimation = SKAction.move(by: CGVector(dx: -Int(rockTileMap.frame.width), dy: 0), duration: 110)
                let shiftBGAnimation = SKAction.move(by: CGVector(dx: rockTileMap.frame.width, dy: 0), duration: 0)
                let moveBGForever = SKAction.repeatForever(SKAction.sequence([moveBGAnimation]))
                
                rockTileMap.run(moveBGForever)
            }
        }
        
        let hypeBeastTexture1 = SKTexture(image: #imageLiteral(resourceName: "hypebeast_running"))
        let animation = SKAction.animate(with: [hypeBeastTexture1], timePerFrame: 0.1)
        let makehypeBeastRun = SKAction.repeatForever(animation)
        
        hypeBeast = SKSpriteNode(texture: hypeBeastTexture1)
        
        hypeBeast.position = CGPoint(x: -(self.frame.width/2) + 300, y: -self.frame.height / 3.5)
        
//        hypeBeast.size = CGSize(width: 120, height: hypeBeast.frame.height)
        hypeBeast.run(makehypeBeastRun)
        
        hypeBeast.physicsBody = SKPhysicsBody(circleOfRadius: hypeBeastTexture1.size().height / 8)
        
        hypeBeast.physicsBody?.isDynamic = true
        hypeBeast.physicsBody?.usesPreciseCollisionDetection = true
        
        hypeBeast.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        hypeBeast.physicsBody!.contactTestBitMask = ColliderType.Gap.rawValue | ColliderType.Coin.rawValue
        hypeBeast.physicsBody!.categoryBitMask = ColliderType.HypeBeast.rawValue
        hypeBeast.physicsBody!.collisionBitMask = ColliderType.Ground.rawValue | ColliderType.Wall.rawValue
        hypeBeast.physicsBody?.allowsRotation = false
        
        self.addChild(hypeBeast)
        
        // Right wall
        //        node = [SKNode node];
        //        node.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(CGRectGetWidth(self.frame) - 1.0f, 0.0f, 1.0f, CGRectGetHeight(self.view.frame))];
        //        [self addChild:node];
        
        let ground = SKSpriteNode()
        ground.color = UIColor.red
        ground.physicsBody = SKPhysicsBody(edgeLoopFrom: CGRect(x: 0, y: 0, width: self.frame.width, height: 10))
        ground.physicsBody?.categoryBitMask = ColliderType.Ground.rawValue
        
        ground.position = CGPoint(x: 0, y: (-self.frame.height / 3.5) - 40)
        
        //        let ground = SKNode()
        //
        //        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2.28)
        //
        //        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        //
        //        ground.physicsBody!.isDynamic = false
        //
        //        ground.physicsBody!.contactTestBitMask = ColliderType.hypeBeast.rawValue
        //        //        ground.physicsBody!.categoryBitMask = ColliderType.Ground.rawValue
        //        ground.physicsBody!.collisionBitMask = ColliderType.hypeBeast.rawValue
        
        
        //        self.addChild(ground)
        
        //        scoreLabel.fontName = "6809-chargen"
        scoreLabel.fontSize = 60
        scoreLabel.text = "Attempt 1"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 100)
        scoreLabel.fontColor = UIColor.black
        self.addChild(scoreLabel)
        
        if firstRound == true {
            tapToPlayLabel.fontSize = 36
            tapToPlayLabel.text = "Tap to Start..."
            tapToPlayLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 20)
            tapToPlayLabel.fontColor = UIColor.white
            tapToPlayLabel.name = "tapToPlay"
            //            self.addChild(tapToPlayLabel)
            firstRound = false
        }
    }
    
    override func didFinishUpdate() {
        print("Hype beast y position \(hypeBeast.position.y)")
        print("rocxk map y position \(rockTileMapStartingPosition.y)")

        if ((hypeBeast.position.y + hypeBeast.frame.height * 1.5 >= (self.frame.height/2)) && positionChanged == false) {
            self.camera?.position.y = (self.camera?.position.y)! + 40
            positionChanged = true
            pauseNode.position.y = pauseNode.position.y + 40
        } else if ((hypeBeast.position.y + hypeBeast.frame.height * 1.5 <= (self.frame.height/2)) && positionChanged == true) {
            self.camera?.position.y = (self.camera?.position.y)! - 40
            positionChanged = false
            pauseNode.position.y = pauseNode.position.y - 40
        }
//        self.camera?.position.x = hypeBeast.position.x - 100
    }
    
    func saveHighScore() {
        if score > highScore {
            print(score)
            UserDefaults.standard.set(score, forKey: "HIGHSCORE")
            highScore = UserDefaults().integer(forKey: "HIGHSCORE")
        }
    }
    
    func pause() {
        if pauseButtonTouched == false && gameOver == false {
            hypeBeast.physicsBody?.isDynamic = false
            self.speed = 0
            setupPauseScreen()
            pauseButtonTouched = true
        } else if gameOver == false && pauseButtonTouched == true {
            removePauseScreen()
            hypeBeast.physicsBody?.isDynamic = true
            pauseButtonTouched = false
            resumeClicked = true
        }
    }
    
    func resume() {
        if(gameOver == false) {
            hypeBeast.physicsBody?.isDynamic = true
            pauseButtonTouched = false
            resumeClicked = true
        }
        
        removePauseScreen()
    }
    
    func restart() {
        removePauseScreen()
        gameOver = false
        saveHighScore()
        score = 0
        rockTileMap.removeAllActions()
        rockTileMap.position = rockTileMapStartingPosition
        self.children.filter { $0.name != "pauseButton" && $0.name != "Rock Map Node" }.forEach { $0.removeFromParent() }
        setupGame()
        self.speed = 1
        hypeBeast.physicsBody?.isDynamic = true
        pauseButtonTouched = false
        resumeClicked = true
    }
    
    func quit() {
        let vc = self.view?.window?.rootViewController
        if let nav = vc?.navigationController {
            nav.popViewController(animated: true)
        } else {
            vc?.dismiss(animated: false, completion: nil)
        }
    }

}
