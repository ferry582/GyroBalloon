//
//  HomeScene.swift
//  GyroBalloon
//
//  Created by Ferry Dwianta P on 25/05/23.
//

import Foundation
import SpriteKit

class GameOverScene : SKScene {
    
    private let currentScore: Int
    
    let defaults = UserDefaults.standard

    init(score: Int) {
        self.currentScore = score
        super.init(size: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let balloon = SKSpriteNode(imageNamed: "baloonPink")
    private let background = SKSpriteNode(imageNamed: "background")
    private let restart = SKSpriteNode(imageNamed: "ReplayButton")
    private let back = SKSpriteNode(imageNamed: "HomeButton")
    
    override func didMove(to view: SKView) {
        scene?.size = view.bounds.size
        scene?.scaleMode = .aspectFill
        physicsWorld.gravity = .zero
        
        createBg()
        createBalloon()
        createButton()
        createScoreLabel()

        let darkOverlay = SKSpriteNode(imageNamed: "DarkOverlay")
        darkOverlay.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        darkOverlay.zPosition = 3
        darkOverlay.setScale(1.25)
        addChild(darkOverlay)
        
        let gameOverLabel = SKLabelNode(text: "Game Over")
        gameOverLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height - (self.size.height / 2.5))
        gameOverLabel.fontName = "Athens Classic"
        gameOverLabel.fontSize = 60
        gameOverLabel.fontColor = SKColor(ciColor: .white)
        gameOverLabel.zPosition = 20
        self.addChild(gameOverLabel)
        
        // Add frame for playable area
        let frame = SKPhysicsBody(edgeLoopFrom: self.frame)
        frame.friction = 0
        self.physicsBody = frame
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let pointOfTouch = touch.location(in: self)
            if restart.contains(pointOfTouch){
                let sceneToMoveTo = GameScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
            }
            
            if back.contains(pointOfTouch){
                let sceneToMoveTo = HomeScene(size: self.size)
                sceneToMoveTo.scaleMode = self.scaleMode
                let myTransition = SKTransition.fade(withDuration: 0.5)
                self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                
            }
        }
    }
    
    func createScoreLabel() {
        
        // Save score data with user default
        var scoreText = "Your Score: "
        let highestScore = defaults.integer(forKey: "Score") // read data from user defaults
        if currentScore > highestScore {
            defaults.set(currentScore, forKey: "Score")
            scoreText = "New Highest Score: "
        }
        
        let scoreLabel = SKLabelNode(text: "\(scoreText) \(currentScore)")
        scoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height - (self.size.height / 2.2))
        scoreLabel.fontName = "Athens Classic"
        scoreLabel.fontSize = 30
        scoreLabel.fontColor = SKColor(ciColor: .white)
        scoreLabel.zPosition = 20
        self.addChild(scoreLabel)
    }
    
    func createButton() {
        restart.zPosition = 20
        restart.name = "restart"
        restart.size = CGSize(width: 100, height: 100)
        restart.position = CGPoint(x: self.size.width / 3, y: self.size.height / 2.4)
        addChild(restart)

        back.zPosition = 20
        back.name = "back"
        back.size = CGSize(width: 100, height: 100)
        back.position = CGPoint(x: self.size.width - (self.size.width / 3), y: self.size.height / 2.4)
        addChild(back)
    }
    
    func createBg() {
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.size = CGSize(width: self.size.width, height: self.size.height)
        background.zPosition = 1
        addChild(background)
    }
    
    func createBalloon() {
        
        balloon.position = CGPoint(x: size.width/2, y: size.height/2)
        balloon.zPosition = 2
        balloon.size = CGSize(width: 60, height: 70)
        balloon.physicsBody = SKPhysicsBody(circleOfRadius: balloon.size.width/2)
        balloon.physicsBody?.friction = 0
        balloon.physicsBody?.restitution = 1
        balloon.physicsBody?.linearDamping = 0
        balloon.physicsBody?.angularDamping = 0
        balloon.physicsBody?.allowsRotation = true
        addChild(balloon)
        balloon.physicsBody?.applyImpulse(CGVector(dx: -40, dy: 40))
    }
    
}



