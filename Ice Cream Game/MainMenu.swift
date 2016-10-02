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
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.backgroundColor = SKColor.black
        
        self.titleLabel = SKLabelNode(fontNamed: "Cochin")
        self.titleLabel!.fontSize = 42
        self.titleLabel!.fontColor = UIColor.blue
        self.titleLabel!.text = "Play The Game"
        self.titleLabel!.name = "Menu"
        self.titleLabel!.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        //        self.titleLabel!.position = CGPoint(x: CGRectGetMidX(self.scene!.frame), y: CGRectGetMidY(self.scene!.frame))
        
        self.addChild(self.titleLabel!)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first?.location(in: self)
        
        if self.titleLabel!.frame.contains(touch!) {
            let transition = SKTransition.crossFade(withDuration: 1)
            let gameScene = GameScene(fileNamed: "GameScene")
            
            self.scene?.view?.presentScene(gameScene!, transition: transition)
            
        }
    }
}
