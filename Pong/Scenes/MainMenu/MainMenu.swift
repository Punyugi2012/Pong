//
//  MainMenu.swift
//  Pong
//
//  Created by punyawee  on 13/8/61.
//  Copyright © พ.ศ. 2561 Punyugi. All rights reserved.
//

import SpriteKit

enum ModeGame {
    case ONEPLAYER, TWOPLAYER
}

class MainMenu: SKScene {
    var onePlayer: SKLabelNode?
    var twoPlayer: SKLabelNode?
    override func didMove(to view: SKView) {
        onePlayer = childNode(withName: "1Player") as? SKLabelNode
        twoPlayer = childNode(withName: "2Player") as? SKLabelNode
        setFont()
    }
    private func setFont() {
        onePlayer?.fontName = "OrangeKid-Regular"
        twoPlayer?.fontName = "OrangeKid-Regular"
        let gameName = childNode(withName: "GameName") as? SKLabelNode
        gameName?.fontName = "OrangeKid-Regular"
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            var modeGame: ModeGame!
            if atPoint(location).name == "1Player" {
                modeGame = ModeGame.ONEPLAYER
            }
            else if atPoint(location).name == "2Player" {
                modeGame = ModeGame.TWOPLAYER
            }
            if let gameScene = GameScene(fileNamed: "GameScene") {
                gameScene.scaleMode = .aspectFill
                gameScene.modeGame = modeGame
                view!.presentScene(gameScene)
            }
        }
    }
}
