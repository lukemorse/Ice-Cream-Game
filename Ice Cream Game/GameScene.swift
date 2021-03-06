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
    var SCALE_MUL: CGFloat?
    var scoreLabel: SKLabelNode?
    var nextLevelLabel: SKLabelNode?
    var mouthsLabel: SKLabelNode?
    var fancy = false
    var settingsAreUp = false
    var gameOver = false
    var mouthSpeed = 0
    var levelIndex = "Level 1"
    var nextLevelCounter = 10
    
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
    var settingsNode: SettingsNode?
    
    var toothbrush1: Toothbrush?
    var toothbrush2: Toothbrush?
    var toothbrush3: Toothbrush?
    
    var mouthMovingAnimation: SKAction?
    
    var backgroundMusic: SoundNode!
    var teethChatterSound: SoundNode?
    var coinSound: SoundNode?
    var teethSound: SoundNode!
    var badIceCreamSound: SoundNode!
    var brushSound: SoundNode!
    var bg1: SKSpriteNode?
    var bg2: SKSpriteNode?
    let bounceSounds = ["bounce1","bounce2","bounce3","bounce4","bounce5",]
    let pluckSounds = ["pluck1","pluck2","pluck3","pluck4","pluck5","pluck6"]
    
    var iceCreamGood = true
    var mouthHitIceCreamRegistered = false
    
    var squareRate = 1.0
    var moveBadIceCreamRate = 1.0
    
    var killMouth: SKAction?
    var rect: CGRect?
    var MID_POINT: CGPoint?
    
    override func didMove(to view: SKView) {
        
        worldNode = SKNode.init()
        addChild(worldNode!)
        self.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        SCALE_MUL = (scene?.view?.bounds.width)! * 0.00018
        
        MID_POINT = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        bg1 = SKSpriteNode.init(imageNamed: "IceCreamGameBG.jpeg")
        bg1!.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        bg1!.position = CGPoint(x: 0.0, y: 0.0)
        bg1!.zPosition = 0
        bg1!.setScale(SCALE_MUL! * 3)
        worldNode!.addChild(bg1!)
        
        bg2 = SKSpriteNode.init(imageNamed: "IceCreamGameBG.jpeg")
        bg2!.anchorPoint = CGPoint(x: 0.0, y: 0.0)
        bg2!.position = CGPoint(x: bg1!.size.width - 1, y: 0);
        bg2!.zPosition = 0
        bg2!.setScale(SCALE_MUL! * 3)
        worldNode!.addChild(bg2!)
        
        settingsNode = SettingsNode.init(imageNamed: "gear", targetScene: self.scene!)
        settingsNode!.parentViewBounds = self.view!.bounds
        settingsNode!.setScale(SCALE_MUL!)
        settingsNode!.position = CGPoint(x: view.bounds.width - (settingsNode!.size.width / 2), y: view.bounds.height - (settingsNode!.size.height / 2))
        settingsNode!.zPosition = 1
        self.addChild(settingsNode!)
        
        
        physicsWorld.contactDelegate = self
        
        setUpAnimation()
        createHead()
        fadeInMouth()
        makeScoreLabel()
        makeNextLevelLabel()
        makeMouthsLabel()
        createArc()
        
        mouthSpot = SKSpriteNode(imageNamed: "mouth1")
        mouthSpot!.setScale(SCALE_MUL! * 4)
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
                backgroundMusic.volume = 0.8
                worldNode!.addChild(backgroundMusic)
                levelIndex = "Level 1"
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
        
        killMouth = SKAction.run {
            self.popMouth((self.mouth?.position)!)
        }
    }
    
    func createArc() {
        
//        let origin = CGPoint(x: 0, y: SCALE_MUL! * 2500)
        let origin = CGPoint(x: 0, y: MID_POINT!.y / 2)
        arc = SKShapeNode(ellipseIn: CGRect(origin: origin, size: CGSize(width: view!.bounds.width, height: SCALE_MUL! * 5000)))
        arc!.position = CGPoint(x: 0, y: -MID_POINT!.y)
        arc!.fillColor = SKColor.white
        let tablePattern = UIImage(named: "tablePattern")
        let tablePatternTexture = SKTexture(image: tablePattern!)
        arc!.fillTexture = tablePatternTexture
        arc!.lineWidth = 1.0
        arc!.zPosition = 1
        
        worldNode!.addChild(arc!)
    }
    
    func createHead() {
        
        head = SKSpriteNode(imageNamed: "head")
        head!.physicsBody?.affectedByGravity = false
        head!.position = CGPoint(x: view!.bounds.width / 2, y: SCALE_MUL! * 1000)
        head!.zPosition = 1
        head!.setScale(SCALE_MUL! * 1.8)
        
        worldNode!.addChild(head!)
    }
    
    func fadeInMouth() {
        
        if mouthCount == 1 {lastMouthFunc()}
        if mouthCount == 0 {endGame(); return}
        
        mouthIsReady = false
        
        mouth = Mouth(imageNamed: "mouth1")
        mouth!.setScale(SCALE_MUL! * 1.8)
        mouth!.position = CGPoint(x: self.view!.bounds.width / 2, y: SCALE_MUL! * 1000)
        
        worldNode!.addChild(mouth!)
        let fadeIn = SKAction.fadeAlpha(to: 1.0, duration: 1.0)
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
        iceCream!.setScale(SCALE_MUL! * 8)
        worldNode!.addChild(iceCream!)
        
        moveIceCream(sprite: iceCream!, initPos: initPos)
    }
    
    func createBadIceCream() {
        
        iceCream = IceCream(imageNamed: "ice cream")
        
        iceCream!.position = MID_POINT!
        
        worldNode!.addChild(iceCream!)
    }
    
    func moveIceCream(sprite: IceCream, initPos:CGPoint) {
        
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
        sprite.run(SKAction.sequence([move1,repeatAction]))
    }
    
    func moveSpike(_ spike: Spike, mul: CGFloat) {
        
            let moveDown = SKAction.moveBy(x: 0.0, y: -300.0 * mul, duration: 2.0)
            let moveUp = SKAction.moveBy(x: 0.0, y: 300.0 * mul, duration: 2.0)
            let seq = SKAction.sequence([moveDown,moveUp])
            spike.run(SKAction.repeatForever(seq))
    }
    
    func swellIceCream() {
        
        let swellX = SKAction.scaleX(to: SCALE_MUL! * 16, duration: 1.0)
        let swellY =  SKAction.scaleY(to: SCALE_MUL! * 23, duration: 1.0)
        
        let seq = SKAction.group([swellX, swellY])
        
        iceCream!.run(seq)
    }
    
    func moveBadIceCream(rate: Double) {
        
        let spin = SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 2.0 / rate)
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
        let widthMax = UInt32(self.view!.bounds.width - 10)
        let heightMax = CGFloat(self.view!.bounds.height / 2)
        
        let RandW1 = CGFloat(arc4random_uniform(15)) + 5
        let RandH1 = CGFloat(arc4random_uniform(UInt32(heightMax))) + heightMax
        let point1 = CGPoint(x: RandW1, y: RandH1)
        
        let RandW2 = CGFloat(widthMax - arc4random_uniform(15)) + 5
        let RandH2 = CGFloat(arc4random_uniform(UInt32(heightMax))) + heightMax
        let point2 = CGPoint(x: RandW2, y: RandH2)
        
        let RandW3 = CGFloat(arc4random_uniform(15)) + 5
        let RandH3 = CGFloat(arc4random_uniform(UInt32(heightMax))) + heightMax
        let point3 = CGPoint(x: RandW3, y: RandH3)
        
        let RandW4 = CGFloat(UInt32(widthMax) - arc4random_uniform(15)) + 5
        let RandH4 = CGFloat(arc4random_uniform(UInt32(heightMax))) + heightMax
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
            thisSound.autoplayLooped = false
            let play = SKAction.play()
            thisSound.run(play)
            removeSound(thisSound, waitTime: time)
        }
    }
    
    func removeSound(_ sound:SoundNode, waitTime: TimeInterval) -> () {
    
        let removeSound = SKAction.run {sound.removeFromParent()}
        let wait = SKAction.wait(forDuration: waitTime)
        run(SKAction.sequence([wait,removeSound]))
    }
    
    func shootMouth() {
        mouthIsReady = false
        
        if let teethURL = Bundle.main.url(forResource: "teethclatter", withExtension: "mp3") {
            teethChatterSound = SoundNode(url: teethURL)
            worldNode!.addChild(teethChatterSound!)
        }
        
        let velocity = mouth!.physicsBody?.velocity
        mouthSpeed = Int(sqrt((velocity!.dx * velocity!.dx) + (velocity!.dy * velocity!.dy)) / 10)
        
        let wait = SKAction.wait(forDuration: 4.5)
        let fadeBackIn = SKAction.run { if self.mouth == nil {
            self.fadeInMouth()}}
        
        let seq = SKAction.sequence([wait,killMouth!,fadeBackIn])
        mouth!.run(seq)
        
        
    }
    
    func lastMouthFunc() {
        
        let label = SKLabelNode(text: "OH NO! LAST MOUTH!")
        label.zPosition = 1.0
        label.fontColor = SKColor.black
        label.fontSize = 25
        label.position = MID_POINT!
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
        
        if !gameOver {
            
            mouthCount -= 1
            mouthsLabel?.text = "Mouths Left: \(mouthCount)"
            animateLabel(label: mouthsLabel!, good: false)
            changeScore(good: false)
            
            if worldNode?.childNode(withName: "mouth") != nil {
                toothExplosionFunc(location: position)
                if teethChatterSound != nil {
                    removeSound(teethChatterSound!, waitTime: 0.2)
                }
                mouth!.removeAllActions()
                mouth!.removeFromParent()
                fancy = false
                fadeInMouth()
            }
        }
    }
    
    func playSoundFromArray(array: [String]) {
        
        let randIndex = Int(arc4random_uniform(UInt32(array.count)))
        let thisSound = array[randIndex]
        
        playSound(resourceString: thisSound, volume: 0.6, time: 0.5)
        
    }
    
    func mouthEatIceCream(contactPoint: CGPoint) {
        
        if fancy {
            
            let fancyLabel = SKLabelNode.init(text: fancySayings[fancySayingsIndex])
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
            fancySayingsIndex += 1 % (fancySayings.count - 1)
            
        }

        makeExplosion(location: contactPoint, endGame: false)

        if teethChatterSound != nil {
            removeSound(teethChatterSound!, waitTime: 0.0)
        }
        
        playSound(resourceString: "coin", volume: 0.8, time: 1.0)
    }
    
    func makeExplosion(location: CGPoint, endGame: Bool) {
        
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
            
            explosion1.zPosition = 3
            explosion2.zPosition = 3
            explosion3.zPosition = 3
            
            if !endGame {
                iceCream?.removeAllActions()
                iceCream?.removeFromParent()
                
                mouth?.removeAllActions()
                mouth?.removeFromParent()
                fadeInMouth()
            }
            
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
        
        else if settingsNode!.frame.contains(location) {
            settingsAreUp = true
            worldNode!.isPaused = true
            physicsWorld.speed = 0
            settingsNode!.bringUpSettings(position: MID_POINT!)
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
        
        if touchedNode is MenuButton {
            
            touchedNode!.position = CGPoint(x: touchedNode!.position.x, y: touchedNode!.position.y + 2)
            
            switch touchedNode!.name! {
                
            case "Button 0":
                settingsNode!.bringUpAreYouSureMenu(position: MID_POINT!, zPos: 6, clearScoresFlag: false)
            case "Button 1":
                settingsNode!.bringUpHighScores(position: MID_POINT!, addScoreFlag: false)
            case "Button 2":
                settingsNode!.bringUpLevelInfoMenu(position: MID_POINT!, levelIndex: levelIndex)
            case "Button 3":
                settingsNode!.ridSettingsMenu()
                settingsAreUp = false
                worldNode!.isPaused = false
                physicsWorld.speed = 1.0
                
            case "yeahButton":
                if !gameOver {
                    endGame()
                }
                
                goToMainMenu()
            
            case "nahButton":
                settingsNode?.ridSureMenu()
            case "okCoolButton":
                settingsNode?.ridHighScoresMenu()
            case "okCoolButton_LEVEL_INFO":
                settingsNode?.ridLevelInfoMenu()
            case "clearButton":
                settingsNode!.bringUpAreYouSureMenu(position: MID_POINT!, zPos: 9, clearScoresFlag: true)
            case "yeahButton_CLEAR":
                settingsNode?.clearHighScores()
                settingsNode?.ridSureMenu()
                settingsNode?.ridHighScoresMenu()
                settingsNode?.bringUpHighScores(position: MID_POINT!, addScoreFlag: false)
            case "BackToMainMenu":
                settingsNode?.ridHighScoresMenu()
            default:
                break
                
            }
        }
        
        if touching && mouthIsReady {shootMouth()}
        
        touching = false
    }
    
    func goToMainMenu() {
        
        let transition = SKTransition.crossFade(withDuration: 1)
        let mainMenu = MainMenu(size: (scene!.size))
        mainMenu.scaleMode = .aspectFill
        
        self.scene?.view?.presentScene(mainMenu, transition: transition)
        
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
            toothExplosion.zPosition = 3
            worldNode!.addChild(toothExplosion)
            
            if location.y == 0 {
                toothExplosion.emissionAngle = CGFloat(Double.pi / 2)
            } else if location.y == view!.bounds.height {
                toothExplosion.emissionAngle = CGFloat(Double.pi * 3 / 2)
            } else if location.x == 0 {
                toothExplosion.emissionAngle = 0.0
            } else if location.x == view!.bounds.width {
                toothExplosion.emissionAngle = CGFloat(Double.pi)
            }
            playSound(resourceString: "teeth2", volume: 0.8, time: 2.0)
            
            let wait = SKAction.wait(forDuration: 3)
            let removeTeeth = SKAction.run {
                toothExplosion.removeFromParent()
            }
            worldNode?.run(SKAction.sequence([wait,removeTeeth]))
        }
    }
    
    func changeScore(good: Bool) {
        var value = arc4random_uniform(500)
        if fancy {
            value += 500
        }
        
        if good {
            displayedScore += Int(value)
            animateLabel(label: scoreLabel!, good: true)
            nextLevelCounter -= 1
            nextLevelLabel!.text = "Next Level: \(nextLevelCounter)"
            animateLabel(label: nextLevelLabel!, good: true)
            
        } else {
            value = value / 8
            displayedScore -= Int(value)
            animateLabel(label: scoreLabel!, good: false)
}
        scoreLabel!.text = "SCORE: \(displayedScore)"
    }
    
    func animateLabel(label: SKLabelNode, good: Bool) {
        
        var changeScoreSize = SKAction()
        var changeScoreColor = SKAction()
        if good {
            changeScoreSize = SKAction.scale(to: 1.2, duration: 0.18)
            changeScoreColor = SKAction.colorize(with: UIColor.green, colorBlendFactor: 1.0, duration: 0.3)
        } else {
            changeScoreSize = SKAction.scale(to: 0.8, duration: 0.18)
            changeScoreColor = SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.3)
        }
        let changeScoreSizeBack = SKAction.scale(to: 1.0, duration: 0.3)
        let changeScoreColorBack = SKAction.colorize(with: UIColor.white, colorBlendFactor: 1, duration: 0.3)
        let swellScore = SKAction.sequence([changeScoreSize,changeScoreSizeBack])
        let colorizeScore = SKAction.sequence([changeScoreColor,changeScoreColorBack])
        let group = SKAction.group([swellScore,colorizeScore])
        label.run(group)
    }
    
    func makeSpeedLabel(position: CGPoint) {
    
//        if score >= 10 && score <= 19 || score >= 30 && score <= 39 {
        if score <= 19 || score >= 30 && score <= 39 {
            
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
            
            // Change value of iceCreamGood for different levels
            switch score {
                
            case 10...19:
                if mouthSpeed > 25 {
                    iceCreamGood = false
                } else { iceCreamGood = true }
            case 30...39:
                if mouthSpeed < 65 {
                    iceCreamGood = false
                } else { iceCreamGood = true }
            default: break
            }
            
            if !iceCreamGood {
                
                if !mouthHitIceCreamRegistered {
                    
                    firstHitFunc()
                    
                    makeSpeedLabel(position: contactPoint)
                    
                    popMouth(contactPoint)
                    
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
            
            popMouth(contact.contactPoint)
            
            fancy = false
        }
            
            //        *********  MOUTH HITS RED SQUARE  *********
            
        else if (contact.bodyA.categoryBitMask == BodyType.mouth.rawValue) &&
            (contact.bodyB.categoryBitMask == BodyType.redSquare.rawValue) ||
            (contact.bodyA.categoryBitMask == BodyType.redSquare.rawValue) &&
            (contact.bodyB.categoryBitMask == BodyType.mouth.rawValue) {
            
            fancy = true
            
            playSoundFromArray(array: bounceSounds)
            
            // IF TOUCHING BOTH SQUARES AND MOUTH IS ABOVE BOTTOM POINT OF SQUARE, KILL MOUTH
            if let bodyCount = contact.bodyA.node?.physicsBody?.allContactedBodies() {
                
                if bodyCount.count > 1 && mouth!.position.y > redSquare!.position.y - (redSquare!.frame.height / 2) {
                    popMouth(contact.contactPoint)
                }
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
        
        if teethChatterSound != nil {
            removeSound(teethChatterSound!, waitTime: 0.0)
        }
        
        mouth?.removeAllActions()
        mouth?.removeFromParent()
        fadeInMouth()
        
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
        
        brush.setScale(SCALE_MUL! * 5)
        
        let yOffset = UInt32(size.height / 2)
        
        let initRandomY = arc4random_uniform(UInt32(size.height / 2)) + yOffset
        let finalRandomY = arc4random_uniform(UInt32(size.height / 2)) + yOffset
        
        let leftPosition = CGPoint(x: -brush.size.height, y: CGFloat(initRandomY))
        let rightPosition = CGPoint(x: size.width + brush.size.height, y: CGFloat(finalRandomY))
        
        //        let velocity = CGVector(dx: 200, dy: 0)
        //        toothbrush!.physicsBody!.velocity = velocity
        
        brush.position = leftPosition
        
        worldNode!.addChild(brush)
        
        let moveBrush = SKAction.move(to: rightPosition, duration: 1)
        let rotate = SKAction.rotate(byAngle: CGFloat(Double.pi * 2), duration: 2.0)
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
        scoreLabel!.fontName = "Chalkduster"
        scoreLabel!.horizontalAlignmentMode = .left
        scoreLabel!.position = CGPoint(x: 0, y: size.height - 20)
        scoreLabel!.fontSize = 20
        scoreLabel!.zPosition = 1
        worldNode!.addChild(scoreLabel!)
    }
    
    func makeNextLevelLabel() {
        
        nextLevelLabel = SKLabelNode.init(text: "Next Level: \(nextLevelCounter)")
        nextLevelLabel!.color = SKColor.white
        nextLevelLabel!.fontName = "Chalkduster"
        nextLevelLabel!.horizontalAlignmentMode = .left
        nextLevelLabel!.position = CGPoint(x: scoreLabel!.position.x, y: scoreLabel!.position.y - scoreLabel!.frame.height)
        nextLevelLabel!.fontSize = 20
        nextLevelLabel!.zPosition = 1
        worldNode!.addChild(nextLevelLabel!)
    }
    
    func makeMouthsLabel() {
        mouthsLabel = SKLabelNode.init(text: "Mouths Left: \(mouthCount)")
        mouthsLabel?.color = SKColor.white
        mouthsLabel?.fontName = "Chalkduster"
        mouthsLabel?.horizontalAlignmentMode = .left
        mouthsLabel?.position = CGPoint(x: scoreLabel!.position.x, y: nextLevelLabel!.position.y - nextLevelLabel!.frame.height)
        mouthsLabel?.fontSize = 20
        mouthsLabel?.zPosition = 1
        worldNode!.addChild(mouthsLabel!)
    }
    
    func transitionToNextLevel(level: String) {
        
        if !gameOver {
            
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
    }
    
    //        *********  NEW LEVEL FUNCTIONS  *********
    
    func level2Func() {
        
        levelIndex = "Level 2"
        if let musicURL = Bundle.main.url(forResource: "bgmusicLevel2", withExtension: "mp3") {
            backgroundMusic = SoundNode(url: musicURL)
            worldNode!.addChild(backgroundMusic)
            let fadeIn = SKAction._changeVolumeTo(endVolume: 1.0, duration: 2.0)
            backgroundMusic.run(fadeIn)
        }
        
    }
    
    func level3Func() {
        
        levelIndex = "Level 3"
        if let musicURL = Bundle.main.url(forResource: "bgmusicLevel3", withExtension: "mp3") {
            backgroundMusic = SoundNode(url: musicURL)
            worldNode!.addChild(backgroundMusic)
            let fadeIn = SKAction._changeVolumeTo(endVolume: 1.0, duration: 2.0)
            backgroundMusic.run(fadeIn)
        }
        
        redSquare = RedSquare(imageNamed: "red square")
        redSquare2 = RedSquare(imageNamed: "red square")
        redSquare!.setScale(SCALE_MUL! * 13)
        redSquare2!.setScale(SCALE_MUL! * 13)
        worldNode!.addChild(redSquare!)
        worldNode!.addChild(redSquare2!)
        let createFirstSquare = SKAction.run({ self.moveRedSquare(self.redSquare!)})
        let createSecondSquare = SKAction.run({ self.moveRedSquare2(self.redSquare2!)})
        let group = SKAction.group([createFirstSquare,createSecondSquare])
        self.run(group)
    }
    
    func level4Func() {
        
        levelIndex = "Level 4"
        if let musicURL = Bundle.main.url(forResource: "bgmusicLevel4", withExtension: "mp3") {
            backgroundMusic = SoundNode(url: musicURL)
            worldNode!.addChild(backgroundMusic)
            let fadeIn = SKAction._changeVolumeTo(endVolume: 1.0, duration: 2.0)
            backgroundMusic.run(fadeIn)
        }
        
        redSquare?.removeAllActions()
        redSquare?.removeFromParent()
        redSquare2?.removeAllActions()
        redSquare2?.removeFromParent()
        
        self.createIceCream()
    }
    
    func level5Func() {
        
        levelIndex = "Level 5"
        if let musicURL = Bundle.main.url(forResource: "bgmusicLevel5", withExtension: "mp3") {
            backgroundMusic = SoundNode(url: musicURL)
            worldNode!.addChild(backgroundMusic)
            let fadeIn = SKAction._changeVolumeTo(endVolume: 0.8, duration: 2.0)
            backgroundMusic.run(fadeIn)
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
        
        levelIndex = "Level 6"
        if let musicURL = Bundle.main.url(forResource: "bgmusicLevel6", withExtension: "mp3") {
            backgroundMusic = SoundNode(url: musicURL)
            worldNode!.addChild(backgroundMusic)
            let fadeIn = SKAction._changeVolumeTo(endVolume: 0.8, duration: 2.0)
            backgroundMusic.run(fadeIn)
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
        
        worldNode!.run(SKAction.repeatForever(sequence))
    }
    
    func endGame() {
        
        gameOver = true
        
        if let prevHighScores = UserDefaults.standard.array(forKey: "highScores") as? [Int] {
        
            if displayedScore >= prevHighScores.last! {
                gameEndAnimation(highScoreAchieved: true)
                
            } else {
                gameEndAnimation(highScoreAchieved: false)
            }
        } else {
            gameEndAnimation(highScoreAchieved: true)
        }
        
        
    }
    

    func gameEndAnimation(highScoreAchieved: Bool) {
        
        let congratsLabel = SKLabelNode(text: "GAME OVER")
        congratsLabel.zPosition = 1.0
        congratsLabel.fontColor = SKColor.orange
        congratsLabel.fontSize = 30
        congratsLabel.position = MID_POINT!
        congratsLabel.zPosition = 1
        congratsLabel.fontName = "AmericanTypewriter-Bold"
        worldNode!.addChild(congratsLabel)
        
        let colorizeLbl = SKAction.colorize(with: UIColor.green, colorBlendFactor: 0.67, duration: 1.0)
        let colorizeLbl2 = SKAction.colorize(with: UIColor.cyan, colorBlendFactor: 0.67, duration: 1.0)
        let colorizeLbl3 = SKAction.colorize(with: UIColor.orange, colorBlendFactor: 0.67, duration: 1.0)
        let lblColorSeq = SKAction.sequence([colorizeLbl,colorizeLbl2,colorizeLbl3])
        let lblGrow = SKAction.scale(to: 2, duration: 0.3)
        let lblShrink = SKAction.scale(to: 1, duration: 0.3)
        let lblGrowSeq = SKAction.repeat(SKAction.sequence([lblGrow,lblShrink]), count: 5)
        let lblGroup = SKAction.group([lblColorSeq,lblGrowSeq])
        congratsLabel.run(SKAction.repeatForever(lblGroup))
        
        if highScoreAchieved {
            let wait = SKAction.wait(forDuration: 1.5)
            let rotateLabel = SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0.2)
            let block = SKAction.run {
                congratsLabel.text = "HIGH SCORE!"
            }
            let seq = SKAction.sequence([wait,rotateLabel,block,rotateLabel])
            congratsLabel.run(seq)
            
            
        }
        
        //  MAKE MOUTH AND ICE CREAM DANCE
        
        mouthIsReady = false
        mouth = Mouth(imageNamed: "mouth1")
        mouth!.position = CGPoint(x: self.view!.bounds.width / 2, y: SCALE_MUL! * 1000)
        mouth!.setScale(SCALE_MUL! * 1.8)
        mouth!.alpha = 1.0
        worldNode!.addChild(mouth!)
        
        let danceAct = SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0.5))
        mouth!.run(danceAct)
        iceCream!.run(danceAct)
        
        //  MAKE EXPLOSIONS
        var explosionSeqArr: [SKAction] = []
        for _ in 0...40 {
            let randWaitTime = Double(arc4random_uniform(UInt32(100))) * 0.01
            let RandW = CGFloat(arc4random_uniform(UInt32(view!.bounds.width)))
            let RandH = CGFloat(arc4random_uniform(UInt32(view!.bounds.height)))
            let thisLoc = CGPoint(x: RandW, y: RandH)
            let wait = SKAction.wait(forDuration: randWaitTime)
            let block = SKAction.run {
                self.makeExplosion(location: thisLoc, endGame: true)
            }
            explosionSeqArr.append(wait)
            explosionSeqArr.append(block)
        }
        let seq = SKAction.sequence(explosionSeqArr)
        run(seq)
        
        //  BRING UP HIGH SCORES
        
        let wait = SKAction.wait(forDuration: 4.0)
        let block = SKAction.run {
            self.settingsNode?.bringUpHighScores(position: self.MID_POINT!, addScoreFlag: true)
        }
        let highScoreMenuSeq = SKAction.sequence([wait,block])
        run(highScoreMenuSeq)
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
        
        if (!self.intersects(mouth!)) {
            let clampPos = mouth!.position.clamped(rect: view!.bounds, x: mouth!.position.x, y: mouth!.position.y)
            popMouth(clampPos)
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
