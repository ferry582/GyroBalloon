//
//  GameScene.swift
//  GyroBalloon
//
//  Created by Ferry Dwianta P on 23/05/23.
//

import Foundation
import SpriteKit
import CoreMotion

class GameScene : SKScene, SKPhysicsContactDelegate, ObservableObject {
    
    private let manager = CMMotionManager()
    private let balloon = SKSpriteNode(imageNamed: "baloonPink")
    private let obstacle = SKSpriteNode(imageNamed: "obstaclePaku")
    private let background = SKSpriteNode(imageNamed: "background")
    private let scoreLabel = SKLabelNode(text: "Score : 0")
    private let hapticFeedback = UIImpactFeedbackGenerator(style: .medium)
    private let hapticNotification = UINotificationFeedbackGenerator()
    var isBaloonBurst = false
    var movingSpeed: CGFloat = 3
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        // Configure scene
        scene?.size = view.bounds.size
        scene?.scaleMode = .aspectFill
        
        self.physicsWorld.contactDelegate = self
        
        // Configure CoreMotion accelerometer
        manager.startAccelerometerUpdates()
        manager.accelerometerUpdateInterval = 0.1
        manager.startAccelerometerUpdates(to: OperationQueue.main) { data, error in
            // Everything inside this scope will be trigger every 0.1 second
            
            self.physicsWorld.gravity = CGVectorMake(CGFloat((data?.acceleration.x)!) * 20, CGFloat((data?.acceleration.y)!) * 20) // Multiple by 20 so the player can move faster.
            
        }
        
        createBg()
        createBalloon()
        createObstacle()
        createScoreLabel()
        
        // Add frame for playable area
        let frame = SKPhysicsBody(edgeLoopFrom: self.frame)
        frame.friction = 0
        frame.categoryBitMask = 2
        frame.collisionBitMask = 1
        self.physicsBody = frame
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 2 || bodyA.categoryBitMask == 2 && bodyB.categoryBitMask == 1 {
            hapticFeedback.impactOccurred() // When player hit wall
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        // Check is the balloon hit the obstacle
        if balloon.intersects(obstacle) {
            balloon.removeFromParent()
            
            // Making sure balloonon only burst once
            if !isBaloonBurst {
                playSound(sound: "BalloonBlowsUp", type: "wav", loop: 0)
                hapticNotification.notificationOccurred(.error)
                
                // Play background sound again
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    playSound(sound: "bgMusic", type: "m4a", loop: -1)
                }
                
            }
            
            isBaloonBurst = true // To prevent balloonon burst repeatedly
            
            // Game over scene
            let gameOverScene = GameOverScene(score: score)
            gameOverScene.scaleMode = scaleMode
            let reveal = SKTransition.fade(withDuration: 0.5)
            view?.presentScene(gameOverScene, transition: reveal)
        }
        
    }
    
    func createScoreLabel() {
        scoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height - 80)
        scoreLabel.fontName = "Athens Classic"
        scoreLabel.fontSize = 36
        scoreLabel.fontColor = .black
        scoreLabel.zPosition = 2
        
        score = 0
        self.addChild(scoreLabel)
    }
    
    func createBg() {
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.size = CGSize(width: self.size.width, height: self.size.height)
        background.zPosition = 1
        //        background.setScale(0.85)
        addChild(background)
    }
    
    func createBalloon() {
        balloon.position = CGPoint(x: size.width/2, y: 200)
        balloon.size = CGSize(width: 60, height: 70)
        balloon.zPosition = 10
        balloon.physicsBody = SKPhysicsBody(circleOfRadius: balloon.size.width / 2)
        
        balloon.physicsBody?.friction = 0
        balloon.physicsBody?.restitution = 0.2 // Default value
        balloon.physicsBody?.linearDamping = 0 // increased friction
        balloon.physicsBody?.angularDamping = 0
        balloon.physicsBody?.allowsRotation = true
        
        balloon.physicsBody?.categoryBitMask = 1
        balloon.physicsBody?.collisionBitMask = 2
        balloon.physicsBody?.fieldBitMask = 1
        balloon.physicsBody?.contactTestBitMask = 2
        
        balloon.name = "player"
        addChild(balloon)
    }
    
    @objc func createObstacle() {
        obstacle.position = CGPoint(x: CGFloat.random(in: 0 ... self.size.width), y: size.height)
        obstacle.zPosition = 10
        obstacle.size = CGSize(width: 160, height: 70)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        
        obstacle.physicsBody?.isDynamic = false
        obstacle.physicsBody?.pinned = false
        obstacle.physicsBody?.affectedByGravity = false
        
        obstacle.physicsBody?.categoryBitMask = 2
        obstacle.physicsBody?.collisionBitMask = 1
        obstacle.physicsBody?.fieldBitMask = 1
        obstacle.physicsBody?.contactTestBitMask = 1
        
        obstacle.name = "obstacleName"
        addChild(obstacle)
        
        // Move obstacle from top to bottom
        let move = SKAction.moveTo(y: -obstacle.size.width, duration: movingSpeed)
        let remove = SKAction.removeFromParent()
        let sequenceAction = SKAction.sequence([move, remove])
        
        updateScore()
        
        obstacle.run(sequenceAction) {
            self.createObstacle()
        }
        
    }
    
    func updateScore() {
        self.score += 1 // Update score everytime the obstacle has reached bottom
        if score % 5 == 0 {
            movingSpeed -= movingSpeed * 0.05 // Increase difficulty
        }
    }
    
}


