//
//  GameScene.swift
//  Project_14
//
//  Created by Lui on 16/11/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var slots = [WhackSlot]()
    var gameScore: SKLabelNode!
    var popupTime = 0.85
    var numRounds = 0
    
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170) , y: 410))}
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170) , y: 320))}
        for i in 0..<5 { createSlot(at: CGPoint(x: 100 + (i * 170) , y: 230))}
        for i in 0..<4 { createSlot(at: CGPoint(x: 180 + (i * 170) , y: 140))}
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1 ) { [weak self] in
            self?.createEnemy()
            }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        for node in tappedNodes {
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            
            if node.name == "charFriend" && whackSlot.isVisible && !whackSlot.isHit{
                score -= 5
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
                
            } else if node.name == "charEnemy" && whackSlot.isVisible && !whackSlot.isHit {
                
                whackSlot.charNode.xScale = 1.20
                whackSlot.charNode.yScale = 0.60
                score += 1
                
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
            whackSlot.hit()
        }
    }
    
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    
    func createEnemy() {
        
        numRounds += 1
        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            let finalScore = SKLabelNode(fontNamed: "Chalkduster")
            finalScore.fontSize = 60
            finalScore.horizontalAlignmentMode = .center
            finalScore.position = gameOver.position
            finalScore.position.y -= 150
            finalScore.zPosition = 1
            finalScore.text = "Score: \(score)"
            addChild(finalScore)
            
            return
        }
        
        popupTime *= 0.991 //just a multiplier to decrease popup time
        slots.shuffle()
        slots[0].show(hideTime: popupTime)
        
        if Int.random(in: 0...10) > 3 {slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...10) > 5 {slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...10) > 7 {slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...10) > 9 {slots[1].show(hideTime: popupTime) }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
            }
    }
    

}
   
