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
    var SCALE_MUL: CGFloat?
    var logoNode: SKSpriteNode?
    var playLabel: SKLabelNode?
    var playButton: MenuButton?
    var highScoresLabel: SKLabelNode?
    var highScoresButton: MenuButton?
    var iceCreamChar: IceCream?
    var mouthChar: Mouth?
    var backgroundMusic: SoundNode!
    var settingsNode: SettingsNode?
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        SCALE_MUL = (scene?.view?.bounds.width)! * 0.00018
        
        if let musicURL = Bundle.main.url(forResource: "bgmusicLevel6", withExtension: "mp3") {
            backgroundMusic = SoundNode(url: musicURL)
            addChild(backgroundMusic)
        }
        
        background = SKSpriteNode.init(imageNamed: "bg1.jpg")
        background!.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        background!.position = CGPoint(x: 0.0, y: 0.0)
        background!.zPosition = 0
        addChild(background!)
        
        let logoTexture = SKTexture(imageNamed: "IceCreamLogo")
        logoNode = SKSpriteNode.init(texture: logoTexture)
        logoNode?.zPosition = 2
        logoNode?.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.8)
        logoNode?.setScale(0.01)
        addChild(logoNode!)
        let scaleAct = SKAction.scale(to: 0.3, duration: 0.5)
        logoNode?.run(scaleAct)
        
        
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
        
        settingsNode = SettingsNode(imageNamed: "gear", targetScene: self)
        settingsNode!.alpha = 0
        addChild(settingsNode!)
        
        let buttonSize = CGSize(width: view.bounds.width * 0.4, height: view.bounds.height * 0.10)
        let playButtonOrigin = CGPoint(x: view.bounds.width * 0.05, y: view.bounds.height * 0.15)
        playButton = MenuButton.init(rectOf: buttonSize, cornerRadius: 0.2, origin: playButtonOrigin, labelText: "Play")
        playButton!.name = "playButton"
        playButton!.zPosition = 2
        
        let highScoresButtonOrigin = CGPoint(x: view.bounds.width * 0.55, y: view.bounds.height * 0.15)
        highScoresButton = MenuButton.init(rectOf: buttonSize, cornerRadius: 0.2, origin: highScoresButtonOrigin, labelText: "High Scores")
        highScoresButton!.name = "highScoresButton"
        highScoresButton!.zPosition = 2

        self.addChild(self.playButton!)
        self.addChild(self.highScoresButton!)
        
        iceCreamChar = IceCream(imageNamed: "ice cream")
        iceCreamChar!.zPosition = 4
        iceCreamChar!.setScale(SCALE_MUL! * 8)
        iceCreamChar!.position = CGPoint(x: self.frame.width / 2, y: self.frame.height)
        addChild(iceCreamChar!)
        
        
        mouthChar = Mouth(imageNamed: "mouth1")
        mouthChar!.alpha = 1.0
        mouthChar!.setScale(SCALE_MUL! * 1.8)
        mouthChar!.zPosition = 4
        mouthChar!.position = CGPoint(x: self.frame.width / 2, y: self.frame.height)
        addChild(mouthChar!)
        
        mouthChar!.physicsBody?.collisionBitMask = BodyType.hole.rawValue
        iceCreamChar!.physicsBody?.collisionBitMask = BodyType.hole.rawValue
        
        backgroundChange()
    }
    
    func backgroundChange() {
        
        let listOfPointsAndDurs = makePointsAndDurs(originalPoint: mouthChar!.position)
        var iceCreamMovements: [SKAction] = []
        var mouthMovements: [SKAction] = []
        for i in listOfPointsAndDurs.listOfDurs.indices {
            var thisAction = SKAction.move(to: listOfPointsAndDurs.listOfPoints[i], duration: listOfPointsAndDurs.listOfDurs[i])
            iceCreamMovements.append(thisAction)
            
            if i == 0 {
                thisAction = SKAction.move(to: listOfPointsAndDurs.listOfPoints[i], duration: listOfPointsAndDurs.listOfDurs[i] + 0.3)
            }
            mouthMovements.append(thisAction)
        }
        
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
        for i in 0...10 {
            let randX = CGFloat(Int(arc4random_uniform(UInt32(view!.bounds.width))))
            let randY = CGFloat(Int(arc4random_uniform(UInt32(view!.bounds.height))))
            var thisPoint = CGPoint(x: randX, y: randY)
            
            if i == 10 {
                thisPoint = CGPoint(x: self.frame.width / 2, y: self.frame.height)
            }
            
            let x = abs(previousPoint.x - thisPoint.x)
            let y = abs(previousPoint.y - thisPoint.y)
            
            let distance = Double(sqrt((x * x) + (y * y)))
            let thisDur: TimeInterval = distance * 0.002
            
            listOfPoints.append(thisPoint)
            listOfDurs.append(thisDur)
            
            previousPoint = thisPoint
        }
        print(listOfPoints, listOfDurs)
        return (listOfPoints, listOfDurs)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let location = touch!.location(in: self)
        var touchedNode = self.nodes(at: location).first
        
        if touchedNode is SKLabelNode {
            touchedNode = touchedNode?.parent
        }
        
        if touchedNode! is MenuButton {
            
            touchedNode!.position = CGPoint(x: touchedNode!.position.x, y: touchedNode!.position.y + 2)
            
            switch touchedNode!.name! {
                
            case "playButton":
                mouthCount = 150
                displayedScore = 0
                score = 0
                let transition = SKTransition.crossFade(withDuration: 1)
                let firstLevel = NewLevelMenu(size: scene!.size)
                firstLevel.scaleMode = .resizeFill
                firstLevel.setNewLevel(newLevel: "Level 1")
                self.scene?.view?.presentScene(firstLevel, transition: transition)
                
            case "highScoresButton":
                settingsNode?.bringUpHighScores(position: CGPoint(x: view!.bounds.width / 2, y: view!.bounds.height / 2), addScoreFlag: false)
                
            case "okCoolButton":
                settingsNode?.ridHighScoresMenu()
                
            case "clearButton":
                settingsNode!.bringUpAreYouSureMenu(position: CGPoint(x: view!.bounds.width / 2, y: view!.bounds.height / 2), zPos: 9, clearScoresFlag: true)
                
            case "nahButton":
                settingsNode?.ridSureMenu()
                
            case "yeahButton_CLEAR":
                settingsNode?.clearHighScores()
                settingsNode?.ridSureMenu()
                settingsNode?.ridHighScoresMenu()
                settingsNode?.bringUpHighScores(position: CGPoint(x: view!.bounds.width / 2, y: view!.bounds.height / 2), addScoreFlag: false)
            default:
                break
                
            }
        }
    }
}

