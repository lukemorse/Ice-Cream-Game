//
//  Mouth.swift
//  Ice Cream Game
//
//  Created by Luke Morse on 8/18/16.
//  Copyright © 2016 Luke Morse. All rights reserved.
//

import Foundation
import SpriteKit

protocol SpriteOffScreenDelegate {
    func spriteOffScrene()
}

class Mouth:SKSpriteNode {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(imageNamed: String) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        super.init(texture: imageTexture, color: SKColor.white, size: imageTexture.size())
        
        zPosition = 2
        
        let body = SKPhysicsBody.init(rectangleOf: imageTexture.size())
        body.categoryBitMask = BodyType.mouth.rawValue
        body.contactTestBitMask = BodyType.iceCream.rawValue | BodyType.redSquare.rawValue | BodyType.spike.rawValue
        body.collisionBitMask = BodyType.redSquare.rawValue | BodyType.iceCream.rawValue
        body.affectedByGravity = false
        body.restitution = 1.0
        
        self.physicsBody = body
        self.name = "mouth"
        self.isUserInteractionEnabled = false
//        self.setScale(0.11)
        self.alpha = 0.0
    }
    
}
