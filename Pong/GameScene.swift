//
//  GameScene.swift
//  Pong
//
//  Created by punyawee  on 12/8/61.
//  Copyright © พ.ศ. 2561 Punyugi. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene {
    
    var player: SKSpriteNode?
    var enemy: SKSpriteNode?
    var ball: SKSpriteNode?
    var readyTimeLabel: SKLabelNode?
    var scoreEnemyLabel: SKLabelNode?
    var scorePlayerLabel: SKLabelNode?
    var score = [0, 0]
    var countTime = 3
    
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
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
        prepareStartGame()
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
            ball?.physicsBody?.applyImpulse(CGVector(dx: 8.0, dy: -8.0))
        }
        else {
            ball?.physicsBody?.applyImpulse(CGVector(dx: -8.0, dy: 8.0))
        }
    }
    
    private func goaled() {
        prepareStartGame()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if let ball = ball {
            enemy?.run(SKAction.moveTo(x: ball.position.x, duration: 0.2))
            if let enemy = enemy, ball.position.y > enemy.frame.maxY {
                goaled()
                updateScore(who: scorePlayerLabel)
            }
            if let player = player, ball.position.y < player.frame.minY {
                goaled()
                updateScore(who: scoreEnemyLabel)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            player?.run(SKAction.moveTo(x: location.x, duration: 0.2))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            player?.run(SKAction.moveTo(x: location.x, duration: 0.2))
        }
    }
    
}
