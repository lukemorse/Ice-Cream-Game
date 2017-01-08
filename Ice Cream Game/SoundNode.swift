//
//  SoundNode.swift
//  Ice Cream Game
//
//  Created by Luke Morse on 12/7/16.
//  Copyright © 2016 Luke Morse. All rights reserved.
//

import Foundation
import SpriteKit

class SoundNode : SKAudioNode {
    var volume : Float = 0
        {
        didSet
        {
            run(SKAction.changeVolume(to: volume, duration: 0))
        }
    }
}
