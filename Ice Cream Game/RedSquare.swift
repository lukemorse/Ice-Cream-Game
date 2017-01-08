//
//  RedSquare.swift
//  Ice Cream Game
//
//  Created by Luke Morse on 8/18/16.
//  Copyright © 2016 Luke Morse. All rights reserved.
//

import Foundation
import SpriteKit

class RedSquare:SKSpriteNode {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(imageNamed: String) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        super.init(texture: imageTexture, color: SKColor.white, size: imageTexture.size())
        
        let body = SKPhysicsBody.init(rectangleOf: imageTexture.size())
        
        body.categoryBitMask = BodyType.redSquare.rawValue
//        body.contactTestBitMask = BodyType.mouth.rawValue
        body.collisionBitMask = BodyType.mouth.rawValue
        
        body.affectedByGravity = false
        body.isDynamic = false
        body.mass = 1000
        
        self.physicsBody = body
        self.name = "redSquare"
        self.isUserInteractionEnabled = false
        self.setScale(0.9)
        self.zPosition = 1
    }
    
}
