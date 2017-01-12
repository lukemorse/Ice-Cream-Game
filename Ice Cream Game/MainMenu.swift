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
    
    var titleLabel: SKLabelNode?
    var playButton: SKSpriteNode?
    var iceCreamChar: IceCream?
    var mouthChar: Mouth?
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.backgroundColor = SKColor.blue
        
        self.titleLabel = SKLabelNode(fontNamed: "Cochin")
        self.titleLabel!.fontSize = 30
        self.titleLabel!.fontColor = UIColor.blue
        self.titleLabel!.text = "Play The Game"
        self.titleLabel!.name = "Menu"
        self.titleLabel!.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        
        self.playButton = SKSpriteNode(color: SKColor.green, size: CGSize(width: 200, height: 44))
        self.playButton!.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        
        self.addChild(self.titleLabel!)
        self.addChild(self.playButton!)
        
        backgroundChange()
        
        mouthCount = 2
    }
    
    func backgroundChange() {
        
//        let makeBGBlue = SKAction.run {self.backgroundColor = SKColor.blue}
//        let makeBGGreen = SKAction.run {self.backgroundColor = SKColor.green}
//        let makeBGOrange = SKAction.run {self.backgroundColor = SKColor.orange}
//        let makeBGMagenta = SKAction.run {self.backgroundColor = SKColor.magenta}
//        let waitBetween = SKAction.wait(forDuration: 0.2)
//        let seq = SKAction.sequence([waitBetween, makeBGBlue,waitBetween,makeBGGreen,waitBetween,makeBGOrange,waitBetween,makeBGMagenta])
//        run(SKAction.repeatForever(seq))
        
        iceCreamChar = IceCream(imageNamed: "ice cream")
        addChild(iceCreamChar!)
        iceCreamChar!.position = CGPoint(x: self.frame.width / 2, y: self.frame.height)

        makeCharDance(char: iceCreamChar!, startingPoint: CGPoint(x: 0, y: 0))
        
        mouthChar = Mouth(imageNamed: "mouth1")
        addChild(mouthChar!)
        mouthChar!.position = CGPoint(x: self.frame.width / 2, y: self.frame.height)

        makeCharDance(char: mouthChar!, startingPoint: CGPoint(x: 100, y: 100))
        
    }
    
    func makeCharDance(char: SKSpriteNode, startingPoint: CGPoint) {
        
        let rotate = SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1.0)
        
        let origin = startingPoint
        let size = CGSize(width: frame.width * 0.8, height: frame.height * 0.8)
        let rect = CGRect(origin: origin, size: size)
        let circle = UIBezierPath(ovalIn: rect)
        let move = SKAction.follow(circle.cgPath, asOffset: false, orientToPath: false, duration: 3.0)
        
        
        
        char.run(SKAction.repeatForever(move))
        char.run(SKAction.repeatForever(rotate))
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
    }
}

