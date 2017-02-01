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
        "description" : "Brain freeze, or sphenopalatine ganglioneuralgia, happens when you eat ice cream too fast.  Throw your mouths no faster than 30 MPH!",
        "picture" : "red square"
    ],
    
    "Level 3" : [
        
        "level" : "Level 3",
        "description" : "Glavny Universalny Megazin in Red Square, Moscow has some of the best ice cream available to this specific location.  At least that's what JacquelineRose5 on yelp had to say about it.  These red squares, however, are bouncy!  Bounce your mouths off of it to achieve extra points! Don't get squashed between them though!",
        "picture" : "red square"
    ],
    
    "Level 4" : [
        
        "level" : "Level 4",
        "description" : "Earlier, we learned about brain freeze and the importance of eating ice cream slowly.  However, when the sun comes out, we have to make sure to eat all of our ice cream before it melts.  Throw your mouths no slower than 65 MPH!",
        "picture" : "spike"
    ],
    
    "Level 5" : [
        
        "level" : "Level 5",
        "description" : "For obvious reasons, you should never run, mouth-first, into spikes.  Especially in this case, because they will get in the way of earning you points.",
        "picture" : "spike"
    ],
    
    "Level 6" : [
        
        "level" : "Level 6",
        "description" : "While ice cream is a great source of calcium, protein, and vitamin D, what a lot of people don't know is that it also contains a decent amount of sugar.  Every once in a while, we have to take a break from ice cream and brush our teeth. So let's do that in this final level.",
        "picture" : "toothbrush"
    ],
    
]

var mouthCount: Int?
var score = 50
var displayedScore = 0
