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
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.backgroundColor = SKColor.black
        
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
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first?.location(in: self)
        
        if self.playButton!.frame.contains(touch!) {
            
            self.playButton!.color = SKColor.red
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first?.location(in: self)
        
        //        if self.titleLabel!.frame.contains(touch!) {
        if self.playButton!.frame.contains(touch!) {
            
            self.playButton!.color = SKColor.green
            
            let transition = SKTransition.crossFade(withDuration: 1)
            let gameScene = GameScene(size: (scene!.size))
            gameScene.scaleMode = .aspectFill
            
            self.scene?.view?.presentScene(gameScene, transition: transition)
        }
    }
}

