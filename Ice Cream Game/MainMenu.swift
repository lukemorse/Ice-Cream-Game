//
//  MainMenu.swift
//  Ice Cream Game
//
//  Created by Luke Morse on 10/2/16.
//  Copyright © 2016 Luke Morse. All rights reserved.
//

import Foundation
import SpriteKit

class MainMenu: SKScene {
    
    var background: SKSpriteNode?
    var playLabel: SKLabelNode?
    var playButton: SKSpriteNode?
    var highScoresLabel: SKLabelNode?
    var highScoresButton: SKSpriteNode?
    var iceCreamChar: IceCream?
    var mouthChar: Mouth?
    var mouthPosition: CGPoint?
    var backgroundMusic: SoundNode!
    
//    var dur: TimeInterval = 1.0
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.backgroundColor = SKColor.blue
        
        if let musicURL = Bundle.main.url(forResource: "bgmusicLevel6", withExtension: "mp3") {
            backgroundMusic = SoundNode(url: musicURL)
            addChild(backgroundMusic)
        }
        
        background = SKSpriteNode.init(imageNamed: "bg1.jpg")
        background!.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        background!.position = CGPoint(x: 0.0, y: 0.0)
        background!.zPosition = 0
        addChild(background!)
        
        self.playLabel = SKLabelNode(fontNamed: "Cochin")
        self.playLabel!.fontSize = 30
        self.playLabel!.fontColor = UIColor.blue
        self.playLabel!.text = "Play The Game"
        self.playLabel!.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        self.playLabel!.zPosition = 1
        
        self.highScoresLabel = SKLabelNode(fontNamed: "Cochin")
        self.highScoresLabel!.fontSize = 30
        self.highScoresLabel!.fontColor = UIColor.blue
        self.highScoresLabel!.text = "High Scores"
        self.highScoresLabel!.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 4)
        self.highScoresLabel!.zPosition = 1
        
        self.playButton = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 200, height: 44))
        self.playButton!.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        
        self.highScoresButton = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 200, height: 44))
        self.highScoresButton!.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 4)
        
        self.addChild(self.playLabel!)
        self.addChild(self.playButton!)
        self.addChild(self.highScoresLabel!)
        self.addChild(self.highScoresButton!)
        
        backgroundChange()
        
        mouthCount = 100
    }
    
    func backgroundChange() {
        
        iceCreamChar = IceCream(imageNamed: "ice cream")
        addChild(iceCreamChar!)
        iceCreamChar!.position = CGPoint(x: self.frame.width / 2, y: self.frame.height)

//        makeCharDance(char: iceCreamChar!, startingPoint: CGPoint(x: 0, y: 0))
        
        mouthChar = Mouth(imageNamed: "mouth1")
        mouthChar!.alpha = 1.0
        addChild(mouthChar!)
        mouthChar!.position = CGPoint(x: self.frame.width / 2, y: self.frame.height)
        mouthPosition = mouthChar!.position
        
        mouthChar!.physicsBody?.collisionBitMask = BodyType.hole.rawValue
        iceCreamChar!.physicsBody?.collisionBitMask = BodyType.hole.rawValue

//        makeCharDance(char: mouthChar!, startingPoint: CGPoint(x: 100, y: 100))
        let pointList = makePointsAndDurs(originalPoint: mouthChar!.position)
        var iceCreamMovements: [SKAction] = []
        var mouthMovements: [SKAction] = []
        for i in pointList.listOfDurs.indices {
            var thisAction = SKAction.move(to: pointList.listOfPoints[i], duration: pointList.listOfDurs[i])
            iceCreamMovements.append(thisAction)
            
            if i == 0 {
                thisAction = SKAction.move(to: pointList.listOfPoints[i], duration: pointList.listOfDurs[i] + 0.3)
            }
            mouthMovements.append(thisAction)
        }
        
        print(pointList)
        
        iceCreamChar!.run(SKAction.repeatForever(SKAction.sequence(iceCreamMovements)))
        mouthChar!.run(SKAction.repeatForever(SKAction.sequence(mouthMovements)))
        
        let rotate = SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 0.6))
        iceCreamChar!.run(rotate)
        mouthChar!.run(rotate)
        
    }
    
    func makePointsAndDurs(originalPoint: CGPoint) -> (listOfPoints: [CGPoint], listOfDurs: [TimeInterval]) {
        
        var listOfPoints: [CGPoint] = []
        var listOfDurs: [TimeInterval] = []
        var previousPoint = originalPoint
        for _ in 0...10 {
            let randX = CGFloat(Int(arc4random_uniform(UInt32(view!.bounds.width))))
            let randY = CGFloat(Int(arc4random_uniform(UInt32(view!.bounds.height))))
            let thisPoint = CGPoint(x: randX, y: randY)
            
            let x = abs(previousPoint.x - thisPoint.x)
            let y = abs(previousPoint.y - thisPoint.y)
            
            let distance = Double(sqrt((x * x) + (y * y)))
            let thisDur: TimeInterval = distance * 0.002
            
            listOfPoints.append(thisPoint)
            listOfDurs.append(thisDur)
            
            previousPoint = thisPoint
        }
        
        return (listOfPoints, listOfDurs)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first?.location(in: self)
        
        if self.playButton!.frame.contains(touch!) {
            
            self.playButton!.color = SKColor.red
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first?.location(in: self)
        
        if self.playButton!.frame.contains(touch!) {
            
            self.playButton!.color = SKColor.green
            
            let transition = SKTransition.crossFade(withDuration: 1)
            let gameScene = GameScene(size: (scene!.size))
            gameScene.scaleMode = .aspectFill
            
            self.scene?.view?.presentScene(gameScene, transition: transition)
        }
            
        else if self.highScoresButton!.frame.contains(touch!) {
            
            self.highScoresButton!.color = SKColor.green
            
            let transition = SKTransition.crossFade(withDuration: 1)
            let highScoresScene = HighScores(size: (scene!.size))
            highScoresScene.scaleMode = .aspectFill
            
            self.scene?.view?.presentScene(highScoresScene, transition: transition)
        }
    }
}

