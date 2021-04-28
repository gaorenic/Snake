//
//  GameScene.swift
//  Snake
//
//  Created by Student on 4/8/21.
//

import Foundation
import SpriteKit
import GameplayKit
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var redFruit = SKShapeNode()
    var yellowFruit = SKShapeNode()
    var loseZone = SKSpriteNode()
    var snake = SKShapeNode()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.purple
        physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        makeLoseZone()
        resetGame()
        
    }
    
    func resetGame() {
        makeRedFruit()
        makeYellowFruit()
        makeSnake()
    }
    
    func makeRedFruit() {
        redFruit.removeFromParent()
        redFruit = SKShapeNode(circleOfRadius: 30)
        redFruit.position = CGPoint(x: frame.midX + 125, y: frame.midY)
        redFruit.strokeColor = .black
        redFruit.fillColor = .red
        redFruit.name = "redFruit"
        
        redFruit.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        redFruit.physicsBody?.isDynamic = false
        redFruit.physicsBody?.usesPreciseCollisionDetection = true
        redFruit.physicsBody?.friction = 0
        redFruit.physicsBody?.affectedByGravity = false
        redFruit.physicsBody?.contactTestBitMask = (redFruit.physicsBody?.collisionBitMask)!
        
        addChild(redFruit)
    }
    
    func makeYellowFruit() {
        let i = 0
        if i < 1 {
            yellowFruit.removeFromParent()
            yellowFruit = SKShapeNode(circleOfRadius: 30)
            yellowFruit.strokeColor = .black
            yellowFruit.fillColor = .yellow
            yellowFruit.name = "yellowFruit"
            
            
            yellowFruit.physicsBody = SKPhysicsBody(circleOfRadius: 30)
            yellowFruit.physicsBody?.isDynamic = false
            yellowFruit.physicsBody?.usesPreciseCollisionDetection = true
            yellowFruit.physicsBody?.friction = 0
            yellowFruit.physicsBody?.affectedByGravity = false
            yellowFruit.physicsBody?.contactTestBitMask = (yellowFruit.physicsBody?.collisionBitMask)!
            
            let widthL = -self.frame.size.width / 2 + yellowFruit.frame.size.width / 2
            let widthH = self.frame.size.width / 2 - yellowFruit.frame.size.width / 2
            let heightL = -self.frame.size.height / 2 + yellowFruit.frame.size.height / 2
            let heightH = self.frame.size.height / 2 - yellowFruit.frame.size.height / 2
            let randWidth = randomNumber(range: widthL..<widthH)
            let randHeight = randomNumber(range: heightL..<heightH)
            
            yellowFruit.position = CGPoint(x: randWidth, y: randHeight)
            
            addChild(yellowFruit)
          }
        }

    func makeSnake() {
        snake.removeFromParent()
        snake = SKShapeNode(circleOfRadius: 30)
        snake.position = CGPoint(x: frame.midX, y: frame.midY)
        snake.strokeColor = .black
        snake.fillColor = .black
        snake.name = "snake"
        
        snake.physicsBody = SKPhysicsBody(circleOfRadius: 30)
        snake.physicsBody?.isDynamic = false
        snake.physicsBody?.usesPreciseCollisionDetection = true
        snake.physicsBody?.friction = 0
        snake.physicsBody?.affectedByGravity = false
        snake.physicsBody?.contactTestBitMask = (snake.physicsBody?.collisionBitMask)!
        
        addChild(snake)
    }
    
    func randomNumber(range: Range<CGFloat>) -> CGFloat {
        //function that gives a random number of a range of CGFloats entered
        let min = range.lowerBound
        let max = range.upperBound
        return CGFloat(arc4random_uniform(UInt32(CGFloat(max - min)))) + min
    }
    
    func makeLoseZone() {
        loseZone = SKSpriteNode(color: .red, size: CGSize(width: frame.width, height: 50))
        loseZone.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        loseZone.name = "loseZone"
        loseZone.physicsBody = SKPhysicsBody( rectangleOf: loseZone.size)
        loseZone.physicsBody?.isDynamic = false
        addChild(loseZone)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
        
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        for touch in touches {
            
            let location = touch.location(in: self)
            
            snake.position.x = location.x
            snake.position.y = location.y
            
        }
    }
    
        
    

}
