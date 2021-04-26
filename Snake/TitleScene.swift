//
//  TitleScene.swift
//  Snake
//
//  Created by Student on 4/23/21.
//

import Foundation
import SpriteKit
import GameplayKit


class TitleScene: SKScene {
    
    var titleLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        
        let titleLabel = SKLabelNode(fontNamed: "Chalkduster")
        titleLabel.text = "Snake"
        titleLabel.fontSize = 50

        self.addChild(titleLabel)
        
        self.backgroundColor = SKColor.green
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let infoScene = InfoScene(fileNamed: "InfoScene")
        infoScene?.scaleMode = .aspectFill
        self.view?.presentScene(infoScene!, transition: SKTransition.crossFade(withDuration: 1))
    }
}





