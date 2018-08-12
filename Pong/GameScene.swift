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
    
    var player: SKSpriteNode?
    var enemy: SKSpriteNode?
    var ball: SKSpriteNode?
    
    override func didMove(to view: SKView) {
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
        
        player = childNode(withName: "Player") as? SKSpriteNode
        enemy = childNode(withName: "Enemy") as? SKSpriteNode
        ball = childNode(withName: "Ball") as? SKSpriteNode
        
        ball?.physicsBody?.applyImpulse(CGVector(dx: 10.0, dy: -10.0))
        physicsWorld.gravity = CGVector(dx: 0.0, dy: 0.0)
    }
    override func update(_ currentTime: TimeInterval) {
        if let ball = ball {
            enemy?.run(SKAction.moveTo(x: ball.position.x, duration: 0.2))
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
