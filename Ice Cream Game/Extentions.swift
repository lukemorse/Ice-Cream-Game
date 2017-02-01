//
//  Extentions.swift
//  Ice Cream Game
//
//  Created by Luke Morse on 12/7/16.
//  Copyright © 2016 Luke Morse. All rights reserved.
//

import Foundation
import SpriteKit

extension SKAction
{
    // All the change... actions for SKAudioNode are broken. They do not work with looped audio. These are replacements
    
    public class func _changeVolumeTo(endVolume: Float, duration: TimeInterval) -> SKAction
    {
        var startVolume : Float!
        var distance : Float!
        
        let action = SKAction.customAction(withDuration: duration)
        {
            node, elapsedTime in
            
            if let soundNode = node as? SoundNode
            {
                if startVolume == nil
                {
                    startVolume = soundNode.volume
                    distance = endVolume - startVolume
                }
                
                let fraction = Float(elapsedTime / CGFloat(duration))
                let newVolume = startVolume + (distance * fraction)
                
                soundNode.volume = newVolume
            }
        }
        
        return action
    }
}


extension CGFloat {
    
    public func clamped(_ v1: CGFloat, _ v2: CGFloat) -> CGFloat {
        let min = v1 < v2 ? v1 : v2
        let max = v1 > v2 ? v1 : v2
        return self < min ? min : (self > max ? max : self)
    }
    
    public mutating func clamp(_ v1: CGFloat, _ v2: CGFloat) -> CGFloat {
        self = clamped(v1, v2)
        return self
    }
        
}

extension CGPoint {
    
    public func clamped(rect: CGRect, x: CGFloat, y: CGFloat) -> CGPoint {
        var newX = x
        var newY = y
        if x > rect.maxX {newX = rect.maxX}
        if x < rect.minX {newX = rect.minX}
        if y > rect.maxY {newY = rect.maxY}
        if y < rect.minY {newY = rect.minY}
        return CGPoint(x: newX, y: newY)
//        return self
    }
}
