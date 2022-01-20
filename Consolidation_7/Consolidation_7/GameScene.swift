//
//  GameScene.swift
//  Consolidation_7
//
//  Created by Lui on 12/01/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var timeLabel: SKLabelNode!
    
    var targetTypes = ["big", "small", "bad"]
    var gameTimer: Timer!
    var isGameOver = false
    var generatingSide = [-176, 1200]
    
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var timeLeft = 60 {
        didSet {
            timeLabel.text = "Time: \(timeLeft)"
        }
    }
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "wood-background")
        background.scale(to: CGSize(width: 1024, height: 768))
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        score = 0
        
        timeLabel = SKLabelNode(fontNamed: "Chalkduster")
        timeLabel.position = CGPoint(x: 980, y: 16)
        timeLabel.horizontalAlignmentMode = .right
        addChild(timeLabel)
        timeLeft = 60
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(generateTarget), userInfo: nil, repeats: true)

        
    }
    
    @objc func generateTarget() {
        guard let target = targetTypes.randomElement() else { return }
        let sprite = SKSpriteNode(imageNamed: target)
        let side = generatingSide.randomElement()!
        var directionVector = 400
        sprite.position = CGPoint(x: side, y: Int.random(in: 1...3)*192)
        sprite.name = target

        if target == "small" {
            sprite.xScale = 0.5
            sprite.yScale = 0.5
        }
        if side > 0 {
            sprite.xScale = sprite.xScale * -1
            directionVector *= -1
        }
        addChild(sprite)
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        sprite.physicsBody?.categoryBitMask = 1
        sprite.physicsBody?.velocity = CGVector(dx: directionVector, dy: 0)
        sprite.physicsBody?.angularDamping = 0
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.collisionBitMask = 0
        
        timeLeft -= 1
        if timeLeft == 0 {
            gameTimer.invalidate()
            let ac = UIAlertController(title: "Game over", message: "Ducks have been terminated", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Restart", style: .default, handler: restartGame))
            let vc = self.view?.window?.rootViewController
            if vc?.presentedViewController == nil {
                vc?.present(ac, animated: true)
            }
        }
        
        
    }
    
    func restartGame(action: UIAlertAction) {
        score = 0
        timeLeft = 60
        gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(generateTarget), userInfo: nil, repeats: true)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        for node in tappedNodes {
            if node.name == "big" {
                score += 1
                node.removeFromParent()
            } else if node.name == "small" {
                score += 2
                node.removeFromParent()
            } else if node.name == "bad"
            {
                score -= 1
                node.removeFromParent()
            }
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
