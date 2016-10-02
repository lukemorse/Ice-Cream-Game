//
//  Spike.swift
//  Ice Cream Game
//
//  Created by Luke Morse on 8/26/16.
//  Copyright © 2016 Luke Morse. All rights reserved.
//

import Foundation
import SpriteKit

class Spike:SKSpriteNode {
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(imageNamed: String) {
        
        let imageTexture = SKTexture(imageNamed: imageNamed)
        super.init(texture: imageTexture, color: SKColor.white, size: imageTexture.size())
        let bodyWidth = imageTexture.size().width * 0.7
        let bodyHeight = imageTexture.size().height * 0.7
        let bodySize = CGSize.init(width: bodyWidth, height: bodyHeight)
        let body = SKPhysicsBody(rectangleOf: bodySize)
        
        body.categoryBitMask = BodyType.spike.rawValue
        body.contactTestBitMask = BodyType.mouth.rawValue
        
        body.affectedByGravity = false
        body.isDynamic = false
        
        self.physicsBody = body
        self.name = "spike"
        self.isUserInteractionEnabled = false
        self.setScale(0.5)
    }
    
}
