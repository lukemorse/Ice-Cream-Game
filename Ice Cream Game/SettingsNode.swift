//
//  SettingsNode.swift
//  Ice Cream Game
//
//  Created by Luke Morse on 2/1/17.
//  Copyright © 2017 Luke Morse. All rights reserved.
//

import Foundation
import SpriteKit

class SettingsNode: SKSpriteNode {
    
    var targetScene: SKScene?
    var parentViewBounds: CGRect?
    var areYouSureMenu: SKShapeNode?
    var settingsMenu: SKShapeNode?
    var menuButtons: [MenuButton]?
    var nahButton: MenuButton?
    var yeahButton: MenuButton?
    var sureLabel: SKLabelNode?
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(imageNamed: String, targetScene: SKScene) {
        let imageTexture = SKTexture(imageNamed: imageNamed)
        self.targetScene = targetScene
        self.parentViewBounds = targetScene.view?.bounds
        super.init(texture: imageTexture, color: SKColor.white, size: imageTexture.size())
    }
        
    
    
    
    func bringUpMenu(menu: SKShapeNode, zPos: CGFloat, position: CGPoint) {
        
        menu.fillColor = UIColor.blue
        menu.zPosition = zPos
//        menu.position = CGPoint(x: parentViewBounds.width / 2, y: parentViewBounds.height / 2)
        menu.position = position
        menu.strokeColor = UIColor.red
        menu.glowWidth = 3.0
        menu.alpha = 1.0
        
        targetScene!.addChild(menu)
    }
    
    func bringUpAreYouSureMenu(position: CGPoint) {
        
        let menuSize = CGSize(width: parentViewBounds!.width * 0.67, height: parentViewBounds!.height * 0.67)
        areYouSureMenu = SKShapeNode.init(rectOf: menuSize, cornerRadius: 0.15)
        bringUpMenu(menu: areYouSureMenu!, zPos: 6, position: position)
        
        sureLabel = SKLabelNode(text: "Leave Game?")
        sureLabel!.position = CGPoint(x: areYouSureMenu!.position.x, y: parentViewBounds!.height * 0.7)
        
        let buttonSize = CGSize(width: menuSize.width * 0.75, height: parentViewBounds!.height * 0.08)
        
        let yeahButtonOrigin = CGPoint(x: areYouSureMenu!.position.x / 2, y: parentViewBounds!.height * 0.5)
        let nahButtonOrigin = CGPoint(x: areYouSureMenu!.position.x / 2, y: parentViewBounds!.height * 0.3)
        
        yeahButton = MenuButton.init(rectOf: buttonSize, cornerRadius: 0.2, origin: yeahButtonOrigin, labelText: "Yeah")
        nahButton = MenuButton.init(rectOf: buttonSize, cornerRadius: 0.2, origin: nahButtonOrigin, labelText: "Nah")
        
        yeahButton!.name = "yeahButton"
        nahButton!.name = "nahButton"
        
        yeahButton!.zPosition = 7
        nahButton!.zPosition = 7
        sureLabel!.zPosition = 7
        
        targetScene!.addChild(yeahButton!)
        targetScene!.addChild(nahButton!)
        targetScene!.addChild(sureLabel!)
        
    }
    
    func bringUpSettings(position: CGPoint) {
        
//        settingsAreUp = true
        print(parentViewBounds!)
        let menuSize = CGSize(width: parentViewBounds!.width * 0.67, height: parentViewBounds!.height * 0.67)
        settingsMenu = SKShapeNode.init(rectOf: menuSize, cornerRadius: 0.15)
        bringUpMenu(menu: settingsMenu!, zPos: 4, position: position)
        
        let buttonTexts = ["Main Menu", "Just Play Sound", "Level Info", "Play"]
        
        menuButtons = []
        
        for i in 0...3 {
            
            let yMul = 0.7 - (CGFloat(i) * 0.15)
            let thisOrigin = CGPoint(x: settingsMenu!.position.x / 2, y: parentViewBounds!.height * yMul)
            let buttonSize = CGSize(width: menuSize.width - 50  , height: parentViewBounds!.height * 0.08)
            let thisButton = MenuButton.init(rectOf: buttonSize, cornerRadius: 0.2, origin: thisOrigin, labelText: buttonTexts[i])
            thisButton.name = "Button " + String(i)
            thisButton.zPosition = 4
            menuButtons!.append(thisButton)
            targetScene!.addChild(thisButton)
        }
    }
    
    func ridSureMenu() {
        print("ridded")
        nahButton?.removeFromParent()
        sureLabel?.removeFromParent()
        yeahButton?.removeFromParent()
        areYouSureMenu?.removeFromParent()
    }
    
    func ridSettingsMenu() {
        
        self.settingsMenu?.removeFromParent()
        for button in menuButtons! {
            button.removeFromParent()
        }
    }
}
