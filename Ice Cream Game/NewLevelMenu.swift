//
//  NewLevelMenu.swift
//  Ice Cream Game
//
//  Created by Luke Morse on 10/9/16.
//  Copyright © 2016 Luke Morse. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

protocol PlayButtonDelegate {
    func OnTouchEnded()
}

class PlayButton: SKSpriteNode {
    
    var delegate: PlayButtonDelegate?
    
    public init(delegate: PlayButtonDelegate?) {
        self.delegate = delegate
        super.init(texture: nil, color: SKColor.yellow, size: CGSize(width: 200, height: 44))
        self.isUserInteractionEnabled = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.isUserInteractionEnabled = true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.color = SKColor.red
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.color = SKColor.green
        self.delegate?.OnTouchEnded()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.color = SKColor.green
    }
}

class NewLevelMenu: SKScene, PlayButtonDelegate {
    
    var newLevel: String?
    
    var titleLabel: SKLabelNode?
    var descLabel: SKMultilineLabel?
//    var playButton: SKSpriteNode?
    var playButton: MenuButton?
    
    var returnScene: SKScene?
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.backgroundColor = SKColor.black
        
//        self.titleLabel = SKLabelNode(fontNamed: "Cochin")
//        self.titleLabel!.fontSize = 30
//        self.titleLabel!.fontColor = UIColor.blue
//        self.titleLabel!.text = "Play!"
//        self.titleLabel!.name = "Menu"
//        self.titleLabel!.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 4)
        
        descLabel = SKMultilineLabel(text: "", labelWidth: Int(self.view!.bounds.width), pos: CGPoint(x: size.width / 2, y: size.height - 20))
        descLabel!.fontSize = 25
        descLabel!.fontColor = UIColor.white
        descLabel!.fontName = "Cochin"
        descLabel!.leading = 27
        descLabel!.text = (levelMenuData[self.newLevel!]?["description"]!)!
        
//        self.playButton = PlayButton(delegate: self)
        let buttonSize = CGSize(width: view.bounds.width * 0.8, height: view.bounds.height * 0.10)
        let playButtonOrigin = CGPoint(x: view.bounds.width * 0.1, y: view.bounds.height * 0.15)
        playButton = MenuButton.init(rectOf: buttonSize, cornerRadius: 0.2, origin: playButtonOrigin, labelText: "Play")
        playButton!.name = "playButton"
        playButton!.zPosition = 2
        
        self.addChild(self.playButton!)
        self.addChild(self.descLabel!)
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let location = touch!.location(in: self)
        var touchedNode = self.nodes(at: location).first
        
        if touchedNode is SKLabelNode {
            touchedNode = touchedNode?.parent
        }
        
        if touchedNode is MenuButton {
            
            let transition = SKTransition.crossFade(withDuration: 1)
            let gameScene = GameScene(size: (scene!.size))
            self.scene!.view!.presentScene(gameScene, transition: transition)
            
        }
    }
    
    func OnTouchEnded() {
        
        let transition = SKTransition.crossFade(withDuration: 1)
        let gameScene = GameScene(size: (scene!.size))
        self.scene!.view!.presentScene(gameScene, transition: transition)

    }
    
    func setNewLevel(newLevel: String) {
        
        self.newLevel = newLevel
        
    }
    
    func setReturnScene(scene: SKScene) {
        
        returnScene = scene
    }
    
    override func willMove(from view: SKView) {
        
    }
}

