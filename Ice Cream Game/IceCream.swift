//
//  IceCream.swift
//  Ice Cream Game
//
//  Created by Luke Morse on 8/18/16.
//  Copyright © 2016 Luke Morse. All rights reserved.
//

import Foundation
import SpriteKit

class IceCream: SKSpriteNode {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(imageNamed: String) {
        let imageTexture = SKTexture(imageNamed: imageNamed)
        super.init(texture: imageTexture, color: SKColor.white, size: imageTexture.size())
        
//        let body = SKPhysicsBody.init(rectangleOf: imageTexture.size())
        let body = SKPhysicsBody(texture: imageTexture, size: imageTexture.size())
        body.categoryBitMask = BodyType.iceCream.rawValue
        body.contactTestBitMask = BodyType.mouth.rawValue
        body.isDynamic = false
        body.affectedByGravity = false
        
        self.physicsBody = body
        self.name = "iceCream"
        self.isUserInteractionEnabled = false
//        self.setScale(0.45)
        self.zPosition = 1
        
    }
    
    
}
