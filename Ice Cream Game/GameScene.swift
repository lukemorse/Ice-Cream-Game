//
//  GameScene.swift
//  Ice Cream Game
//
//  Created by Luke Morse on 9/24/16.
//  Copyright © 2016 Luke Morse. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = 29
    var scoreLabel: SKLabelNode?
    var fancyCongratsLabel: SKLabelNode?
    var fancy = false
    
    var touchPoint: CGPoint = CGPoint()
    var touching: Bool = false
    var mouthIsReady: Bool = false
    
    var mouth: Mouth?
    var iceCream: IceCream?
    var redSquare: RedSquare?
    var redSquare2: RedSquare?
    var head: SKSpriteNode?
    var spikes = [Spike?](repeating: nil, count: 4)
    
    var toothbrush1: Toothbrush?
    var toothbrush2: Toothbrush?
    var toothbrush3: Toothbrush?
    
    var mouthMovingAnimation: SKAction?
    let tapRecognizer = UITapGestureRecognizer()
    
    var backgroundMusic: SKAudioNode!
    var highHatSound: SKAudioNode!
    var coinSound: SKAudioNode!
    var teethSound: SKAudioNode!
    var bounceSound: SKAudioNode!
    //    var thereAreNoMouths = true
    
    override func didMove(to view: SKView) {
        
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        self.backgroundColor = SKColor.black
        physicsWorld.contactDelegate = self
        
        setUpAnimation()
        
        createHead()
        
        fadeInMouth()
        
        createIceCream()
        
        makeScoreLabel()
        
//        swellIceCream()
        
        if let musicURL = Bundle.main.url(forResource: "background", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
        
        //        tapRecognizer.addTarget(self, action:#selector(GameScene.shootMouth(_:)))
        self.view!.addGestureRecognizer(tapRecognizer)
    }
    
    
    //    func initPhysics() {
    //        physicsWorld.contactDelegate = self
    ////        self.physicsWorld.gravity = CGVector.zero
    //
    //    }
    
    func createHead() {
        
        head = SKSpriteNode(imageNamed: "head")
        head!.physicsBody?.affectedByGravity = false
        head!.position = CGPoint(x: view!.bounds.width / 2, y: 50)
        head!.setScale(0.11)
        
        addChild(head!)
    }
    
    func fadeInMouth() {
        
        mouthIsReady = false
        
        mouth = Mouth(imageNamed: "mouth1")
        mouth!.position = CGPoint(x: self.view!.bounds.width / 2, y: 50)
        mouth!.alpha = 0.0
        
        addChild(mouth!)
        
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.5)
        let readyMouth = SKAction.run {self.mouthIsReady = true}
        let seq = SKAction.sequence([fadeIn, readyMouth, mouthMovingAnimation!])
        
        mouth!.run(seq)
    }
    
    func createIceCream() {
        
        iceCream = IceCream(imageNamed: "ice cream")
        
        //        let RandW = CGFloat(Int(arc4random_uniform(UInt32(self.view!.bounds.width))))
        //        let RandH = CGFloat(Int(arc4random_uniform(UInt32(self.view!.bounds.height))))
        //        let initPos = CGPointMake(RandW,RandH)
        let initX = CGFloat(-iceCream!.size.width)
        let initY = CGFloat(view!.bounds.height + iceCream!.size.height)
        let initPos = CGPoint(x: initX,y: initY)
        
        iceCream!.position = initPos
        addChild(iceCream!)
        
        moveIceCream(initPos)
    }
    
    func createStationaryIceCream() {
    
        iceCream = IceCream(imageNamed: "ice cream")
        
        iceCream!.position = CGPoint(x: view!.bounds.width / 2, y: view!.bounds.height / 2)
        
        addChild(iceCream!)
    }
    
    func moveIceCream(_ initPos:CGPoint) {
        
        var randomPoints = generateFourRandomPoints()
        randomPoints.insert(initPos, at: 0)
        
        let times = generateTimes(randomPoints)
        
        let point2 = randomPoints[1], point3 = randomPoints[2], point4 = randomPoints[3], point5 = randomPoints[4]
        
        let time1 = times[0], time2 = times[1], time3 = times[2], time4 = times[3], time5 = times[4]
        
        let move1 = SKAction.move(to: point2, duration: TimeInterval(time1))
        let move2 = SKAction.move(to: point3, duration: TimeInterval(time2))
        let move3 = SKAction.move(to: point4, duration: TimeInterval(time3))
        let move4 = SKAction.move(to: point5, duration: TimeInterval(time4))
        let move5 = SKAction.move(to: point2, duration: TimeInterval(time5))
        
        let seq = SKAction.sequence([move2, move3, move4, move5])
        let repeatAction = SKAction.repeatForever(seq)
        iceCream!.run(SKAction.sequence([move1,repeatAction]))
    }
    
    func swellIceCream() {
        
        let swellUp = SKAction.scale(to: 0.3, duration: 0.5)
        let swellDown = SKAction.scale(to: 0.06, duration: 0.5)
        let seq = SKAction.sequence([swellUp,swellDown])
        let swellAct = SKAction.repeatForever(seq)
        
        iceCream?.run(swellAct)
    }
    
    func generateTimes(_ points: [CGPoint]) -> [Float] {
        
        let xDiff1 = abs(points[1].x - points[0].x)
        let yDiff1 = abs(points[1].y - points[0].y)
        let time1 = Float(sqrt(pow(xDiff1, 2) + pow(yDiff1, 2)) / 200)
        
        let xDiff2 = abs(points[2].x - points[1].x)
        let yDiff2 = abs(points[2].y - points[1].y)
        let time2 = Float(sqrt(pow(xDiff2, 2) + pow(yDiff2, 2)) / 200)
        
        let xDiff3 = abs(points[3].x - points[2].x)
        let yDiff3 = abs(points[3].y - points[2].y)
        let time3 = Float(sqrt(pow(xDiff3, 2) + pow(yDiff3, 2)) / 200)
        
        let xDiff4 = abs(points[4].x - points[3].x)
        let yDiff4 = abs(points[4].y - points[3].y)
        let time4 = Float(sqrt(pow(xDiff4, 2) + pow(yDiff4, 2)) / 200)
        
        let xDiff5 = abs(points[1].x - points[4].x)
        let yDiff5 = abs(points[1].y - points[4].y)
        let time5 = Float(sqrt(pow(xDiff5, 2) + pow(yDiff5, 2)) / 200)
        
        return [time1, time2, time3, time4, time5]
        
    }
    
    
    func generateFourRandomPoints() -> [CGPoint] {
        
        //        keep ice cream in the top half by selecting a random point in the bottom half and then adding half of the screens height to it.
        let widthMax = self.view!.bounds.width - 10
        let heightMax = self.view!.bounds.height / 2
        //        let offset = heightMax - iceCream!.size.height / 2
        //        let offset = CGFloat(10)
        
        let RandW1 = CGFloat(Int(arc4random_uniform(UInt32(15)))) + CGFloat(5)
        let RandH1 = CGFloat(Int(arc4random_uniform(UInt32(heightMax)))) + CGFloat(heightMax)
        //        let RandH1 = CGFloat(Int(arc4random_uniform(UInt32(heightMax))))
        let point1 = CGPoint(x: RandW1, y: RandH1)
        
        let RandW2 = CGFloat(Int(UInt32(widthMax) - arc4random_uniform(UInt32(15)))) + CGFloat(5)
        let RandH2 = CGFloat(Int(arc4random_uniform(UInt32(heightMax)))) + CGFloat(heightMax)
        let point2 = CGPoint(x: RandW2, y: RandH2)
        
        let RandW3 = CGFloat(Int(arc4random_uniform(UInt32(15)))) + CGFloat(5)
        let RandH3 = CGFloat(Int(arc4random_uniform(UInt32(heightMax)))) + CGFloat(heightMax)
        let point3 = CGPoint(x: RandW3, y: RandH3)
        
        let RandW4 = CGFloat(Int(UInt32(widthMax) - arc4random_uniform(UInt32(15)))) + CGFloat(5)
        let RandH4 = CGFloat(Int(arc4random_uniform(UInt32(heightMax)))) + CGFloat(heightMax)
        let point4 = CGPoint(x: RandW4, y: RandH4)
        
        return [point1, point2, point3, point4]
    }
    
    
    func setUpAnimation() {
        
        let atlas = SKTextureAtlas (named: "mouth")
        
        var array = [String]()
        
        for i in 1 ... 7 {
            
            let nameString = String(format: "mouth%i", i)
            array.append(nameString)
            
        }
        
        //create another array this time with SKTexture as the type (textures being the .png images)
        var atlasTextures:[SKTexture] = []
        
        for i in 0 ..< array.count {
            
            let texture:SKTexture = atlas.textureNamed( array[i] )
            atlasTextures.insert(texture, at:i)
            
        }
        
        let atlasAnimation = SKAction.animate(with: atlasTextures, timePerFrame: 1.0/30, resize: false , restore:false )
        
        mouthMovingAnimation =  SKAction.repeatForever(atlasAnimation)
        
    }
    
    
    
    func shootMouth() {
        
        if let soundURL = Bundle.main.url(forResource: "highHatRoll", withExtension: "mp3") {
            highHatSound = SKAudioNode(url: soundURL)
            addChild(highHatSound)
            removeSound(highHatSound, waitTime: 1.0)
        }
        
        let wait = SKAction.wait(forDuration: 2.5)
        let killMouth = SKAction.run {
            self.popMouth(self.mouth!.position)
        }
        let fadeBackIn = SKAction.run { self.fadeInMouth()}
        let seq = SKAction.sequence([wait,killMouth,fadeBackIn])
        self.run(seq)
    }
    
    func popMouth(_ position: CGPoint) {
        
        if self.childNode(withName: "mouth") != nil {
            if let pop = SKEmitterNode(fileNamed: "Explosion.sks") {
                addChild(pop)
                pop.position = position
            }
            self.mouth!.removeAllActions()
            self.mouth!.removeFromParent()
            fancy = false
        }
        
    }
    
    func removeSound(_ sound:SKAudioNode, waitTime: TimeInterval) -> () {
        
        let removeSound = SKAction.run {sound.removeFromParent()}
        let wait = SKAction.wait(forDuration: waitTime)
        run(SKAction.sequence([wait,removeSound]))
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch!.location(in: self)
        if mouth!.frame.contains(location) && mouthIsReady {
            touchPoint = location
            touching = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch!.location(in: self)
        touchPoint = location
        //        mouth?.position = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if touching {shootMouth()}
        
        touching = false
    }
    
    func convertToRange(_ vector:CGVector) -> CGVector {
        
        let returnX = (vector.dx / 3000) * 500
        let returnY = (vector.dy / 3000) * 500
        
        return CGVector(dx: returnX, dy: returnY)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        //        *********  MOUTH HITS ICE CREAM  *********
        
        if (contact.bodyA.categoryBitMask == BodyType.iceCream.rawValue) &&
            (contact.bodyB.categoryBitMask == BodyType.mouth.rawValue) ||
            (contact.bodyA.categoryBitMask == BodyType.mouth.rawValue) &&
            (contact.bodyB.categoryBitMask == BodyType.iceCream.rawValue){
            
            let contactPoint = contact.contactPoint
            
            score += 1
            scoreLabel!.text = "SCORE: \(score)"
            
            if fancy {
                
                let fancyIdx = Int(arc4random_uniform(UInt32(fancySayings.count - 1)))
                let fancyLabel = SKLabelNode.init(text: fancySayings[fancyIdx])
                fancyLabel.zPosition = 1.0
                fancyLabel.color = SKColor.red
                fancyLabel.fontSize = 20
                fancyLabel.horizontalAlignmentMode = .center
                fancyLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
                addChild(fancyLabel)
                
                let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 2.0)
                let ridLabel = SKAction.run({fancyLabel.removeFromParent()})
                let seq = SKAction.sequence([fadeOut,ridLabel])
                fancyLabel.run(seq)
                
            }
            
            // EXPLOSION //
            
            if let explosion1 = SKEmitterNode(fileNamed: "Explosion.sks"),
                let explosion2 = SKEmitterNode(fileNamed: "Explosion.sks"),
                let explosion3 = SKEmitterNode(fileNamed: "Explosion.sks") {
                
                let greenSprinkleBundlePath = Bundle.main.path(forResource: "greenSprinkle", ofType: "png")
                let yellowSprinkleBundlePath = Bundle.main.path(forResource: "yellowSprinkle", ofType: "png")
                
                let greenSprinkle = UIImage(contentsOfFile: greenSprinkleBundlePath!)
                let yellowSprinkle = UIImage(contentsOfFile: yellowSprinkleBundlePath!)
                
                explosion2.particleTexture = SKTexture.init(image: greenSprinkle!)
                explosion3.particleTexture = SKTexture.init(image: yellowSprinkle!)
                
                explosion1.position = contactPoint
                explosion2.position = contactPoint
                explosion3.position = contactPoint
                
                iceCream!.removeAllActions()
                iceCream!.removeFromParent()
                
                mouth!.removeAllActions()
                mouth!.removeFromParent()
                fancy = false
                //                fadeInMouth()
                removeSound(highHatSound, waitTime: 0.0)
                
                if let soundURL = Bundle.main.url(forResource: "coin", withExtension: "mp3") {
                    coinSound = SKAudioNode(url: soundURL)
                    addChild(coinSound)
                    removeSound(coinSound, waitTime: 1)
                }
                
                self.addChild(explosion1)
                self.addChild(explosion2)
                self.addChild(explosion3)
                
                let removeExplotion = SKAction.run({
                    explosion1.removeFromParent()
                    explosion2.removeFromParent()
                    explosion3.removeFromParent()
                })
                
                let wait = SKAction.wait(forDuration: 1)
                
                
                explosion1.run(SKAction.sequence([wait, removeExplotion]))
                explosion2.run(SKAction.sequence([wait, removeExplotion]))
                explosion3.run(SKAction.sequence([wait, removeExplotion]))
                
//                **************************************************
//            **** SWITCHING ON SCORE TO DESIGNATE LEVELS, KINDA *****
//                **************************************************
                
                switch score {
                    
                    case 10:
                        
                        redSquare = RedSquare(imageNamed: "red square")
                        redSquare2 = RedSquare(imageNamed: "red square")
                        let createFirstSquare = SKAction.run({ self.createRedSquare(self.redSquare!)})
                        let createSecondSquare = SKAction.run({ self.createRedSquare(self.redSquare2!)})
                        let wait = SKAction.wait(forDuration: 3.0)
                        let seq = SKAction.sequence([createFirstSquare,wait,createSecondSquare])
                        self.run(seq)
                        self.createIceCream()
                    
                    case 20:
                    
                        
                        redSquare?.removeAllActions()
                        redSquare?.removeFromParent()
                        redSquare2?.removeAllActions()
                        redSquare2?.removeFromParent()
                        
                        for i in 0...spikes.count - 1 {
                            var thisSpike = spikes[i]
                            thisSpike = Spike(imageNamed: "spike")
                            createSpike(thisSpike!, position: CGPoint(x: CGFloat(i * 80) + 18 + (thisSpike!.size.width / 2), y: 500 ))
                        }
                        
                        self.createIceCream()
                    
                    case 30:
                        
                        self.createStationaryIceCream()
                        swellIceCream()
                    
                        for i in 0...spikes.count - 1 {
                            let thisSpike = spikes[i]
                            thisSpike?.removeFromParent()
                        }
                        
                        toothbrush1 = Toothbrush(imageNamed: "toothbrush")
                        toothbrush2 = Toothbrush(imageNamed: "toothbrush")
                        toothbrush3 = Toothbrush(imageNamed: "toothbrush")
                        
                        let createBrush1 = SKAction.run({self.createToothbrush(brush: self.toothbrush1!)})
                        let createBrush2 = SKAction.run({self.createToothbrush(brush: self.toothbrush2!)})
                        let createBrush3 = SKAction.run({self.createToothbrush(brush: self.toothbrush3!)})
                        
                        let waitBetweenBrushes = SKAction.wait(forDuration: 0.4)
                        let sequence = SKAction.sequence([createBrush1,waitBetweenBrushes,createBrush2,waitBetweenBrushes,createBrush3,waitBetweenBrushes])
                        
                        run(SKAction.repeatForever(sequence))
                    
                    case 31...40:
                    
                        self.createStationaryIceCream()
                        swellIceCream()
                    
                    default:
                        
                        self.createIceCream()
                }
                
            }
            
            //  END EXPLOSION //
            
        }
            
            //        *********  MOUTH HITS SPIKE  *********
            
        else if (contact.bodyA.categoryBitMask == BodyType.mouth.rawValue) &&
            (contact.bodyB.categoryBitMask == BodyType.spike.rawValue) ||
            (contact.bodyA.categoryBitMask == BodyType.spike.rawValue) &&
            (contact.bodyB.categoryBitMask == BodyType.mouth.rawValue) {
            
            let contactPoint = contact.contactPoint
            
            if let toothExplosion = SKEmitterNode(fileNamed: "ToothExplosion") {
                toothExplosion.particleColor = SKColor.white
                //                toothExplosion.particleColorBlendFactor = 1.0;
                toothExplosion.particleColorSequence = nil;
                toothExplosion.position = contactPoint
                addChild(toothExplosion)
            }
            
            if let soundURL = Bundle.main.url(forResource: "teeth2", withExtension: "mp3") {
                teethSound = SKAudioNode(url: soundURL)
                addChild(teethSound)
                removeSound(teethSound, waitTime: 2)
            }
            
            mouth!.removeAllActions()
            mouth!.removeFromParent()
            fancy = false
        }
            
            //        *********  MOUTH HITS RED SQUARE  *********
            
        else if (contact.bodyA.categoryBitMask == BodyType.mouth.rawValue) &&
            (contact.bodyB.categoryBitMask == BodyType.redSquare.rawValue) ||
            (contact.bodyA.categoryBitMask == BodyType.redSquare.rawValue) &&
            (contact.bodyB.categoryBitMask == BodyType.mouth.rawValue) {
            
            fancy = true
            
            if let soundURL = Bundle.main.url(forResource: "bounce", withExtension: "mp3") {
                bounceSound = SKAudioNode(url: soundURL)
                addChild(bounceSound)
                removeSound(bounceSound, waitTime: 1.5)
            }
            
            let bodies = contact.bodyA.node?.physicsBody?.allContactedBodies()
            if (bodies?.count)! > 1 {
                popMouth((contact.bodyA.node?.position)!)
            }
        }
        
            //        *********  MOUTH HITS TOOTHBRUSH  *********
            
        else if (contact.bodyA.categoryBitMask == BodyType.mouth.rawValue) &&
            (contact.bodyB.categoryBitMask == BodyType.toothbrush.rawValue) ||
            (contact.bodyA.categoryBitMask == BodyType.toothbrush.rawValue) &&
            (contact.bodyB.categoryBitMask == BodyType.mouth.rawValue) {
            
            if contact.bodyA.node?.name == "toothbrush" {
                let brush = contact.bodyA.node
                brush?.removeFromParent()
            }
            
            else if contact.bodyB.node?.name == "toothbrush" {
                let brush = contact.bodyB.node
                brush?.removeFromParent()
            }
            
            
        }
        
        
        //        *********  END COLLISION STATEMENTS  *********
        
    }
    
    func createRedSquare(_ square:RedSquare) {
        
        //        redSquare = RedSquare(imageNamed: "red square")
        
        addChild(square)
        //        let leftPosition = CGPoint(x: (redSquare?.size.width)! / 2, y: size.height / 2)
        let leftPosition = CGPoint(x: 0, y: size.height / 2)
        //        let rightPosition = CGPoint(x: size.width - (redSquare?.size.width)! / 2, y: size.height / 2)
        let rightPosition = CGPoint(x: size.width, y: size.height / 2)
        square.position = leftPosition
        
        let moveRight = SKAction.move(to: rightPosition, duration: 2.0)
        let moveLeft = SKAction.move(to: leftPosition, duration: 3.0)
        let seq = SKAction.sequence([moveRight,moveLeft])
        
        square.run(SKAction.repeatForever(seq))
    }
    
    func createSpike(_ aSpike:Spike, position: CGPoint) {
        
        aSpike.position = position
        addChild(aSpike)
    }
    
    func createToothbrush(brush: Toothbrush) {
        
        //        switch brush {
        //
        //        case toothbrush1!:
        //            toothbrush1 = Toothbrush(imageNamed: "toothbrush")
        //
        //        case toothbrush2!:
        //            toothbrush2 = Toothbrush(imageNamed: "toothbrush")
        //
        //        case toothbrush3!:
        //            toothbrush3 = Toothbrush(imageNamed: "toothbrush")
        //
        //        default:
        //            print("no brush chosen")
        //
        //        }
        
        addChild(brush)
        
        let initRandomY = arc4random_uniform(UInt32(size.height))
        let finalRandomY = arc4random_uniform(UInt32(size.height))
        
        let leftPosition = CGPoint(x: -20, y: CGFloat(initRandomY))
        let rightPosition = CGPoint(x: size.width + 20, y: CGFloat(finalRandomY))
        
        //        let velocity = CGVector(dx: 200, dy: 0)
        //        toothbrush!.physicsBody!.velocity = velocity
        
        brush.position = leftPosition
        
        let moveBrush = SKAction.move(to: rightPosition, duration: 1)
        let rotate = SKAction.rotate(byAngle: CGFloat(M_PI * 2), duration: 2.0)
        let removeBrush = SKAction.run{
            brush.removeAllActions()
            brush.removeFromParent()
        }
        let seq = SKAction.sequence([moveBrush,removeBrush])
        
        brush.run(SKAction.repeatForever(rotate))
        brush.run(seq)
    }
    
    func winLabel() {
        
        let label = SKLabelNode.init(text: "YOU WIN!")
        label.color = SKColor.red
        label.horizontalAlignmentMode = .center
        label.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(label)
    }
    
    func makeScoreLabel() {
        
        scoreLabel = SKLabelNode.init(text: "SCORE: \(score)")
        scoreLabel!.color = SKColor.white
        scoreLabel!.horizontalAlignmentMode = .left
        scoreLabel!.position = CGPoint(x: 0, y: size.height - 20)
        scoreLabel!.fontSize = 20
        addChild(scoreLabel!)
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        if touching {
            let dt:CGFloat = 1.0/60.0
            let distance = CGVector(dx: touchPoint.x-mouth!.position.x, dy: touchPoint.y-mouth!.position.y)
            let velocity = CGVector(dx: distance.dx/dt * 0.5, dy: distance.dy/dt * 0.5)
            let convVel = convertToRange(velocity)
            mouth!.physicsBody!.velocity = convVel
        }
    }
    
}
