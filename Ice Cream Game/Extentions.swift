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
