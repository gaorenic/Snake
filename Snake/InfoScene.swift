//
//  InfoScene.swift
//  Snake
//
//  Created by Student on 4/23/21.
//

import Foundation
import SpriteKit
import GameplayKit

class InfoScene: SKScene {
    
    var infoLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.blue
        
        let infoLabel = SKLabelNode(fontNamed: "Chalkduster")
        infoLabel.text = "Swipe your finger in the direction you want the snake to move in. If you eat a red fruit, the snake will grow by 1. If you eat a yellow fruit, the snake will grow by 2. Eat a red fruit or a yellow fruit and new one will appear. The game will end if you hit the wall or hit your tail"
        infoLabel.fontColor = .black
        infoLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        infoLabel.preferredMaxLayoutWidth = frame.width-30
        infoLabel.numberOfLines = 12
        infoLabel.fontSize = 40
        infoLabel.position = CGPoint(x: frame.midX, y: frame.midY-125)
        
        self.addChild(infoLabel)

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(fileNamed: "GameScene")
        gameScene?.scaleMode = .aspectFill
        self.view?.presentScene(gameScene!, transition: SKTransition.crossFade(withDuration: 1))
    }
}
