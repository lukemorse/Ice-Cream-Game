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

let levelDict: Dictionary<Int, Int> =
    [1: 0, 2: 10, 3: 20, 4: 30, 5: 40, 6: 50, 7:60, 8: 70, 9: 80, 10: 90, 11: 100]
