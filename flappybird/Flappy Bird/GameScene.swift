//
//  Flappy Bird
//  Created on Swift
//  Tutorial can be found on jaysplace.github.io
//  Created by Jason Eng
//  Copyright © 2019 JaysPlace. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode() //animate hoga
    var bg = SKSpriteNode()
    var scoreLabel = SKLabelNode()
     var scoreOver = SKLabelNode()
    var score = 0
    var timer = Timer()
    // creating an enum too separate bird and other objects
    enum ColliderTypes: UInt32 {
        
        case Bird = 1
        case Object = 2
        case Gap = 4
    }
    var gameOver = false
    
    @objc func makePipes(){
        //making map
        //making birds
        let gapHeight = bird.size.height * 4
        let movementAmount = arc4random() % UInt32(self.frame.height / 2)
        let pipeOffSet = CGFloat(movementAmount) - self.frame.height / 4
        
        let movePipes = SKAction.move(by: CGVector(dx: -2 * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / 100))
        //scale with screen size
        
        // pipe stuff
        let pipeTexture = SKTexture(imageNamed: "pipe1.png")
        let pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        let pipe1 = SKSpriteNode(texture: pipeTexture)
        pipe1.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeTexture.size().height/2 + gapHeight/2 + pipeOffSet)
        pipe1.run(movePipes)
        
        pipe1.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipe1.physicsBody!.isDynamic = false
        
        
        pipe1.physicsBody!.contactTestBitMask = ColliderTypes.Object.rawValue //with whose contact
        pipe1.physicsBody!.categoryBitMask = ColliderTypes.Object.rawValue //which category
        pipe1.physicsBody!.collisionBitMask = ColliderTypes.Object.rawValue
        pipe1.zPosition = -1
        self.addChild(pipe1)
        
        let pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - pipeTexture.size().height/2 - gapHeight/2 + pipeOffSet)
        pipe2.run(movePipes)
        
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        pipe2.physicsBody!.isDynamic = false
        
        pipe2.physicsBody!.contactTestBitMask = ColliderTypes.Object.rawValue //with whose contact
        pipe2.physicsBody!.categoryBitMask = ColliderTypes.Object.rawValue //which category
        pipe2.physicsBody!.collisionBitMask = ColliderTypes.Object.rawValue
        pipe2.zPosition = -1
        self.addChild(pipe2)
        
        // calculating scores
        
        let gap = SKNode()
        gap.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeOffSet)
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeTexture.size().width, height: gapHeight))
        gap.physicsBody!.isDynamic = false
        gap.run(movePipes)  //same animation as pipes
        
        gap.physicsBody!.contactTestBitMask = ColliderTypes.Bird.rawValue //with whose contact
        gap.physicsBody!.categoryBitMask = ColliderTypes.Gap.rawValue //which category
        gap.physicsBody!.collisionBitMask = ColliderTypes.Gap.rawValue
        
        self.addChild(gap)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if gameOver == false {
        
        if contact.bodyA.categoryBitMask == ColliderTypes.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderTypes.Gap.rawValue {
            
            print("+1 to score")
           score += 1
            scoreLabel.text = String(score)
        
        }
        else{
            print("We have contact")
            self.speed = 0
            gameOver = true
            
            scoreOver.fontName = "Helvetica"
            scoreOver.fontSize = 40
            scoreOver.text = "You Died... Tap to Play Again."
            scoreOver.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            self.addChild(scoreOver)
            timer.invalidate()
        }
     }
    }
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        setupGame()
       
    }
    
    func setupGame() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.makePipes), userInfo: nil, repeats: true)
        
        
        //Background
        let bgTexture = SKTexture(imageNamed: "bg.png")
        let moveBGAnimation = SKAction.move(by: CGVector(dx: -bgTexture.size().width, dy: 0), duration: 9)
        let shiftBGAnimation = SKAction.move(by: CGVector(dx: bgTexture.size().width, dy: 0), duration: 0)
        let moveBGForever = SKAction.repeatForever(SKAction.sequence([moveBGAnimation, shiftBGAnimation]))
        
        var i : CGFloat = 0
        while i < 3 {
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width * i, y: self.frame.midY)
            bg.size.height = self.frame.height
            bg.size.width = 2000
            bg.run(moveBGForever)
            bg.zPosition = -2
            self.addChild(bg)
            i += 1
            
        }
        //bird Attributes
        let birdTexture = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        let birdTexture3 = SKTexture(imageNamed: "flappy3.png")
        let birdTexture4 = SKTexture(imageNamed: "flappy4.png")
        
        let animation = SKAction.animate(with: [birdTexture, birdTexture2, birdTexture3, birdTexture4], timePerFrame: 0.15)
        let makeBirdFlap = SKAction.repeatForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bird.run(makeBirdFlap)
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 2)
        bird.physicsBody!.isDynamic = false
        bird.physicsBody!.contactTestBitMask = ColliderTypes.Object.rawValue //with whose contact
        bird.physicsBody!.categoryBitMask = ColliderTypes.Bird.rawValue //which category
        bird.physicsBody!.collisionBitMask = ColliderTypes.Bird.rawValue
        
        self.addChild(bird)
        
        //Invisible ground
        let ground = SKNode()
        ground.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        ground.physicsBody?.isDynamic = false
        
        ground.physicsBody!.contactTestBitMask = ColliderTypes.Object.rawValue //with whose contact
        ground.physicsBody!.categoryBitMask = ColliderTypes.Object.rawValue //which category
        ground.physicsBody!.collisionBitMask = ColliderTypes.Object.rawValue
        self.addChild(ground)
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPoint(x: self.frame.midX, y: self.frame.height/2 - 70)
        self.addChild(scoreLabel)
    }
  
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        if gameOver == false {
        bird.physicsBody!.isDynamic = true
        bird.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        bird.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 50)) //making tuffer by increasing the value
        }
        else {
            gameOver = false
            score = 0
            self.speed = 1
            self.removeAllChildren()
            setupGame()
        }
       
    }
    
   
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
