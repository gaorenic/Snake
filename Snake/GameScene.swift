//
//  GameScene.swift
//  Snake
//
//  Created by Student on 4/8/21.
//

import Foundation
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.red

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let infoScene = InfoScene(fileNamed: "InfoScene")
        infoScene?.scaleMode = .aspectFill
        self.view?.presentScene(infoScene!, transition: SKTransition.crossFade(withDuration: 1))
    }
}

