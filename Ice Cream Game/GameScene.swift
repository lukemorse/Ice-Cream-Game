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
    
    var worldNode: SKNode?
    var scoreLabel: SKLabelNode?
    var fancy = false
    var settingsAreUp = false
    var mouthSpeed: Int = 0
    
    var touchPoint: CGPoint = CGPoint()
    var touching: Bool = false
    var mouthIsReady: Bool = false
    
    var background: SKSpriteNode?
    var mouth: Mouth?
    var mouthSpot: SKSpriteNode?
    var arc: SKShapeNode?
    var iceCream: IceCream?
    var redSquare: RedSquare?
    var redSquare2: RedSquare?
    var head: SKSpriteNode?
    var spikes = [Spike?](repeating: nil, count: 4)
    var gearIcon: SKSpriteNode?
    
    var toothbrush1: Toothbrush?
    var toothbrush2: Toothbrush?
    var toothbrush3: Toothbrush?
    
    var mouthMovingAnimation: SKAction?
//    let tapRecognizer = UITapGestureRecognizer()
    
    var backgroundMusic: SoundNode!
    var teethChatterSound: SoundNode!
    var coinSound: SoundNode!
    var teethSound: SoundNode!
    var badIceCreamSound: SoundNode!
    var brushSound: SoundNode!
    var bg1: SKSpriteNode?
    var bg2: SKSpriteNode?
    let bounceSounds = ["bounce1","bounce2","bounce3","bounce4","bounce5",]
    let pluckSounds = ["pluck1","pluck2","pluck3","pluck4","pluck5","pluck6"]
    
    var settingsMenu: SKShapeNode?
    var areYouSureMenu: SKShapeNode?
    var menuButtons: [MenuButton]?
    var nahButton: MenuButton?
    var yeahButton: MenuButton?
    var sureLabel: SKLabelNode?
    
    var iceCreamGood = true
    var mouthHitIceCreamRegistered = false
    
    var squareRate = 1.0
    var moveBadIceCreamRate = 1.0
    
    override func didMove(to view: SKView) {
        
        worldNode = SKNode.init()
        addChild(worldNode!)
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        
//        bg1 = SKSpriteNode.init(imageNamed: "bg1.jpg")
        bg1 = SKSpriteNode.init(imageNamed: "shine_on_and_on.jpg")
        bg1!.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        bg1!.position = CGPoint(x: 0.0, y: 0.0)
        bg1!.zPosition = 0
        bg1!.setScale(0.2)
        worldNode!.addChild(bg1!)
        
//        bg2 = SKSpriteNode.init(imageNamed: "bg1.jpg")
        bg2 = SKSpriteNode.init(imageNamed: "shine_on_and_on.jpg")
        bg2!.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        bg2!.position = CGPoint(x: bg1!.size.width - 1, y: 0);
        bg2!.zPosition = 0
        bg2!.setScale(0.2)
        worldNode!.addChild(bg2!)
        
        gearIcon = SKSpriteNode.init(imageNamed: "gear")
        gearIcon!.setScale(0.05)
        gearIcon!.position = CGPoint(x: view.bounds.width - (gearIcon!.size.width / 2), y: view.bounds.height - (gearIcon!.size.height / 2))
//        gearIcon!.position = CGPoint(x: self.view!.bounds.width / 2, y: )
        gearIcon!.zPosition = 1
        worldNode!.addChild(gearIcon!)
        
        physicsWorld.contactDelegate = self
        
        setUpAnimation()
        createHead()
        fadeInMouth()
        makeScoreLabel()
        createArc()
        
        mouthSpot = SKSpriteNode(imageNamed: "mouth1")
        mouthSpot!.setScale(0.22)
        mouthSpot!.position = CGPoint(x: self.view!.bounds.width / 2, y: 50)
        mouthSpot!.alpha = 0.0
        worldNode!.addChild(mouthSpot!)
        
        if score != 30 && score != 50 {
            createIceCream()
        }
        
        switch score {
            
        case 0...9:
            if let musicURL = Bundle.main.url(forResource: "bgmusicLevel1", withExtension: "mp3") {
                backgroundMusic = SoundNode(url: musicURL)
                worldNode!.addChild(backgroundMusic)
            }
        case 10:
            level2Func()
        case 20:
            level3Func()
        case 30:
            level4Func()
        case 40:
            level5Func()
        case 50:
            level6Func()
        default:
            break
        }
        
//        self.view!.addGestureRecognizer(tapRecognizer)
    }
    
    func createArc() {
        
        let origin = CGPoint(x: 0, y: -150)
        arc = SKShapeNode(ellipseIn: CGRect(origin: origin, size: CGSize(width: view!.bounds.width, height: 300)))
        arc!.fillColor = SKColor.white
        let tablePattern = UIImage(named: "tablePattern")
        let tablePatternTexture = SKTexture(image: tablePattern!)
        arc!.fillTexture = tablePatternTexture
        arc!.lineWidth = 1.0
//        arc!.glowWidth = 3.0
        arc!.zPosition = 1
        
        worldNode!.addChild(arc!)
    }
    
    func createHead() {
        
        head = SKSpriteNode(imageNamed: "head")
        head!.physicsBody?.affectedByGravity = false
        head!.position = CGPoint(x: view!.bounds.width / 2, y: 50)
        head!.zPosition = 1
        head!.setScale(0.11)
        
        worldNode!.addChild(head!)
    }
    
    func fadeInMouth() {
        
        if mouthCount == 1 {lastMouthFunc()}
        if mouthCount == 0 {endGame()}
        
        mouthIsReady = false
        
        mouth = Mouth(imageNamed: "mouth1")
        mouth!.position = CGPoint(x: self.view!.bounds.width / 2, y: 50)
        
        worldNode!.addChild(mouth!)
        
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 0.25)
        let readyMouth = SKAction.run {self.mouthIsReady = true}
        let seq = SKAction.sequence([fadeIn, readyMouth, mouthMovingAnimation!])
        
        mouth!.run(seq)
    }
    
    func createIceCream() {
        
        iceCream = IceCream(imageNamed: "ice cream")
        
        let initX = CGFloat(-iceCream!.size.width)
        let initY = CGFloat(view!.bounds.height + iceCream!.size.height)
        let initPos = CGPoint(x: initX,y: initY)
        
        iceCream!.position = initPos
        worldNode!.addChild(iceCream!)
        
        moveIceCream(initPos)
    }
    
    func createBadIceCream() {
        
        iceCream = IceCream(imageNamed: "ice cream")
        
        iceCream!.position = CGPoint(x: view!.bounds.width / 2, y: view!.bounds.height / 2)
        
        worldNode!.addChild(iceCream!)
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
    
    func moveSpike(_ spike: Spike, mul: CGFloat) {
        
            let moveDown = SKAction.moveBy(x: 0.0, y: -300.0 * mul, duration: 2.0)
            let moveUp = SKAction.moveBy(x: 0.0, y: 300.0 * mul, duration: 2.0)
            let seq = SKAction.sequence([moveDown,moveUp])
            spike.run(SKAction.repeatForever(seq))
    }
    
    func swellIceCream() {
        
        let swellX = SKAction.scaleX(to: 1.0, duration: 1.0)
        let swellY =  SKAction.scaleY(to: 1.4, duration: 1.0)
        
        let seq = SKAction.group([swellX, swellY])
        
        iceCream!.run(seq)
    }
    
    func moveBadIceCream(rate: Double) {
        
        let spin = SKAction.rotate(byAngle: CGFloat(M_PI), duration: 2.0 / rate)
        let repeatSpin = SKAction.repeatForever(spin)
        
        let right = CGPoint(x: view!.bounds.width, y: view!.bounds.height / 2)
        let left = CGPoint(x: 0, y: view!.bounds.height / 2)
        
        let moveRight = SKAction.move(to: right, duration: 5.0 / rate)
        let moveLeft = SKAction.move(to: left, duration: 5.0 / rate)
        let move = SKAction.sequence([moveRight,moveLeft])
        let repeatMove = SKAction.repeatForever(move)
        let moveAndSpin = SKAction.group([repeatMove,repeatSpin])
        
        iceCream!.run(moveAndSpin)
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
//        let hOffset = CGFloat(heightMax - iceCream!.size.height / 2)
//        let wOffset = CGFloat(heightMax - iceCream!.size.width / 2)
        
        let RandW1 = CGFloat(Int(arc4random_uniform(UInt32(15)))) + CGFloat(5)
        let RandH1 = CGFloat(Int(arc4random_uniform(UInt32(heightMax)))) + CGFloat(heightMax)
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
    
    func playSound(resourceString: String, volume: Float, time: TimeInterval) {
        
        if let soundURL = Bundle.main.url(forResource: resourceString, withExtension: "mp3") {
            let thisSound = SoundNode(url: soundURL)
            thisSound.volume = volume
            worldNode!.addChild(thisSound)
            removeSound(thisSound, waitTime: time)
        }
    }
    
    func removeSound(_ sound:SoundNode, waitTime: TimeInterval) -> () {
    
        let removeSound = SKAction.run {sound.removeFromParent()}
        let wait = SKAction.wait(forDuration: waitTime)
        run(SKAction.sequence([wait,removeSound]))
    }
    
    func shootMouth() {
        
        mouthCount! -= 1
        
        mouthIsReady = false
        
        if let soundURL = Bundle.main.url(forResource: "teethclatter", withExtension: "mp3") {
            teethChatterSound = SoundNode(url: soundURL)
            teethChatterSound.volume = 0.7
            worldNode!.addChild(teethChatterSound)
            removeSound(teethChatterSound, waitTime: 2.0)
        }
        
        let velocity = mouth!.physicsBody?.velocity
        mouthSpeed = Int(sqrt((velocity!.dx * velocity!.dx) + (velocity!.dy * velocity!.dy)) / 10)
        
        switch score {
            
        case 10...19:
            if mouthSpeed > 30 {
                iceCreamGood = false
            } else { iceCreamGood = true }
        case 30...39:
            if mouthSpeed < 70 {
                iceCreamGood = false
            } else { iceCreamGood = true }
        default: break
        }
        
        while childNode(withName: "Mouth") != nil {
            print("mouth is here")
            if (!intersects(mouth!)) {
                removeSound(teethChatterSound, waitTime: 0.0)
            }
        }
        
        let wait = SKAction.wait(forDuration: 3.5)
        let killMouth = SKAction.run {
            self.popMouth(self.mouth!.position)
        }
        let fadeBackIn = SKAction.run { self.fadeInMouth()}
        
        let seq = SKAction.sequence([wait,killMouth,fadeBackIn])
        self.run(seq)
        
        
    }
    
    func lastMouthFunc() {
        
        let label = SKLabelNode(text: "OH NO! LAST MOUTH!")
        label.zPosition = 1.0
        label.fontColor = SKColor.black
        label.fontSize = 25
        label.position = CGPoint(x: view!.bounds.width / 2, y: view!.bounds.height / 2)
        label.zPosition = 1
        label.fontName = "AmericanTypewriter-Bold"
        worldNode!.addChild(label)
        
        let wait = SKAction.wait(forDuration: 1.0)
        let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 2.0)
        let ridLabel = SKAction.run({label.removeFromParent()})
        let seq = SKAction.sequence([wait,fadeOut,ridLabel])
        label.run(seq)
        
    }
    
    func popMouth(_ position: CGPoint) {
        
        if self.childNode(withName: "mouth") != nil {
            if let pop = SKEmitterNode(fileNamed: "Explosion.sks") {
                worldNode!.addChild(pop)
                pop.position = position
            }
            self.mouth!.removeAllActions()
            self.mouth!.removeFromParent()
            fancy = false
        }
        
    }
    
    func playSoundFromArray(array: [String]) {
        
        let randIndex = Int(arc4random_uniform(UInt32(array.count)))
        let thisSound = array[randIndex]
        
        playSound(resourceString: thisSound, volume: 0.6, time: 0.8)
        
    }
    
    func mouthEatIceCream(contactPoint: CGPoint) {
        
        if fancy {
            
            let fancyIdx = Int(arc4random_uniform(UInt32(fancySayings.count - 1)))
            let fancyLabel = SKLabelNode.init(text: fancySayings[fancyIdx])
            fancyLabel.zPosition = 2
            fancyLabel.color = SKColor.red
            fancyLabel.fontSize = 20
            fancyLabel.horizontalAlignmentMode = .center
            fancyLabel.position = CGPoint(x: size.width / 2, y: size.height / 2)
            worldNode!.addChild(fancyLabel)
            
            let wait = SKAction.wait(forDuration: 1.0)
            let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 2.0)
            let ridLabel = SKAction.run({fancyLabel.removeFromParent()})
            let seq = SKAction.sequence([wait,fadeOut,ridLabel])
            fancyLabel.run(seq)
            
        }

        makeExplosion(location: contactPoint)

        removeSound(teethChatterSound, waitTime: 0.0)
        playSound(resourceString: "coin", volume: 0.8, time: 1.0)
    }
    
    func makeExplosion(location: CGPoint) {
        
        if let explosion1 = SKEmitterNode(fileNamed: "Explosion.sks"),
            let explosion2 = SKEmitterNode(fileNamed: "Explosion.sks"),
            let explosion3 = SKEmitterNode(fileNamed: "Explosion.sks") {
            
            let greenSprinkleBundlePath = Bundle.main.path(forResource: "greenSprinkle", ofType: "png")
            let yellowSprinkleBundlePath = Bundle.main.path(forResource: "yellowSprinkle", ofType: "png")
            
            let greenSprinkle = UIImage(contentsOfFile: greenSprinkleBundlePath!)
            let yellowSprinkle = UIImage(contentsOfFile: yellowSprinkleBundlePath!)
            
            explosion2.particleTexture = SKTexture.init(image: greenSprinkle!)
            explosion3.particleTexture = SKTexture.init(image: yellowSprinkle!)
            
            explosion1.position = location
            explosion2.position = location
            explosion3.position = location
            
            iceCream?.removeAllActions()
            iceCream?.removeFromParent()
            
            mouth?.removeAllActions()
            mouth?.removeFromParent()
            fancy = false
            
            worldNode!.addChild(explosion1)
            worldNode!.addChild(explosion2)
            worldNode!.addChild(explosion3)
            
            let removeExplotion = SKAction.run({
                explosion1.removeFromParent()
                explosion2.removeFromParent()
                explosion3.removeFromParent()
            })
            
            let wait = SKAction.wait(forDuration: 1)
            
            self.run(SKAction.sequence([wait, removeExplotion]))
            
        }
    }
    
    func bringUpMenu(menu: SKShapeNode, zPos: CGFloat) {
        
        menu.fillColor = UIColor.blue
        menu.zPosition = zPos
        menu.position = CGPoint(x: view!.bounds.width / 2, y: view!.bounds.height / 2)
        menu.strokeColor = UIColor.red
        menu.glowWidth = 3.0
        menu.alpha = 1.0
        
        self.addChild(menu)
    }
    
    func bringUpAreYouSureMenu() {
        
        let menuSize = CGSize(width: view!.bounds.width * 0.67, height: view!.bounds.height * 0.67)
        areYouSureMenu = SKShapeNode.init(rectOf: menuSize, cornerRadius: 0.15)
        bringUpMenu(menu: areYouSureMenu!, zPos: 6)
        
        sureLabel = SKLabelNode(text: "Leave Game?")
        sureLabel!.position = CGPoint(x: areYouSureMenu!.position.x, y: view!.bounds.height * 0.7)
        
        let buttonSize = CGSize(width: menuSize.width * 0.75, height: view!.bounds.height * 0.08)
        
        let yeahButtonOrigin = CGPoint(x: areYouSureMenu!.position.x / 2, y: view!.bounds.height * 0.5)
        let nahButtonOrigin = CGPoint(x: areYouSureMenu!.position.x / 2, y: view!.bounds.height * 0.3)
        
        print(yeahButtonOrigin)
        print(nahButtonOrigin)
        
        yeahButton = MenuButton.init(rectOf: buttonSize, cornerRadius: 0.2, origin: yeahButtonOrigin, labelText: "Yeah")
        nahButton = MenuButton.init(rectOf: buttonSize, cornerRadius: 0.2, origin: nahButtonOrigin, labelText: "Nah")
        
        yeahButton!.name = "yeahButton"
        nahButton!.name = "nahButton"
        
        yeahButton!.zPosition = 7
        nahButton!.zPosition = 7
        sureLabel!.zPosition = 7
        
        self.addChild(yeahButton!)
        self.addChild(nahButton!)
        self.addChild(sureLabel!)
        
    }
    
    func bringUpSettings() {
        
        settingsAreUp = true
        
        let menuSize = CGSize(width: view!.bounds.width * 0.67, height: view!.bounds.height * 0.67)
        settingsMenu = SKShapeNode.init(rectOf: menuSize, cornerRadius: 0.15)
        bringUpMenu(menu: settingsMenu!, zPos: 3)
        
        let buttonTexts = ["Main Menu", "Just Play Sound", "Level Info", "Play"]

        menuButtons = []
        
        for i in 0...3 {
            
            let yMul = 0.7 - (CGFloat(i) * 0.15)
            let thisOrigin = CGPoint(x: settingsMenu!.position.x / 2, y: view!.bounds.height * yMul)
            let buttonSize = CGSize(width: menuSize.width - 50  , height: view!.bounds.height * 0.08)
//            let thisButton = MenuButton.init(rectOf: buttonSize, cornerRadius: 0.2, origin: thisOrigin)
            let thisButton = MenuButton.init(rectOf: buttonSize, cornerRadius: 0.2, origin: thisOrigin, labelText: buttonTexts[i])
//            thisButton.label?.position = thisButton.position
            thisButton.name = "Button " + String(i)
            thisButton.zPosition = 4
            menuButtons!.append(thisButton)
            worldNode!.addChild(thisButton)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let location = touch!.location(in: self)
        var touchedNode = self.nodes(at: location).first
        
        if touchedNode is SKLabelNode {
            touchedNode = touchedNode?.parent
        }
        
        if mouthSpot!.frame.contains(location) && mouthIsReady {
            touchPoint = location
            touching = true
        }
        
        else if gearIcon!.frame.contains(location) {
            
            worldNode!.isPaused = true
            bringUpSettings()
        }
        
        else if settingsAreUp {
            
            if touchedNode! is MenuButton {
                
                touchedNode!.position = CGPoint(x: touchedNode!.position.x, y: touchedNode!.position.y - 2)
                playSoundFromArray(array: pluckSounds)
                
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch!.location(in: self)
        
        touchPoint = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let touch = touches.first
        let location = touch!.location(in: self)
        var touchedNode = self.nodes(at: location).first
        
        if touchedNode is SKLabelNode {
            touchedNode = touchedNode?.parent
        }
        
        print(touchedNode)
        
        if touchedNode! is MenuButton {
            
            touchedNode!.position = CGPoint(x: touchedNode!.position.x, y: touchedNode!.position.y + 2)
            
            switch touchedNode!.name! {
                
            case "Button 0":
                bringUpAreYouSureMenu()
            case "Button 1":
                break
            case "Button 2":
                break
            case "Button 3":
                
                settingsMenu?.removeFromParent()
                for button in menuButtons! {
                    button.removeFromParent()
                }
                settingsAreUp = false
                worldNode!.isPaused = false
                
            case "yeahButton":
                
                let transition = SKTransition.crossFade(withDuration: 1)
                let mainMenu = MainMenu(size: (scene!.size))
                mainMenu.scaleMode = .aspectFill
                
                self.scene?.view?.presentScene(mainMenu, transition: transition)
            
            case "nahButton":
                
                nahButton?.removeFromParent()
                yeahButton?.removeFromParent()
                sureLabel?.removeFromParent()
                areYouSureMenu?.removeFromParent()
                
            default:
                break
                
            }
        }
        
        if touching && mouthIsReady {shootMouth()}
        
        touching = false
    }
    
    func convertToRange(_ vector:CGVector) -> CGVector {
        
        let returnX = (vector.dx / 3000) * 500
        let returnY = (vector.dy / 3000) * 500
        
        return CGVector(dx: returnX, dy: returnY)
    }
    
    func firstHitFunc() {
        
        mouthHitIceCreamRegistered = true
        let wait = SKAction.wait(forDuration: 0.5)
        let resetAlreadyCalled = SKAction.run({self.mouthHitIceCreamRegistered = false})
        let seq = SKAction.sequence([wait,resetAlreadyCalled])
        self.run(seq)
    }
    
    func toothExplosionFunc(location: CGPoint) {
        
        if let toothExplosion = SKEmitterNode(fileNamed: "ToothExplosion") {
            toothExplosion.particleColor = SKColor.white
            toothExplosion.particleColorSequence = nil;
            toothExplosion.position = location
            worldNode!.addChild(toothExplosion)
            
            toothExplosion.physicsBody?.velocity = (mouth!.physicsBody?.velocity)!
            
            playSound(resourceString: "teeth2", volume: 0.8, time: 2.0)
        }
        
        mouth!.removeFromParent()

    }
    
    func changeScore(good: Bool) {
        
        var value = arc4random_uniform(500)
        if fancy {
            value += 500
        }
        
        if good {
            displayedScore += Int(value)
        } else {
            displayedScore -= Int(value)
}
        scoreLabel!.text = "SCORE: \(displayedScore)"
    }
    
    func makeSpeedLabel(position: CGPoint) {
    
        if score >= 10 && score <= 19 || score >= 30 && score <= 39 {
            
            let string = String(describing: mouthSpeed) + " MPH!"
            let speedLbl = SKLabelNode(text: string)
            speedLbl.zPosition = 1.0
            speedLbl.fontColor = SKColor.black
            speedLbl.fontSize = 15
            speedLbl.position = position
            speedLbl.zPosition = 1
            speedLbl.fontName = "AmericanTypewriter-Bold"
            worldNode!.addChild(speedLbl)
            
            let wait = SKAction.wait(forDuration: 1.0)
            let fadeOut = SKAction.fadeAlpha(to: 0.0, duration: 2.0)
            let ridLabel = SKAction.run({speedLbl.removeFromParent()})
            let seq = SKAction.sequence([wait,fadeOut,ridLabel])
            speedLbl.run(seq)
        }
    }
    
    func bumpUpSquareMoveRate() {
        
        squareRate += 0.2
        
        let bumpUpSquare1 = SKAction.run({
            self.redSquare!.removeAllActions()
            self.moveRedSquare(self.redSquare!)})
        let bumpUpSquare2 = SKAction.run({
            self.redSquare2!.removeAllActions()
            self.moveRedSquare2(self.redSquare2!)})
        
        let group = SKAction.group([bumpUpSquare1,bumpUpSquare2])
        
        run(group)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        //        *********  MOUTH HITS ICE CREAM  *********
        
        if (contact.bodyA.categoryBitMask == BodyType.iceCream.rawValue) &&
            (contact.bodyB.categoryBitMask == BodyType.mouth.rawValue) ||
            (contact.bodyA.categoryBitMask == BodyType.mouth.rawValue) &&
            (contact.bodyB.categoryBitMask == BodyType.iceCream.rawValue){
            
            let contactPoint = contact.contactPoint
            
            if !iceCreamGood {
                
                if !mouthHitIceCreamRegistered {
                    
                    firstHitFunc()
                    
                    makeSpeedLabel(position: contactPoint)
                    
                    removeSound(teethChatterSound, waitTime: 0.0)
                
                    toothExplosionFunc(location: contactPoint)
                    
                    if score > 50 {
                        
                        moveBadIceCreamRate -= 1.0
                        iceCream!.removeAllActions()
                        moveBadIceCream(rate: moveBadIceCreamRate)
                        score -= 1
                        changeScore(good: false)
                    }
                    
                }
                
            } else if !mouthHitIceCreamRegistered {
                
                firstHitFunc()
                makeSpeedLabel(position: contactPoint)
                
                score += 1
                changeScore(good: true)
                scoreLabel!.text = "SCORE: \(displayedScore)"
                
                mouthEatIceCream(contactPoint: contactPoint)
                
                //                **************************************************
                //            **** SWITCHING ON SCORE TO DESIGNATE LEVELS, KINDA *****
                //                **************************************************
                
                switch score {
                    
                case 10:
                    transitionToNextLevel(level: "Level 2")
                case 20:
                    transitionToNextLevel(level: "Level 3")
                case 21...29:
                    bumpUpSquareMoveRate()
                    self.createIceCream()
                case 30:
                    transitionToNextLevel(level: "Level 4")
                case 40:
                    transitionToNextLevel(level: "Level 5")
                case 50:
                    transitionToNextLevel(level: "Level 6")
                case 51...60: break
                default:
                    self.createIceCream()
                }
                
                
            }
            
        }
            
            
            //        *********  MOUTH HITS SPIKE  *********
            
        else if (contact.bodyA.categoryBitMask == BodyType.mouth.rawValue) &&
            (contact.bodyB.categoryBitMask == BodyType.spike.rawValue) ||
            (contact.bodyA.categoryBitMask == BodyType.spike.rawValue) &&
            (contact.bodyB.categoryBitMask == BodyType.mouth.rawValue) {
            
            let contactPoint = contact.contactPoint
            
            toothExplosionFunc(location: contactPoint)
            
            fancy = false
        }
            
            //        *********  MOUTH HITS RED SQUARE  *********
            
        else if (contact.bodyA.categoryBitMask == BodyType.mouth.rawValue) &&
            (contact.bodyB.categoryBitMask == BodyType.redSquare.rawValue) ||
            (contact.bodyA.categoryBitMask == BodyType.redSquare.rawValue) &&
            (contact.bodyB.categoryBitMask == BodyType.mouth.rawValue) {
            
            fancy = true
            
            playSoundFromArray(array: bounceSounds)
            
            let bodies = contact.bodyA.node?.physicsBody?.allContactedBodies()
            // IF TOUCHING BOTH SQUARES AND MOUTH IS ABOVE BOTTOM POINT OF SQUARE, KILL MOUTH
            if (bodies?.count)! > 1 && mouth!.position.y > redSquare!.position.y - (redSquare!.frame.height / 2) {
                
//                popMouth((contact.bodyA.node?.position)!)
                toothExplosionFunc(location: contact.contactPoint)
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
                mouthHitToothbrush()
            }
                
            else if contact.bodyB.node?.name == "toothbrush" {
                let brush = contact.bodyB.node
                brush?.removeFromParent()
                mouthHitToothbrush()
            }
            
            
        }
        
        //        *********  END COLLISION STATEMENTS  *********
        
    }
    
    func mouthHitToothbrush() {
        
        playSound(resourceString: "BrushSound", volume: 0.8, time: 1.5)
        
        removeSound(teethChatterSound, waitTime: 0.0)
        
        moveBadIceCreamRate += 1.0
        iceCream!.removeAllActions()
        moveBadIceCream(rate: moveBadIceCreamRate)
        score += 1
        changeScore(good: true)
    }
    
    func moveRedSquare(_ square:RedSquare) {

        let leftPosition = CGPoint(x: 0, y: size.height / 2)
        let rightPosition = CGPoint(x: size.width, y: size.height / 2)
        
        square.position = leftPosition
        
        let moveRight = SKAction.move(to: rightPosition, duration: 2.5 / squareRate)
        let moveLeft = SKAction.move(to: leftPosition, duration: 2.5 / squareRate)
        let leftRightSeq = SKAction.sequence([moveRight,moveLeft])
        
        square.run(SKAction.repeatForever(leftRightSeq))
    }
    
    func moveRedSquare2(_ square:RedSquare) {
        
        let leftPosition = CGPoint(x: 0, y: size.height / 2)
        let rightPosition = CGPoint(x: size.width, y: size.height / 2)
        
        square.position = rightPosition
        
        let moveLeft = SKAction.move(to: leftPosition, duration: 2.25 / squareRate)
        let moveRight = SKAction.move(to: rightPosition, duration: 2.25 / squareRate)

        let leftRightSeq = SKAction.sequence([moveLeft,moveRight])
        
        square.run(SKAction.repeatForever(leftRightSeq))
    }
    
    func createSpike(_ aSpike:Spike, position: CGPoint) {
        
        aSpike.position = position
        worldNode!.addChild(aSpike)
    }
    
    func createToothbrush(brush: Toothbrush) {
        
        worldNode!.addChild(brush)
        
        let yOffset = UInt32(size.height / 2)
        
        let initRandomY = arc4random_uniform(UInt32(size.height / 2)) + yOffset
        let finalRandomY = arc4random_uniform(UInt32(size.height / 2)) + yOffset
        
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
        worldNode!.addChild(label)
    }
    
    func makeScoreLabel() {
        
        scoreLabel = SKLabelNode.init(text: "SCORE: \(displayedScore)")
        scoreLabel!.color = SKColor.white
        scoreLabel!.horizontalAlignmentMode = .left
        scoreLabel!.position = CGPoint(x: 0, y: size.height - 20)
        scoreLabel!.fontSize = 20
        scoreLabel!.zPosition = 1
        worldNode!.addChild(scoreLabel!)
    }
    
    func transitionToNextLevel(level: String) {
        
        let fadeOut = SKAction._changeVolumeTo(endVolume: 0.0, duration: 2.0)
        let waitForFade = SKAction.wait(forDuration: 2.0)
        let seq = SKAction.sequence([fadeOut,waitForFade])
        backgroundMusic?.run(seq)
        
        let transition = SKTransition.crossFade(withDuration: 2.0)
        let menuScene = NewLevelMenu(fileNamed: "NewLevelMenu")
        weak var weakSelf = self
        menuScene!.returnScene = weakSelf
        menuScene!.setNewLevel(newLevel: (levelMenuData[level]?["level"])! )
        
        let block = {self.scene!.view!.presentScene(menuScene!, transition: transition)}
        
        let wait = SKAction.wait(forDuration: 1.5)
        run(SKAction.sequence([wait, SKAction.run(block)]))
        
    }
    
    //        *********  NEW LEVEL FUNCTIONS  *********
    
    func level2Func() {
        
        if let musicURL = Bundle.main.url(forResource: "bgmusicLevel2", withExtension: "mp3") {
            backgroundMusic = SoundNode(url: musicURL)
            worldNode!.addChild(backgroundMusic)
            let fadeIn = SKAction._changeVolumeTo(endVolume: 1.0, duration: 2.0)
            backgroundMusic.run(fadeIn)
        }
        
    }
    
    func level3Func() {
        
        if let musicURL = Bundle.main.url(forResource: "bgmusicLevel3", withExtension: "mp3") {
            backgroundMusic = SoundNode(url: musicURL)
            worldNode!.addChild(backgroundMusic)
            let fadeIn = SKAction._changeVolumeTo(endVolume: 1.0, duration: 2.0)
            backgroundMusic.run(fadeIn)
        }
        
        redSquare = RedSquare(imageNamed: "red square")
        redSquare2 = RedSquare(imageNamed: "red square")
        worldNode!.addChild(redSquare!)
        worldNode!.addChild(redSquare2!)
        let createFirstSquare = SKAction.run({ self.moveRedSquare(self.redSquare!)})
        let createSecondSquare = SKAction.run({ self.moveRedSquare2(self.redSquare2!)})
        let group = SKAction.group([createFirstSquare,createSecondSquare])
        self.run(group)
    }
    
    func level4Func() {
        
        if let musicURL = Bundle.main.url(forResource: "bgmusicLevel4", withExtension: "mp3") {
            backgroundMusic = SoundNode(url: musicURL)
            worldNode!.addChild(backgroundMusic)
        }
        
        redSquare?.removeAllActions()
        redSquare?.removeFromParent()
        redSquare2?.removeAllActions()
        redSquare2?.removeFromParent()
        
        self.createIceCream()
    }
    
    func level5Func() {
        
        if let musicURL = Bundle.main.url(forResource: "bgmusicLevel5", withExtension: "mp3") {
            backgroundMusic = SoundNode(url: musicURL)
            worldNode!.addChild(backgroundMusic)
        }
        
        for i in 0...spikes.count - 1 {
            var thisSpike = spikes[i]
            thisSpike = Spike(imageNamed: "spike")
            
            if i%2 == 0 {
                createSpike(thisSpike!, position: CGPoint(x: CGFloat(i * 80) + 18 + (thisSpike!.size.width / 2), y: 500 ))
                moveSpike(thisSpike!, mul: 1.0)
            } else {
                createSpike(thisSpike!, position: CGPoint(x: CGFloat(i * 80) + 18 + (thisSpike!.size.width / 2), y: 200 ))
                moveSpike(thisSpike!, mul: -1.0)
            }
            
        }
    }
    
    
    
    func level6Func() {
        
        if let musicURL = Bundle.main.url(forResource: "bgmusicLevel6", withExtension: "mp3") {
            backgroundMusic = SoundNode(url: musicURL)
            worldNode!.addChild(backgroundMusic)
        }
        
        self.iceCreamGood = false
        
        self.createBadIceCream()
        swellIceCream()
        moveBadIceCream(rate: 1.0)
        
        
        enumerateChildNodes(withName: "spike", using: { (node, stop) in
            node.removeFromParent()
        })
        
        toothbrush1 = Toothbrush(imageNamed: "toothbrush")
        toothbrush2 = Toothbrush(imageNamed: "toothbrush")
        toothbrush3 = Toothbrush(imageNamed: "toothbrush")
        let createBrush1 = SKAction.run({self.createToothbrush(brush: self.toothbrush1!)})
        let createBrush2 = SKAction.run({self.createToothbrush(brush: self.toothbrush2!)})
        let createBrush3 = SKAction.run({self.createToothbrush(brush: self.toothbrush3!)})
        
        let waitBetweenBrushes = SKAction.wait(forDuration: 0.4)
        let sequence = SKAction.sequence([createBrush1,waitBetweenBrushes,createBrush2,waitBetweenBrushes,createBrush3,waitBetweenBrushes])
        
        run(SKAction.repeatForever(sequence))
    }
    
    func endGame() {
        
        if let prevHighScores = UserDefaults.standard.array(forKey: "highScores") as? [Int] {
            
            if displayedScore >= prevHighScores.last! {
                playerGotAHighScore()
            } else {
                let fadeOut = SKAction._changeVolumeTo(endVolume: 0.0, duration: 2.0)
                let waitForFade = SKAction.wait(forDuration: 2.0)
                let seq = SKAction.sequence([fadeOut,waitForFade])
                backgroundMusic.run(seq)
                
                let transition = SKTransition.crossFade(withDuration: 2.0)
                let highScoresScreen = HighScores(fileNamed: "HighScores")
                
                let block = {self.scene!.view!.presentScene(highScoresScreen!, transition: transition)}
                
                let wait = SKAction.wait(forDuration: 1.5)
                run(SKAction.sequence([wait, SKAction.run(block)]))
                
            }
        }
    }
    

    func playerGotAHighScore() {
        
        let congratsLabel = SKLabelNode(text: "CONGRATS! YOU GOT A HIGH SCORE!")
        congratsLabel.zPosition = 1.0
        congratsLabel.fontColor = SKColor.black
        congratsLabel.fontSize = 25
        congratsLabel.position = CGPoint(x: view!.bounds.width / 2, y: view!.bounds.height / 2)
        congratsLabel.zPosition = 1
        congratsLabel.fontName = "AmericanTypewriter-Bold"
        worldNode!.addChild(congratsLabel)
        
        
    }
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        guard !worldNode!.isPaused else { return }
        
        bg1!.position = CGPoint(x: bg1!.position.x-1, y: bg1!.position.y);
        bg2!.position = CGPoint(x: bg2!.position.x-1, y: bg2!.position.y);
        
        if (bg1!.position.x < -bg1!.size.width) {
            bg1!.position = CGPoint(x: bg2!.position.x + bg2!.size.width, y: bg1!.position.y);
        }
        
        
        if (bg2!.position.x < -bg2!.size.width) {
            bg2!.position = CGPoint(x: bg1!.position.x + bg1!.size.width, y: bg2!.position.y);
        }
        
        
        if touching {
            let dt:CGFloat = 1.0/60.0
            let distance = CGVector(dx: touchPoint.x-mouth!.position.x, dy: touchPoint.y-mouth!.position.y)
            let velocity = CGVector(dx: distance.dx/dt * 0.5, dy: distance.dy/dt * 0.5)
            let convVel = convertToRange(velocity)
            mouth!.physicsBody!.velocity = convVel
            
            if !arc!.contains(touchPoint) {
                shootMouth()
                touching = false
            }
        }
    }
}
