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
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var snake = [SKShapeNode]()
    var tail = [SKSpriteNode]()
    var redFruit = SKSpriteNode()
    var yellowFruit = SKSpriteNode()
    var playLabel = SKLabelNode()
    var scoreLabel = SKLabelNode()
    var direction = "Right"
    var timer: Timer?
    var score = 0
    var counter = 0
    var scoreCounter = 0
    var gameOver = true
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.purple
        self.physicsWorld.contactDelegate = self
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        
        addSwipeGestureReconizers()
        makeLabels()
        startGame()
        makeBorder()
    }
    
    func startGame() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(moveSnake), userInfo: nil, repeats: true)
        makeSnake()
        makeRedFruit()
        makeYellowFruit()
        playLabel.alpha = 0
    }
    
    func resetGame() {
        redFruit.removeFromParent()
        yellowFruit.removeFromParent()
        for segment in snake {
            segment.removeFromParent()
        }
        for segment in tail {
            segment.removeFromParent()
        }
        tail = [SKSpriteNode]()
        timer?.invalidate()
        updateLabels()
        playLabel.alpha = 1
    }
    
    func makeLabels() {
        playLabel.fontSize = 48
        playLabel.text = ""
        playLabel.fontName = "Arial"
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        playLabel.name = "play"
        addChild(playLabel)
        
        scoreLabel.fontSize = 32
        scoreLabel.text = "Score: 0"
        scoreLabel.fontName = "Arial"
        scoreLabel.fontColor = .black
        scoreLabel.position = CGPoint(x: frame.midX - 275, y: frame.midY + 495)
        addChild(scoreLabel)
    }
    
    func updateLabels() {
        scoreLabel.text = "Score: \(score)"
    }
    
    func addSwipeGestureReconizers() {
        let gestureDirections: [UISwipeGestureRecognizer.Direction] = [.right, .left, .up, .down]
        for gestureDirection in gestureDirections {
            let gestureReconzier = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            gestureReconzier.direction = gestureDirection
            self.view?.addGestureRecognizer(gestureReconzier)
        }
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
        head.physicsBody?.collisionBitMask = ColliderType.snakeBody
        head.physicsBody?.contactTestBitMask = ColliderType.snakeBody
        
        snake.append(head)
        addChild(head)
        
        // add initial five segments
        for i in 1...2 {
            makeSnakeBody(position: CGPoint(x: frame.midX, y: frame.midY - CGFloat((i * 50)))
            )
        }
    }
    
    func makeSnakeBody(position: CGPoint) {
        let snakeBody = SKSpriteNode(imageNamed: "snakeBody")
        snakeBody.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        snakeBody.position = position
        snakeBody.name = "snakeBody"
        snakeBody.size = CGSize(width: 50, height: 50)
        if(tail.count) > 2 {
            snakeBody.physicsBody = SKPhysicsBody(circleOfRadius: 30)
            snakeBody.physicsBody?.affectedByGravity = false
            snakeBody.physicsBody?.contactTestBitMask = (snakeBody.physicsBody?.collisionBitMask)!
            snakeBody.physicsBody?.contactTestBitMask = ColliderType.snakeBody
            snakeBody.physicsBody?.categoryBitMask = ColliderType.snakeBody
        }
        tail.append(snakeBody)
        addChild(snakeBody)
    }
    
    func makeRedFruit() {
        let i = 0
        if i < 1 {
            counter = 0
            makeSnakeBody(position: tail.last!.position)
            
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
            redFruit.physicsBody?.categoryBitMask = ColliderType.redFruit
            
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
            counter = 0
            makeSnakeBody(position: tail.last!.position)
            makeSnakeBody(position: tail.last!.position)
            
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
            yellowFruit.physicsBody?.categoryBitMask = ColliderType.yellowFruit
            
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
        let min = range.lowerBound + 150
        let max = range.upperBound - 150
        return CGFloat(arc4random_uniform(UInt32(CGFloat(max - min)))) + min
    }
    
    func makeBorder() {
        let bottomBorder = SKSpriteNode(color: UIColor.white, size: CGSize(width:frame.width, height: 50))
        bottomBorder.position = CGPoint(x: frame.midX, y: frame.minY + 105)
        bottomBorder.name = "border"
        bottomBorder.physicsBody = SKPhysicsBody(rectangleOf: bottomBorder.size)
        bottomBorder.physicsBody?.isDynamic = false
        bottomBorder.physicsBody?.contactTestBitMask = bottomBorder.physicsBody?.collisionBitMask ?? 0
        addChild(bottomBorder)
        
        let topBorder = SKSpriteNode(color: UIColor.white, size: CGSize(width:frame.width, height: 50))
        topBorder.position = CGPoint(x: frame.midX, y: frame.maxY - 105)
        topBorder.name = "border"
        topBorder.physicsBody = SKPhysicsBody(rectangleOf: topBorder.size)
        topBorder.physicsBody?.isDynamic = false
        topBorder.physicsBody?.contactTestBitMask = topBorder.physicsBody?.collisionBitMask ?? 0
        addChild(topBorder)
        
        let leftBorder = SKSpriteNode(color: UIColor.white, size: CGSize(width: 50, height:frame.height))
        leftBorder.position = CGPoint(x: frame.minX, y: frame.midY)
        leftBorder.name = "border"
        leftBorder.physicsBody = SKPhysicsBody(rectangleOf: leftBorder.size)
        leftBorder.physicsBody?.isDynamic = false
        leftBorder.physicsBody?.contactTestBitMask = leftBorder.physicsBody?.collisionBitMask ?? 0
        addChild(leftBorder)
        
        let rightBorder = SKSpriteNode(color: UIColor.white, size: CGSize(width: 50, height:frame.height))
        rightBorder.position = CGPoint(x: frame.maxX, y: frame.midY)
        rightBorder.name = "border"
        rightBorder.physicsBody = SKPhysicsBody(rectangleOf: rightBorder.size)
        rightBorder.physicsBody?.isDynamic = false
        rightBorder.physicsBody?.contactTestBitMask = rightBorder.physicsBody?.collisionBitMask ?? 0
        addChild(rightBorder)
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
        var snakeBodyPosition = CGPoint()
        for (index, snakeBody) in tail.enumerated().reversed() {
            if index == 0 {
                snakeBodyPosition = headPosition
            }
            else {
                snakeBodyPosition = tail[index - 1].position
            }
            snakeBody.run(SKAction.move(to: snakeBodyPosition, duration: 0.5))
        }
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
        print("The snake head is moving to \(headPosition)")
        snake[0].run(SKAction.move(to: headPosition, duration: 0.5))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            for node in nodes(at: location) {
                if node.name == "play" {
                    startGame()
                }
            }
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "snake" ||
            contact.bodyB.node?.name == "snake" {
            // snake contact made
            if contact.bodyA.node?.name == "redFruit" ||
                contact.bodyB.node?.name == "redFruit" {
                // snake eats redFruit
                redFruit.removeFromParent()
                print("redFruit contact was made")
                score += 1
                updateLabels()
                makeRedFruit()
            }
            else if contact.bodyA.node?.name == "yellowFruit" ||
                        contact.bodyB.node?.name == "yellowFruit" {
                // snake eats yellowFruit
                yellowFruit.removeFromParent()
                print("redFruit contact was made")
                score += 2
                updateLabels()
                makeYellowFruit()
            }
            else if contact.bodyA.node?.name == "snakeBody" ||
                    contact.bodyB.node?.name == "snakeBody" ||
                    contact.bodyA.node?.name == "border" ||
                    contact.bodyB.node?.name == "border"  {
                // snake touches itself or hits border
                print("snake touched itself or hit border")
                score = 0
                resetGame()
                playLabel.text = "You Lose! Tap to play again"
            }
        }
    }
}
