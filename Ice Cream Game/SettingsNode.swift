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
    var highScoresMenu: SKShapeNode?
    var levelInfoMenu: SKShapeNode?
    var levelInfoText: SKMultilineLabel?
    var menuButtons: [MenuButton]?
    var nahButton: MenuButton?
    var yeahButton: MenuButton?
    var sureLabel: SKLabelNode?
    var highScoresLabel: SKLabelNode?
    var clearButton: MenuButton?
    var okCoolButton: MenuButton?
    var highScoresLabelArray: [SKLabelNode]?
    
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
        menu.position = position
        menu.strokeColor = UIColor.red
        menu.glowWidth = 3.0
        menu.alpha = 1.0
        
        targetScene!.addChild(menu)
        let scaleMenu = SKAction.scale(to: 1.0, duration: 0.1)
        menu.run(scaleMenu)
    }
    
    func bringUpAreYouSureMenu(position: CGPoint, zPos: CGFloat, clearScoresFlag: Bool) {
        
        let menuSize = CGSize(width: parentViewBounds!.width * 0.67, height: parentViewBounds!.height * 0.67)
        areYouSureMenu = SKShapeNode.init(rectOf: menuSize, cornerRadius: 0.15)
        bringUpMenu(menu: areYouSureMenu!, zPos: zPos, position: position)
        
        sureLabel = SKLabelNode(text: "You Sure?")
        sureLabel!.position = CGPoint(x: areYouSureMenu!.position.x, y: parentViewBounds!.height * 0.7)
        
        let buttonSize = CGSize(width: menuSize.width * 0.75, height: parentViewBounds!.height * 0.08)
        
        let yeahButtonOrigin = CGPoint(x: areYouSureMenu!.position.x / 2, y: parentViewBounds!.height * 0.5)
        let nahButtonOrigin = CGPoint(x: areYouSureMenu!.position.x / 2, y: parentViewBounds!.height * 0.3)
        
        yeahButton = MenuButton.init(rectOf: buttonSize, cornerRadius: 0.2, origin: yeahButtonOrigin, labelText: "Yeah")
        nahButton = MenuButton.init(rectOf: buttonSize, cornerRadius: 0.2, origin: nahButtonOrigin, labelText: "Nah")
        
        if clearScoresFlag {
            yeahButton!.name = "yeahButton_CLEAR"
        } else {
            yeahButton!.name = "yeahButton"
        }
        nahButton!.name = "nahButton"
        
        
        yeahButton!.zPosition = zPos + 1
        nahButton!.zPosition = zPos + 1
        sureLabel!.zPosition = zPos + 1
        
        targetScene!.addChild(yeahButton!)
        targetScene!.addChild(nahButton!)
        targetScene!.addChild(sureLabel!)
        
    }
    
    func bringUpLevelInfoMenu(position: CGPoint, levelIndex: String) {
        
        let menuSize = CGSize(width: parentViewBounds!.width * 0.67, height: parentViewBounds!.height * 0.67)
        levelInfoMenu = SKShapeNode.init(rectOf: menuSize, cornerRadius: 0.15)
        bringUpMenu(menu: levelInfoMenu!, zPos: 6, position: position)
        
        let buttonSize = CGSize(width: menuSize.width - 50  , height: parentViewBounds!.height * 0.08)
        let okCoolButtonOrigin = CGPoint(x: levelInfoMenu!.position.x / 2, y: parentViewBounds!.height * 0.2)
        okCoolButton = MenuButton(rectOf: buttonSize, cornerRadius: 0.2, origin: okCoolButtonOrigin, labelText: "OK, Cool")
        okCoolButton!.label?.fontSize = 15
        okCoolButton!.zPosition = 7
        okCoolButton!.name = "okCoolButton_LEVEL_INFO"
        targetScene!.addChild(okCoolButton!)
        
        levelInfoText = SKMultilineLabel(text: "", labelWidth: Int(levelInfoMenu!.frame.width * 0.9), pos: CGPoint(x: levelInfoMenu!.frame.midX, y: levelInfoMenu!.frame.maxY * 0.95))
        levelInfoText!.fontSize = 19
        levelInfoText!.fontName = "Cochin"
        levelInfoText!.leading = 19
        levelInfoText!.text = (levelMenuData[levelIndex]!["description"]!)
        levelInfoText!.zPosition = 7
        targetScene!.addChild(levelInfoText!)
    }
    
    func bringUpSettings(position: CGPoint) {
        
        let menuSize = CGSize(width: parentViewBounds!.width * 0.67, height: parentViewBounds!.height * 0.67)
        settingsMenu = SKShapeNode.init(rectOf: menuSize, cornerRadius: 0.15)
        bringUpMenu(menu: settingsMenu!, zPos: 4, position: position)
        
        let buttonTexts = ["Main Menu", "High Scores", "Level Info", "Play"]
        
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
    
    func bringUpHighScores(position: CGPoint, addScoreFlag: Bool) {
        
        var highScores: [Int]?
        var indexOfAddedScore: Int?
        let menuSize = CGSize(width: parentViewBounds!.width * 0.67, height: parentViewBounds!.height * 0.67)
        highScoresMenu = SKShapeNode.init(rectOf: menuSize, cornerRadius: 0.15)
        bringUpMenu(menu: highScoresMenu!, zPos: 6, position: position)
        
        if var prevHighScores = UserDefaults.standard.array(forKey: "highScores") as? [Int] {
            
            if displayedScore >= prevHighScores.last! && addScoreFlag {
                print("score flag raised")
            
                var i = 9
                for score in prevHighScores.reversed() {
                    if displayedScore >= score {
                        indexOfAddedScore = i
                        print("new score is higher than \(score)")
                    }
                    i -= 1
                }
                if indexOfAddedScore != nil {
                    prevHighScores.insert(displayedScore, at: indexOfAddedScore!)
                    prevHighScores.removeLast()
                    highScores = prevHighScores
                    UserDefaults.standard.set(highScores, forKey: "highScores")
                }
                
            } else {
                highScores = prevHighScores
            }
            
        } else {
            highScores = Array(repeating: Int.min, count: 10)
            highScores![0] = displayedScore
            indexOfAddedScore = 0
            UserDefaults.standard.set(highScores, forKey: "highScores")
        }
        
        highScoresLabel = SKLabelNode(text: "HIGH SCORES:")
        highScoresLabel!.fontName = "ChalkboardSE-Light"
        highScoresLabel!.fontSize = 28
        highScoresLabel!.position = CGPoint(x: highScoresMenu!.position.x, y: highScoresMenu!.frame.maxY - highScoresLabel!.frame.height - 10)
        highScoresLabel!.zPosition = 7
        targetScene!.addChild(highScoresLabel!)
        
        let buttonSize = CGSize(width: menuSize.width * 0.4, height: menuSize.height * 0.1)
        let clearButtonOrigin = CGPoint(x: highScoresMenu!.frame.width * 0.33, y: parentViewBounds!.height * 0.2)
        let okCoolButtonOrigin = CGPoint(x: highScoresMenu!.frame.width * 0.75, y: parentViewBounds!.height * 0.2)
        clearButton = MenuButton(rectOf: buttonSize, cornerRadius: 0.2, origin: clearButtonOrigin, labelText: "Clear Scores")
        okCoolButton = MenuButton(rectOf: buttonSize, cornerRadius: 0.2, origin: okCoolButtonOrigin, labelText: "OK, Cool")
        clearButton!.label?.fontSize = 14
        okCoolButton!.label?.fontSize = 15
        clearButton!.zPosition = 7
        okCoolButton!.zPosition = 7
        clearButton!.name = "clearButton"
        if addScoreFlag {
            okCoolButton!.name = "BackToMainMenu"
        } else {
            okCoolButton!.name = "okCoolButton"
        }
        
        targetScene!.addChild(clearButton!)
        targetScene!.addChild(okCoolButton!)
        
        highScoresLabelArray = []
        
        if let finalScores = highScores {
            for index in finalScores.indices {
                let thisScore = finalScores[index]
                var thisLabelText = "\(thisScore)"
                if thisScore == Int.min {
                    thisLabelText = ""
                }
                let thisLabel = SKLabelNode(text: thisLabelText)
                let thisIndexLabel = SKLabelNode(text: "\(index + 1)")
                thisLabel.color = UIColor.orange
                thisIndexLabel.color = UIColor.orange
                thisIndexLabel.position = CGPoint(x: highScoresMenu!.frame.minX * 1.6, y: (parentViewBounds!.height * 0.75) - CGFloat((index+1) * 25))
                thisLabel.position = CGPoint(x: highScoresMenu!.frame.maxX * 0.7, y: (parentViewBounds!.height * 0.75) - CGFloat((index+1) * 25))
                thisLabel.fontName = "Cochin"
                thisIndexLabel.fontName = "Cochin"
                thisLabel.fontSize = 20
                thisIndexLabel.fontSize = 20
                thisLabel.zPosition = 8
                thisIndexLabel.zPosition = 8
                
                targetScene!.addChild(thisLabel)
                targetScene!.addChild(thisIndexLabel)
                
                highScoresLabelArray!.append(thisLabel)
                highScoresLabelArray!.append(thisIndexLabel)
                
            }
            
            if indexOfAddedScore != nil {
                let addedScore = highScoresLabelArray?[indexOfAddedScore!]
                let glisten = SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.4)
                let makeOrange = SKAction.colorize(with: UIColor.orange, colorBlendFactor: 1.0, duration: 0.4)
                let glistenSeq = SKAction.sequence([glisten,makeOrange])
                addedScore?.run(SKAction.repeatForever(glistenSeq))
            }
        }
    }
    
    func ridSureMenu() {
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
    
    func ridHighScoresMenu() {
        for label in highScoresLabelArray! {
            label.removeFromParent()
        }
        highScoresLabel?.removeFromParent()
        clearButton?.removeFromParent()
        okCoolButton?.removeFromParent()
        highScoresMenu?.removeFromParent()
    }
    
    func clearHighScores() {
        
        let highScores = Array(repeating: Int.min, count: 10)
        UserDefaults.standard.set(highScores, forKey: "highScores")
    }
    
    func ridLevelInfoMenu() {
        
        levelInfoMenu?.removeFromParent()
        levelInfoText?.removeFromParent()
        okCoolButton?.removeFromParent()
    }
}
