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
    static let snakeBody: UInt32 = 4
    static let makeGameBorder: UInt32 = 5
    
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var snake = [SKShapeNode]()
    var snakeBody = SKSpriteNode()
    var redFruit = SKSpriteNode()
    var yellowFruit = SKSpriteNode()
    var playLabel = SKLabelNode()
    var direction = "Right"
    var timer: Timer?

    var snakePB = SKPhysicsBody()
    var snakeBodyPB = SKPhysicsBody()
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.purple
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(moveSnake), userInfo: nil, repeats: true)
        
        snakeBody.physicsBody?.categoryBitMask = ColliderType.snakeBody
        snakeBody.physicsBody?.collisionBitMask = ColliderType.snake
        snakeBody.physicsBody?.contactTestBitMask = ColliderType.snake
        
        redFruit.physicsBody?.categoryBitMask = ColliderType.redFruit
        
        yellowFruit.physicsBody?.categoryBitMask = ColliderType.yellowFruit
        
        addSwipeGestureReconizers()
        resetGame()
        
    }
    
    func resetGame() {
        makeSnake()
        makeRedFruit()
        makeYellowFruit()
    }
    
    func addSwipeGestureReconizers() {
        let gestureDirections: [UISwipeGestureRecognizer.Direction] = [.right, .left, .up, .down]
        for gestureDirection in gestureDirections {
            let gestureReconzier = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            gestureReconzier.direction = gestureDirection
            self.view?.addGestureRecognizer(gestureReconzier)
        }
    }
    
    @objc func handleSwipe(gesture: UIGestureRecognizer) {
        if let gesture = gesture as? UISwipeGestureRecognizer {
            switch gesture.direction {
            case .up:
                if direction != "Down" {
                    direction = "Up"
                }
            case .down:
                if direction != "Up" {
                    direction = "Down"
                }
            case .right:
                if direction != "Left" {
                    direction = "Right"
                }
            case .left:
                if direction != "Right" {
                    direction = "Left"
                }
            default:
                print("No such gesture")
            }
        }
    }
    
    @objc func moveSnake() {
        var headPosition = snake[0].position
        print("The snake head starting location is \(headPosition)")
        switch direction {
        case "Up":
            headPosition.y += 60
        case "Down":
            headPosition.y -= 60
        case "Right":
            headPosition.x += 60
        case "Left":
            headPosition.x -= 60
        default:
            print("move nowhere")
        }
//        //snake[0].run(SKAction.move(to: headPosition, duration: 1.0))
//        for (index, segment) in snake.enumerated() {
//            if index > 0 {
//                let segmentPosition = snake[index - 1].position
//                print("This is segment \(index)")
//                print("Current location: \(segment.parent!.position)")
//                print("Moving to       : \(segmentPosition)")
//                segment.position = segmentPosition
//                //segment.run(SKAction.move(to: segmentPosition, duration: 1.0))
//            }
//        }
        print("The snake head is moving to \(headPosition)")
        snake[0].run(SKAction.move(to: headPosition, duration: 1.0))
    }
    
    func makeSnake() {
        snake = [SKShapeNode]()
        let head = SKShapeNode(circleOfRadius: 30)
        head.position = CGPoint(x: frame.midX, y: frame.midY)
        head.strokeColor = .black
        head.fillColor = .black
        head.name = "snake"
        
        head.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 60))
        head.physicsBody?.isDynamic = true
        head.physicsBody?.usesPreciseCollisionDetection = true
        head.physicsBody?.friction = 0
        head.physicsBody?.affectedByGravity = false
        
        head.physicsBody?.categoryBitMask = ColliderType.snake
        head.physicsBody?.collisionBitMask = ColliderType.redFruit
        head.physicsBody?.contactTestBitMask = ColliderType.redFruit
        head.physicsBody?.collisionBitMask = ColliderType.yellowFruit
        head.physicsBody?.contactTestBitMask = ColliderType.yellowFruit
        
        snake.append(head)
        addChild(head)
    }
    
    func makeSnakeBody() {
        snakeBody = SKSpriteNode(imageNamed: "snakeBody")
        snakeBody.name = "snakeBody"
        snakeBody.size = CGSize(width: 60, height: 60)
        
        snakeBody.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 60))
        snakeBody.physicsBody?.isDynamic = true
        snakeBody.physicsBody?.usesPreciseCollisionDetection = true
        snakeBody.physicsBody?.friction = 0
        snakeBody.physicsBody?.affectedByGravity = false
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
        
        //snakeBody joint
        if contact.bodyA.node!.name == "snake"
        {
            // let joint = SKPhysicsJointFixed.joint(withBodyA: snakePB, bodyB: snakeBodyPB, anchor: CGPoint(x: self.frame - 30, y: self.frame - 30))
            //            contact.bodyB.node!.removeFromParent()
        }
        else
        {
            
        }
        
        if firstBody.node?.name == "snake" && secondBody.node?.name == "makeGameBorder" {
            resetGame()
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for touch in touches {
//
 //           let location = touch.location(in: self)
            
 //           snake.position.x = location.x
  //          snake.position.y = location.y
 //       }
    }
}
