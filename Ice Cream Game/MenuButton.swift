//
//  MenuButton.swift
//  Ice Cream Game
//
//  Created by Luke Morse on 1/25/17.
//  Copyright © 2017 Luke Morse. All rights reserved.
//

import Foundation
import SpriteKit

class MenuButton: SKShapeNode {
    
    var label: SKLabelNode?
    
    init(rectOf: CGSize, cornerRadius: CGFloat, origin: CGPoint, labelText: String) {
        
        super.init()
        
        let rect = CGRect(origin: origin, size: rectOf)
        
        self.path = CGPath(rect: rect, transform: nil)
        
        fillColor = UIColor.orange
        strokeColor = UIColor.red
        glowWidth = 3.0
        alpha = 1.0
        
        label = SKLabelNode.init(fontNamed: "AppleSDGothicNeo-Light")
        label!.text = labelText
        label!.fontSize = 22
        label!.position = CGPoint(x: origin.x + (rect.width / 2), y: origin.y +  (rect.height / 2))
        label!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        label!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        label!.zPosition = self.zPosition + 1
        addChild(label!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
