//
//  HighScores.swift
//  Ice Cream Game
//
//  Created by Luke Morse on 1/9/17.
//  Copyright © 2017 Luke Morse. All rights reserved.
//

import Foundation
import SpriteKit

class HighScores: SKScene, UITextFieldDelegate {
    
    var titleLabel: SKLabelNode?
    var playButton: SKSpriteNode?
    var okCoolLabel: SKLabelNode?
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.backgroundColor = SKColor.blue
        
        self.playButton = SKSpriteNode(color: SKColor.green, size: CGSize(width: 200, height: 44))
        self.playButton!.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.15)
        
        self.okCoolLabel = SKLabelNode(text: "OK, cool")
        okCoolLabel!.fontSize = 25
        okCoolLabel!.fontName = "Futura-CondensedMedium"
        okCoolLabel!.position = playButton!.position
       
        self.titleLabel = SKLabelNode(text: "HIGH SCORES:")
        titleLabel!.fontName = "Arial"
        titleLabel!.color = UIColor.black
        titleLabel!.fontSize = 40
        titleLabel!.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height * 0.9)
        
        self.addChild(self.playButton!)
        self.addChild(self.titleLabel!)
        self.addChild(self.okCoolLabel!)
        
        retrieveScores()
    }
    
    func retrieveScores() {
        
        var highScores: [Int]?
        
        if var prevHighScores = UserDefaults.standard.array(forKey: "highScores") as? [Int] {

            print("there were previous high scores")
            print(prevHighScores)
            
            if displayedScore >= prevHighScores.last! {
                
                prevHighScores.insert(displayedScore, at: 0)
                prevHighScores.removeLast()
                highScores = prevHighScores.sorted().reversed()
                UserDefaults.standard.set(highScores, forKey: "highScores")
            } else {
                highScores = prevHighScores
            }
        
        } else {
            
            print("there were NOT previous high scores")
            
            var highScores = Array(repeating: Int(0), count: 10)
            highScores[0] = displayedScore
            UserDefaults.standard.set(highScores, forKey: "highScores")
        }
        
        if let finalScores = highScores {
            for index in finalScores.indices {
                
                let thisLabel = SKLabelNode(text: String(describing: finalScores[index]))
                thisLabel.color = UIColor.orange
                thisLabel.position = CGPoint(x: 100, y: (view!.bounds.height * 0.75) -
                    CGFloat((index+1) * 25))
                thisLabel.fontName = "Cochin"
                thisLabel.fontSize = 20
                
                addChild(thisLabel)
            }
        }
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
            self.playButton!.position = CGPoint(x: playButton!.position.x, y: playButton!.position.y - 1)
            
            let transition = SKTransition.crossFade(withDuration: 1)
            let mainMenu = MainMenu(size: (scene!.size))
            mainMenu.scaleMode = .aspectFill
            
            self.scene?.view?.presentScene(mainMenu, transition: transition)
        }
    }
}



