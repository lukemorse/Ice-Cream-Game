//
//  Constants.swift
//  Ice Cream Game
//
//  Created by Luke Morse on 9/13/16.
//  Copyright © 2016 Luke Morse. All rights reserved.
//

import Foundation

let fancySayings = [
    "Dude, so fancy!",
    "You're the fanciest!",
    "That was really fancy, not gonna lie.",
    "How did you learn to be so fancy?",
    "Megafancy",
    "Whoa, that was a sick mouth toss!",
    "Yeah, fancy!",
]

enum BodyType:UInt32 {
    case iceCream = 1
    case mouth = 2
    case redSquare = 4
    case spike = 8
    case hole = 16
    case toothbrush = 32
}


let levelMenuData = [
    
    "Level 1" : [
        
        "level" : "Level 1",
        "description" : "Throw your mouth at the ice cream to eat it and collect points!",
        "picture" : "ice cream"
    ],
    
    "Level 2" : [
        
        "level" : "Level 2",
        "description" : "Bounce your mouths off of it to achieve extra style points!",
        "picture" : "red square"
    ],
    
    "Level 3" : [
        
        "level" : "Level 3",
        "description" : "Don't hit the spikes with your mouth!",
        "picture" : "spike"
    ],
    
    "Level 4" : [
        
        "level" : "Level 4",
        "description" : "Now, avoid the ice cream and collect the toothbrushes!",
        "picture" : "spike"
    ],
    
]

var score = 0
var displayedScore = 0
