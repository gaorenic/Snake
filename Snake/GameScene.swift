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

struct ColliderType {
    
    static let redFruit: UInt32 = 1
    static let yellowFruit: UInt32 = 2
    static let snake: UInt32 = 3
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var snake = SKSpriteNode()
    var redFruit = SKSpriteNode()
    var yellowFruit = SKSpriteNode()
    var gameBorder = SKSpriteNode()
    var playLabel = SKLabelNode()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.purple
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        snake.physicsBody?.categoryBitMask = ColliderType.snake
        snake.physicsBody?.collisionBitMask = ColliderType.redFruit
        snake.physicsBody?.contactTestBitMask = ColliderType.redFruit
        
        redFruit.physicsBody?.categoryBitMask = ColliderType.redFruit
        
        snake.physicsBody?.collisionBitMask = ColliderType.yellowFruit
        snake.physicsBody?.contactTestBitMask = ColliderType.yellowFruit
        
        yellowFruit.physicsBody?.categoryBitMask = ColliderType.yellowFruit
        
        makeGameBorder()
        resetGame()
        
    }
    
    func resetGame() {
        makeSnake()
        makeRedFruit()
        makeYellowFruit()
    }
    
    func makeSnake() {
        snake.removeFromParent()
        snake = SKSpriteNode(imageNamed: "snake")
        snake.name = "snake"
        snake.size = CGSize(width: 60, height: 60)
        snake.position = CGPoint(x: frame.midX, y: frame.midY)
        
        snake.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 60))
        snake.physicsBody?.isDynamic = true
        snake.physicsBody?.usesPreciseCollisionDetection = true
        snake.physicsBody?.friction = 0
        snake.physicsBody?.affectedByGravity = false
        
        addChild(snake)
    }
    
    func makeRedFruit() {
        let i = 0
        if i < 1 {
            redFruit = SKSpriteNode(imageNamed: "redFruit")
            redFruit.removeFromParent()
            redFruit.name = "redFruit"
            redFruit.size = CGSize(width: 60, height: 60)
            
            redFruit.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 60))
            redFruit.physicsBody?.isDynamic = true
            redFruit.physicsBody?.usesPreciseCollisionDetection = true
            redFruit.physicsBody?.friction = 0
            redFruit.physicsBody?.affectedByGravity = false
            redFruit.physicsBody?.contactTestBitMask = ColliderType.redFruit
            
            let widthL = -self.frame.size.width / 2 + redFruit.frame.size.width / 2
            let widthH = self.frame.size.width / 2 - redFruit.frame.size.width / 2
            let heightL = -self.frame.size.height / 2 + redFruit.frame.size.height / 2
            let heightH = self.frame.size.height / 2 - redFruit.frame.size.height / 2
            let randWidth = randomNumber(range: widthL..<widthH)
            let randHeight = randomNumber(range: heightL..<heightH)
            
            redFruit.position = CGPoint(x: randWidth, y: randHeight)
            
            addChild(redFruit)
        }
    }
    
    func makeYellowFruit() {
        let i = 0
        if i < 1 {
            yellowFruit = SKSpriteNode(imageNamed: "yellowFruit")
            yellowFruit.removeFromParent()
            yellowFruit.name = "yellowFruit"
            yellowFruit.size = CGSize(width: 60, height: 60)
            
            yellowFruit.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 60))
            yellowFruit.physicsBody?.isDynamic = true
            yellowFruit.physicsBody?.usesPreciseCollisionDetection = true
            yellowFruit.physicsBody?.friction = 0
            yellowFruit.physicsBody?.affectedByGravity = false
            yellowFruit.physicsBody?.contactTestBitMask = ColliderType.yellowFruit
            
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
    
    func randomNumber(range: Range<CGFloat>) -> CGFloat {
        //function that gives a random number of a range of CGFloats entered
        let min = range.lowerBound
        let max = range.upperBound
        return CGFloat(arc4random_uniform(UInt32(CGFloat(max - min)))) + min
    }
    
    func makeGameBorder() {
        gameBorder = SKSpriteNode(color: .red, size: CGSize(width: frame.width, height: 50))
        gameBorder.position = CGPoint(x: frame.midX, y: frame.minY + 25)
        gameBorder.name = "gameBorder"
        gameBorder.physicsBody = SKPhysicsBody( rectangleOf: gameBorder.size)
        gameBorder.physicsBody?.isDynamic = false
        addChild(gameBorder)
    }
    
    func makeLabels() {
        playLabel.fontSize = 24
        playLabel.text = ""
        playLabel.fontName = "Arial"
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        playLabel.name = "playLabel"
        addChild(playLabel)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        print("contact began")
        if contact.bodyA.node?.name == "snake" {
            
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
            
        }
        if firstBody.node?.name == "snake" && secondBody.node?.name == "redFruit" {
            
            redFruit.removeFromParent()
            print("redFruit contact was made")
            makeRedFruit()
        }
        
        if firstBody.node?.name == "snake" && secondBody.node?.name == "yellowFruit" {
            
            yellowFruit.removeFromParent()
            print("yellowFruit contact was made")
            makeYellowFruit()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            
            let location = touch.location(in: self)
            
            snake.position.x = location.x
            snake.position.y = location.y
        }
    }
}
