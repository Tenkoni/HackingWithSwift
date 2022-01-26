//
//  GameScene.swift
//  Project_23
//
//  Created by Lui on 20/01/22.
//

import SpriteKit
import GameplayKit
import AVFoundation

enum ForceBomb {
    case never, always, random
}

enum SequenceType: CaseIterable {
    case oneNoBomb, twoWithOneBomb, one, two, three, four, chain, fastChain
}

class GameScene: SKScene {
    
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet{
            gameScore.text = "Score: \(score)"
        }
    }
    
    var livesImages = [SKSpriteNode]()
    var lives = 3
    
    var activeSliceBG: SKShapeNode!
    var activeSliceFG: SKShapeNode!
    var activeSlicePoints = [CGPoint]()
    
    var isSoundPlaying = false
    var activeEnemies = [SKSpriteNode]()
    
    var bombSoundEffect: AVAudioPlayer!
    
    var popUpTime = 0.9
    var sequence = [SequenceType]()
    var sequencePosition = 0
    var chainDelay = 3.0
    var nextSequence = true
    
    var isGameEnd = false
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85
        
        createScore()
        createLives()
        createSlices()
        
        sequence = [.oneNoBomb, .oneNoBomb, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]
        
        for _ in 0...1000 {
            if let nextSequence = SequenceType.allCases.randomElement() {
                sequence.append(nextSequence)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            [weak self] in
            self?.tossEnemies()
        }
        
    }
    
    
    func createScore() {
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.fontSize = 46
        gameScore.horizontalAlignmentMode = .left
        addChild(gameScore)
        
        gameScore.position = CGPoint(x: 8, y: 8)
        score = 0
        
    }
    
    func createLives() {
        for i in 0..<3 {
            let spriteNode = SKSpriteNode(imageNamed: "sliceLife")
            spriteNode.position = CGPoint(x: 834 + i*70, y: 720)
            addChild(spriteNode)
            livesImages.append(spriteNode)
        }
    }
    
    func createSlices() {
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        activeSliceBG.strokeColor = UIColor(red: 1, green: 0.9, blue: 0, alpha: 1) //orange
        activeSliceBG.lineWidth = 9
        addChild(activeSliceBG)
        
        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 3
        activeSliceFG.strokeColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1) //white lol
        activeSliceFG.lineWidth = 5
        addChild(activeSliceFG)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        activeSlicePoints.removeAll(keepingCapacity: true)
        
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        
        redrawActiveSlice()
        activeSliceFG.removeAllActions()
        activeSliceBG.removeAllActions()
        
        activeSliceFG.alpha = 1
        activeSliceBG.alpha = 1
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isGameEnd == false else {return}

        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        activeSlicePoints.append(location)
        redrawActiveSlice()
        if !isSoundPlaying {
            playCutSound()
        }
        
        let nodesAtPoint = nodes(at: location)
        
        for case let node as SKSpriteNode in nodesAtPoint {
            if node.name == "enemy"{
                if let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy") {
                    emitter.position = node.position
                    addChild(emitter)
                }
                node.name = ""
                node.physicsBody?.isDynamic = false
                
                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                
                let group = SKAction.group([scaleOut,fadeOut])
                let seq = SKAction.sequence([group, .removeFromParent()])
                node.run(seq)
                
                score += 1
                
                if let index = activeEnemies.firstIndex(of: node) {
                    activeEnemies.remove(at: index)
                }
                
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                
            } else if node.name == "enemyEvil"{
                if let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy") {
                    emitter.position = node.position
                    addChild(emitter)
                }
                node.name = ""
                node.physicsBody?.isDynamic = false
                
                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                
                let group = SKAction.group([scaleOut,fadeOut])
                let seq = SKAction.sequence([group, .removeFromParent()])
                node.run(seq)
                
                score += 5
                
                if let index = activeEnemies.firstIndex(of: node) {
                    activeEnemies.remove(at: index)
                }
                
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                
            } else if node.name == "bomb" {
                guard let bombContainer = node.parent as? SKSpriteNode else { continue }
                
                if let emitter = SKEmitterNode(fileNamed: "sliceHitBomb") {
                    emitter.position = bombContainer.position
                    addChild(emitter)
                }
                node.name = ""
                bombContainer.physicsBody?.isDynamic = false
                
                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut,fadeOut])
                let seq = SKAction.sequence([group, .removeFromParent()])
                
                bombContainer.run(seq)
                
                if let index = activeEnemies.firstIndex(of: bombContainer) {
                    activeEnemies.remove(at: index)
                }
                
                run(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false))
                endGame(triggerByBomb: true)
            }
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
    }
    
    func redrawActiveSlice() {
        if activeSlicePoints.count < 2{
            activeSliceFG.path = nil
            activeSliceBG.path = nil
            return
        }
        
        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
        }
        
        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])
        
        for i in 1 ..< activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }
        
        activeSliceFG.path = path.cgPath
        activeSliceBG.path = path.cgPath
    }
    
    func playCutSound() {
        isSoundPlaying = true
        
        let randomNumber = Int.random(in: 1...3)
        let soundName = "swoosh\(randomNumber).caf"
        
        let swooshsdound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)
        run(swooshsdound) { [weak self] in
            self?.isSoundPlaying = false
            print("sound finished")
        }
        
    }
    
    func createEnemy(forceBomb: ForceBomb = .random) {
        let enemy: SKSpriteNode
        var enemyType = Int.random(in: 0...6)
        
        if forceBomb == .never {
            enemyType = 1
        } else if forceBomb == .always {
            enemyType = 0
        }
        
        if enemyType == 0{
            enemy = SKSpriteNode()
            enemy.zPosition = 1
            enemy.name = "bombContainer"
            let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
            bombImage.name = "bomb"
            enemy.addChild(bombImage)
            
            if bombSoundEffect != nil {
                bombSoundEffect?.stop()
                bombSoundEffect = nil
            }
            if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: ".caf") {
                if let sound = try? AVAudioPlayer(contentsOf: path) {
                    bombSoundEffect = sound
                    sound.play()
                }
            }
            
            if let emitter = SKEmitterNode(fileNamed: "sliceFuse") {
                emitter.position = CGPoint(x: 76, y: 64)
                enemy.addChild(emitter)
            }
            
        } else if enemyType == 4 {
            enemy = SKSpriteNode(imageNamed: "penguin")
            let enemyColorDifference = SKSpriteNode(color: .red, size: CGSize(width: (enemy.texture?.cgImage().width)!/2, height: (enemy.texture?.cgImage().height)!/2))
            enemyColorDifference.position = enemy.position
            enemy.addChild(enemyColorDifference)	
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
            enemy.name = "enemyEvil"
        } else {
            enemy = SKSpriteNode(imageNamed: "penguin")
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
            enemy.name = "enemy"
        }
        
        let randomPosition = CGPoint(x: Int.random(in: 64...960), y: -128)
        enemy.position = randomPosition
        
        let randomAngularVelocity = CGFloat.random(in: -3...3)
        let randomXVelocity: Int
        
        if randomPosition.x < 256 {
            randomXVelocity = Int.random(in: 8...15)
        } else if randomPosition.x < 512 {
            randomXVelocity = Int.random(in: 3...5)
        } else if randomPosition.x < 768 {
            randomXVelocity = -Int.random(in: 3...5)
        } else {
            randomXVelocity = -Int.random(in: 8...15)
        }
        
        let randomYvelocity = Int.random(in: 24...32)
    
        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity*40, dy: randomYvelocity*40)
        enemy.physicsBody?.angularVelocity = randomAngularVelocity
        enemy.physicsBody?.collisionBitMask = 0
        
        
        addChild(enemy)
        activeEnemies.append(enemy)
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        if activeEnemies.count > 0 {
            for (index, node) in activeEnemies.enumerated().reversed() {
                if node.position.y < -140 {
                    node.removeAllActions()
                    if node.name == "enemy" {
                        node.name = ""
                        substractLife()
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    } else if node.name == "enemyEvil" {
                        node.name = ""
                        substractLife()
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    } else if node.name == "bombContainer" {
                        node.name = ""
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    }
                    

                }
            }
        } else {
            if !nextSequence {
                DispatchQueue.main.asyncAfter(deadline: .now() + popUpTime) {
                    [weak self] in
                    self?.tossEnemies()
                }
                nextSequence = true
            }
        }
        
        var bombCount = 0
        
        for node in activeEnemies {
            if node.name == "bombContainer"{
                bombCount += 1
                break
            }
        }
        if bombCount == 0 {
            bombSoundEffect?.stop()
            bombSoundEffect = nil
        }
        
        
        
        
    }
    
    func tossEnemies () {
        guard isGameEnd == false else {return}
        popUpTime *= 0.991
        chainDelay *= 0.99
        physicsWorld.speed *= 1.02
        
        let sequenceType = sequence[sequencePosition]
        
        switch sequenceType {
        case .oneNoBomb:
            createEnemy(forceBomb: .never)
        case .one:
            createEnemy()
        case .two:
            createEnemy()
            createEnemy()
        case .twoWithOneBomb:
            createEnemy(forceBomb: .never)
            createEnemy(forceBomb: .always)
        case .three:
            createEnemy()
            createEnemy()
            createEnemy()
        case .four:
            createEnemy()
            createEnemy()
            createEnemy()
            createEnemy()
        case .chain:
            createEnemy()
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay/5.0 ) {[weak self] in self?.createEnemy()}
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay/5.0*2) {[weak self] in self?.createEnemy()}
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay/5.0*3) {[weak self] in self?.createEnemy()}
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay/5.0*4) {[weak self] in self?.createEnemy()}
        case .fastChain:
            createEnemy()
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay/10.0 ) {[weak self] in self?.createEnemy()}
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay/10.0*2) {[weak self] in self?.createEnemy()}
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay/10.0*3) {[weak self] in self?.createEnemy()}
            DispatchQueue.main.asyncAfter(deadline: .now() + chainDelay/10.0*4) {[weak self] in self?.createEnemy()}
        }
        
        sequencePosition += 1
        nextSequence = false
    }
    
    func substractLife() {
        lives -= 1
        run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))
        var life: SKSpriteNode
        
        if lives == 2 {
            life = livesImages[0]
        } else if lives == 1 {
            life = livesImages[1]
        } else {
            life = livesImages[2]
            endGame(triggerByBomb: false)
        }
        life.texture = SKTexture(imageNamed: "sliceLifeGone")
        life.xScale = 1.3
        life.yScale = 1.3
        life.run(SKAction.scale(by: 1, duration: 0.1))
    }
    
    func endGame(triggerByBomb: Bool) {
        guard isGameEnd == false else {return}
        
        isGameEnd = true
        physicsWorld.speed = 0
        isUserInteractionEnabled = false
        
        bombSoundEffect?.stop()
        bombSoundEffect = nil
        
        if triggerByBomb {
            livesImages[0].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[1].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[2].texture = SKTexture(imageNamed: "sliceLifeGone")
        }
        
    }
    
}
