//
//  HomeScene.swift
//  GyroBalloon
//
//  Created by Ferry Dwianta P on 25/05/23.
//

import Foundation
import SpriteKit

class HomeScene : SKScene {
    private let defaults = UserDefaults.standard
    
    private let balloon = SKSpriteNode(imageNamed: "baloonPink")
    private let background = SKSpriteNode(imageNamed: "background")
    private let start = SKSpriteNode(imageNamed: "ButtonPlay")
    let welcomeLabel = SKLabelNode(text: "Welcome To")
    let appNameLabel = SKLabelNode(text: "GyroBalloon")
    let scoreTitleLabel = SKLabelNode(text: "Highest Score :")
    let scoreLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        scene?.size = view.bounds.size
        scene?.scaleMode = .aspectFill
        physicsWorld.gravity = .zero
        
        createBg()
        createBalloon()
        createAppNameLabel()
        createScoreLabel()
        
        // Add frame for playable area
        let frame = SKPhysicsBody(edgeLoopFrom: self.frame)
        frame.friction = 0
        self.physicsBody = frame
        
        let darkOverlay = SKSpriteNode(imageNamed: "DarkOverlay")
        darkOverlay.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        darkOverlay.zPosition = 3
        darkOverlay.setScale(1.25)
        addChild(darkOverlay)
        
        start.zPosition = 20
        start.name = "PlayButton"
        start.size = CGSize(width: 150, height: 150)
        start.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        addChild(start)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let pointOfTouch = touch.location(in: self)
            if start.contains(pointOfTouch){
                start.removeFromParent()
                welcomeLabel.removeFromParent()
                appNameLabel.removeFromParent()
                scoreTitleLabel.removeFromParent()
                scoreLabel.removeFromParent()
                
                addGameInstruction()
                
                // Give delay to move to gameScene
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    let sceneToMoveTo = GameScene(size: self.size)
                    sceneToMoveTo.scaleMode = self.scaleMode
                    let myTransition = SKTransition.fade(withDuration: 0.5)
                    self.view!.presentScene(sceneToMoveTo, transition: myTransition)
                }
            }
        }
    }
    
    func addGameInstruction() {
        let instructionLabel1 = SKLabelNode(text: "To avoid the obstacle")
        instructionLabel1.position = CGPoint(x: self.size.width / 2, y: (self.size.height / 2) - 20)
        instructionLabel1.fontName = "Athens Classic"
        instructionLabel1.fontSize = 40
        instructionLabel1.fontColor = SKColor(ciColor: .white)
        instructionLabel1.zPosition = 20
        self.addChild(instructionLabel1)
        
        let instructionLabel2 = SKLabelNode(text: "Tilt your phone")
        instructionLabel2.position = CGPoint(x: self.size.width / 2, y: (self.size.height / 2) + 20)
        instructionLabel2.fontName = "Athens Classic"
        instructionLabel2.fontSize = 40
        instructionLabel2.fontColor = SKColor(ciColor: .white)
        instructionLabel2.zPosition = 20
        self.addChild(instructionLabel2)
    }
    
    func createAppNameLabel() {
        welcomeLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height - 110)
        welcomeLabel.fontName = "Athens Classic"
        welcomeLabel.fontSize = 40
        welcomeLabel.fontColor = SKColor(ciColor: .white)
        welcomeLabel.zPosition = 20
        self.addChild(welcomeLabel)
        
        appNameLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height - 170)
        appNameLabel.fontName = "Athens Classic"
        appNameLabel.fontSize = 60
        appNameLabel.fontColor = SKColor(ciColor: .white)
        appNameLabel.zPosition = 20
        self.addChild(appNameLabel)
    }
    
    func createScoreLabel() {
        let highestScore = defaults.integer(forKey: "Score")
        
        scoreTitleLabel.position = CGPoint(x: self.size.width / 2, y: 180)
        scoreTitleLabel.fontName = "Athens Classic"
        scoreTitleLabel.fontSize = 33
        scoreTitleLabel.fontColor = SKColor(ciColor: .white)
        scoreTitleLabel.zPosition = 20
        self.addChild(scoreTitleLabel)
        
        scoreLabel.text = "\(highestScore)"
        scoreLabel.position = CGPoint(x: self.size.width / 2, y: 140)
        scoreLabel.fontName = "Athens Classic"
        scoreLabel.fontSize = 33
        scoreLabel.fontColor = SKColor(ciColor: .white)
        scoreLabel.zPosition = 20
        self.addChild(scoreLabel)
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
