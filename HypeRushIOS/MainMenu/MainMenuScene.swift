import SpriteKit
import GameplayKit
import AudioToolbox

class MainMenuScene: SKScene, SKPhysicsContactDelegate {
    var hypeBeast = SKSpriteNode()
    var rockTileMap: SKTileMapNode!
    var rockTileMapStartingPosition: CGPoint!
    var bg = SKSpriteNode()
    
    enum ColliderType: UInt32{
        case HypeBeast = 1
        case Object = 2
        case Ground = 4
        case Gap = 8
        case Wall = 16
        case Coin = 32
    }
    
    override func sceneDidLoad() {
        
    }


    
    func didBegin(_ contact: SKPhysicsContact) {
        
        
    }
    
    
    override func didMove(to view: SKView) {
        //                    rockTileMap.removeFromParent()
        self.physicsWorld.contactDelegate = self
        self.setupGame()
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }


func setupGame() {
    
    let bgTexture = SKTexture(imageNamed: "Miami_Level1_Draft.png")
    //        bgTexture.size.height = bgTexture.siz.height + 200
    
    
    let moveBGAnimation = SKAction.move(by: CGVector(dx: -bgTexture.size().width, dy: 0), duration: 30)
    let shiftBGAnimation = SKAction.move(by: CGVector(dx: bgTexture.size().width, dy: 0), duration: 0)
    let moveBGForever = SKAction.repeatForever(SKAction.sequence([moveBGAnimation, shiftBGAnimation]))
    
    var i: CGFloat = 0
    
    while i < 3 {
        
        bg = SKSpriteNode(texture: bgTexture)
        
        bg.position = CGPoint(x: bgTexture.size().width * i, y: self.frame.midY + 100)
        
        bg.size.height = self.frame.height + 200
//        bg.size.width = bg.size.width - 400

        
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
            let moveBGForever = SKAction.repeatForever(SKAction.sequence([moveBGAnimation, shiftBGAnimation]))
            
            rockTileMap.run(moveBGForever)
        }
    }

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
                    let tileNode = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "tile_50")), size: CGSize(width: 12, height: 12))
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
    
}
    





