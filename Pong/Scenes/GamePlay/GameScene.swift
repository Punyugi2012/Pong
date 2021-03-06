//
//  GameScene.swift
//  Pong
//
//  Created by punyawee  on 12/8/61.
//  Copyright © พ.ศ. 2561 Punyugi. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var modeGame: ModeGame!
    var player: SKSpriteNode?
    var enemy: SKSpriteNode?
    var ball: SKSpriteNode?
    var readyTimeLabel: SKLabelNode?
    var scoreEnemyLabel: SKLabelNode?
    var scorePlayerLabel: SKLabelNode?
    var replay: SKLabelNode?
    var home: SKLabelNode?
    var modal: SKSpriteNode?
    var labelInModal: SKLabelNode?
    var score = [0, 0]
    var countTime = 3
    var ballSpeed = 10.0
    
    override func didMove(to view: SKView) {
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
        player = childNode(withName: "Player") as? SKSpriteNode
        enemy = childNode(withName: "Enemy") as? SKSpriteNode
        ball = childNode(withName: "Ball") as? SKSpriteNode
        readyTimeLabel = childNode(withName: "ReadyTime") as? SKLabelNode
        scoreEnemyLabel = childNode(withName: "ScoreEnemy") as? SKLabelNode
        scorePlayerLabel = childNode(withName: "ScorePlayer") as? SKLabelNode
        modal = childNode(withName: "Modal") as? SKSpriteNode
        labelInModal = modal?.childNode(withName: "Label") as? SKLabelNode
        modal?.alpha = 0
        replay = modal?.childNode(withName: "Replay") as? SKLabelNode
        home = modal?.childNode(withName: "Home") as? SKLabelNode
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        setFont()
        prepareStartGame()
    }
    private func setFont() {
        readyTimeLabel?.fontName = "OrangeKid-Regular"
        scorePlayerLabel?.fontName = "OrangeKid-Regular"
        scoreEnemyLabel?.fontName = "OrangeKid-Regular"
        labelInModal?.fontName = "OrangeKid-Regular"
        replay?.fontName = "OrangeKid-Regular"
        home?.fontName = "OrangeKid-Regular"
    }
    private func updateScore(who: SKLabelNode?) {
        if let who = who {
            if who == scorePlayerLabel {
                score[0] += 1
                who.text = "\(score[0])"
            }
            else if who == scoreEnemyLabel {
                score[1] += 1
                who.text = "\(score[1])"
            }
        }
    }
    
    private func prepareStartGame() {
        ball?.alpha = 0
        readyTimeLabel?.alpha = 1
        ball?.position = CGPoint(x: 0, y: 0)
        ball?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        let wait = SKAction.wait(forDuration: 1)
        let blockCode = SKAction.run {
            self.readyTimeLabel?.text = "\(self.countTime)"
            self.countTime -= 1
        }
        let sequence = SKAction.sequence([wait, blockCode])
        readyTimeLabel?.run(SKAction.repeat(sequence, count: 3), completion: {
            self.readyTimeLabel?.run(SKAction.fadeOut(withDuration: 0.3), completion: {
                self.readyTimeLabel?.alpha = 0
                self.countTime = 3
                self.readyTimeLabel?.text = "3"
                self.startGame()
            })
        })
    }
    
    private func startGame() {
        ball?.alpha = 1
        let randomed = Int(arc4random_uniform(2))
        if randomed == 0 {
            ball?.physicsBody?.applyImpulse(CGVector(dx: ballSpeed, dy: -ballSpeed))
        }
        else {
            ball?.physicsBody?.applyImpulse(CGVector(dx: -ballSpeed, dy: ballSpeed))
        }
    }
    
    private func isEndGame() -> Bool {
        if score[0] == 5 || score[1] == 5 {
            return true
        }
        return false
    }
    
    private func goaled(who: SKLabelNode?) {
        updateScore(who: who)
        if isEndGame() {
            ball?.alpha = 0
            ball?.position = CGPoint(x: 0, y: 0)
            ball?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            print("Ended Game")
            showModal()
        }
        else {
            prepareStartGame()
        }
    }
    
    private func showModal() {
        modal?.alpha = 1
        if score[0] == 5 {
            labelInModal?.text = "Player1 Won!"
        }
        else if score[1] == 5 {
            labelInModal?.text = "Player2 Won!"
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if let ball = ball {
            if modeGame == ModeGame.ONEPLAYER {
                enemy?.run(SKAction.moveTo(x: ball.position.x, duration: 0.2))
            }
            if let enemy = enemy, ball.position.y > enemy.frame.maxY {
                goaled(who: scorePlayerLabel)
            }
            if let player = player, ball.position.y < player.frame.minY {
                goaled(who: scoreEnemyLabel)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if modeGame == ModeGame.TWOPLAYER {
                if location.y < 0 {
                    player?.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
                else if location.y > 0 {
                    enemy?.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
            }
            else {
                player?.run(SKAction.moveTo(x: location.x, duration: 0.2))
            }
            if atPoint(location).name == "Replay" {
                if let gameScene = GameScene(fileNamed: "GameScene") {
                    gameScene.scaleMode = .aspectFill
                    gameScene.modeGame = modeGame
                    view!.presentScene(gameScene)
                }
            }
            if atPoint(location).name == "Home" {
                if let mainMenu = MainMenu(fileNamed: "MainMenu") {
                    mainMenu.scaleMode = .aspectFill
                    view!.presentScene(mainMenu)
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            if modeGame == ModeGame.TWOPLAYER {
                if location.y < 0 {
                    player?.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
                else if location.y > 0 {
                    enemy?.run(SKAction.moveTo(x: location.x, duration: 0.2))
                }
            }
            else {
                player?.run(SKAction.moveTo(x: location.x, duration: 0.2))
            }
            if atPoint(location).name == "Replay" {
                if let gameScene = GameScene(fileNamed: "GameScene") {
                    gameScene.scaleMode = .aspectFill
                    gameScene.modeGame = modeGame
                    view!.presentScene(gameScene)
                }
            }
            if atPoint(location).name == "Home" {
                if let mainMenu = MainMenu(fileNamed: "MainMenu") {
                    mainMenu.scaleMode = .aspectFill
                    view!.presentScene(mainMenu)
                }
            }
        }
    }
    
}
