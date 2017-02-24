//
//  GameScene.swift
//  SaveTheBird
//
//  Created by Daniel Peters on 06.08.15.
//  Copyright (c) 2015 Daniel Peters. All rights reserved.
//

import SpriteKit
import CoreMotion
import AVFoundation

class GameScene: SKScene {
    
    //Constant Values
    let Music_Defaults = UserDefaults.standard
    let Sound_Defaults = UserDefaults.standard
    let Level_Defaults = UserDefaults.standard
    let Credits_Defaults = UserDefaults.standard
    let XP_Defaults = UserDefaults.standard
    let Highscore_Defaults = UserDefaults.standard
    let GamesPlayed_Defaults = UserDefaults.standard
    let OverallScore_Defaults = UserDefaults.standard
    let EggNumber_Defaults = UserDefaults.standard
    let Lifes_Defaults = UserDefaults.standard
    let CreditsBooster_Defaults = UserDefaults.standard
    
    //Global Variables
    var Bird = SKSpriteNode()
    var birdAnimFrames = [SKTexture]()
    var Balls = [SKSpriteNode]()
    var GameOverBox = SKSpriteNode()
    var RetryButton = SKSpriteNode()
    var QuitButton = SKSpriteNode()
    var ReviveButton = SKSpriteNode()
    var PauseButton = SKSpriteNode()
    var ContinueButton = SKSpriteNode()
    var Clouds = [SKSpriteNode]()
    var Guns = [SKSpriteNode]()
    var GunSmoke = [Bool]()
    var lbl_Score = SKLabelNode()
    var lbl_Highscore = SKLabelNode()
    var lbl_ScoreGameOver = SKLabelNode()
    var lbl_GameOver = SKLabelNode()
    var lbl_Credits = SKLabelNode()
    var lbl_XP = SKLabelNode()
    var lbl_Eggs = SKLabelNode()
    var lbl_Info = SKLabelNode()
    var timerStarted = false
    var effects_executed = false
    var ballTimer: Timer?
    var Highscore = Int()
    var Score = Int()
    var GamesPlayed = Int()
    var OverallScore = Int()
    var GlobalCredits = Int()
    var GlobalXP = Int()
    var Level = Int()
    var Credits = Int()
    var XP = Int()
    var Pause = false
    var Eggs = 10
    var GameRunning = Bool()
    var Booster = Bool()
    var Lifes = Int()
    var Revived = Int()
    var motionManager = CMMotionManager()
    var destX:CGFloat = 0.0
    var birdAnimated = false
    var backMusic: AVAudioPlayer!
    
    //Particles
    let Explosion = NSKeyedUnarchiver.unarchiveObject(withFile: Bundle.main.path(forResource: "Explosion", ofType: "sks")!) as! SKEmitterNode
    let Smoke = NSKeyedUnarchiver.unarchiveObject(withFile: Bundle.main.path(forResource: "Smoke", ofType: "sks")!) as! SKEmitterNode
    let Fire = NSKeyedUnarchiver.unarchiveObject(withFile: Bundle.main.path(forResource: "Fire", ofType: "sks")!) as! SKEmitterNode
    let Snow = NSKeyedUnarchiver.unarchiveObject(withFile: Bundle.main.path(forResource: "Snow", ofType: "sks")!) as! SKEmitterNode
    
    func setupAudioPlayerWithFile(_ file:NSString, type:NSString) -> AVAudioPlayer  {
        let path = Bundle.main.path(forResource: file as String, ofType: type as String)
        let url = URL(fileURLWithPath: path!)
        var audioPlayer:AVAudioPlayer?
        
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: url)
        } catch {
            print("NO AUDIO PLAYER")
        }
        
        return audioPlayer!
    }
    
    override func willMove(from view: SKView) {
        if backMusic != nil {
            if backMusic.isPlaying {
                backMusic.stop()
            }
        }
    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        //Get Res
        let width = self.size.width
        let height = self.size.height
        
        //Play Music
        if (Music_Defaults.bool(forKey: "Music")) {
            backMusic = setupAudioPlayerWithFile("music_standard", type: "mp3")
            backMusic.play()
        }
        
        //Draw Basic Stuff
        GlobalFunctions().drawBackground(self)
        
        //Get Global Credits & XP
        Highscore = Highscore_Defaults.integer(forKey: "Highscore")
        GamesPlayed = GamesPlayed_Defaults.integer(forKey: "GamesPlayed")
        OverallScore = OverallScore_Defaults.integer(forKey: "OverallScore")
        Level = Level_Defaults.integer(forKey: "Level")
        GlobalCredits = Credits_Defaults.integer(forKey: "Credits")
        GlobalXP = XP_Defaults.integer(forKey: "XP")
        Eggs = EggNumber_Defaults.integer(forKey: "Eggs")
        Lifes = Lifes_Defaults.integer(forKey: "Lifes")
        Booster = CreditsBooster_Defaults.bool(forKey: "Booster")
        
        //Swipe Gestures
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(GameScene.respondToSwipeGesture(_:)))
        swipeDown.direction = UISwipeGestureRecognizerDirection.down
        self.view?.addGestureRecognizer(swipeDown)
        
        //Enable Gravity
        self.physicsWorld.gravity.dy = -9.81;
        
        //Draw Ball Cannons
        var Gun_xPos = [ width*0.2, width*0.5, width*0.8 ]
        for i in 0 ..< 3 {
            Guns.append(SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfGun(frame: CGRect(x: 0, y: 0, width: width/4.26, height: width/32)))))
            Guns[i].zPosition = 6.0
            Guns[i].position = CGPoint(x: Gun_xPos[i], y: height/5.48 + Guns[i].size.height*0.5)
            self.addChild(Guns[i])
        }
        
        //Draw PauseButton
        PauseButton = SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfPauseButton(frame: CGRect(x: 0, y: 0, width: width/12.8, height: width/9.85), toggleVisibility: false)))
        PauseButton.zPosition = 7.0
        PauseButton.position = CGPoint(x: width-PauseButton.size.width*0.75, y: height-PauseButton.size.height*0.75)
        PauseButton.alpha = 1.0
        PauseButton.name = "PauseButton"
        self.addChild(PauseButton)
        
        //Draw ContinueButton
        ContinueButton = SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfPauseButton(frame: CGRect(x: 0, y: 0, width: width/12.8, height: width/9.85), toggleVisibility: true)))
        ContinueButton.zPosition = 7.0
        ContinueButton.position = CGPoint(x: width-ContinueButton.size.width*0.75, y: height-ContinueButton.size.height*0.75)
        ContinueButton.alpha = 0.0
        ContinueButton.name = "ContinueButton"
        self.addChild(ContinueButton)
        
        //Draw Birdvar randBird = arc4random_uniform(10000) + 1
        let randColor = arc4random_uniform(4)
        let randBird = arc4random_uniform(10000) + 1
        var golden = false
        
        if (randBird == 1) {
            golden = true
        }
        
        //Create Texture Atlas for Bird
        var flyFrames = [SKTexture]()
        
        let texture_wing_down = SKTexture(image: StyleKitName.imageOfBird(frame: CGRect(x: 0, y: 0, width: width/6.4, height: width/7.52), golden: golden, colorInput: CGFloat(randColor), bird_wing_down: true, bird_wing_up: false))
        let texture_wing_mid = SKTexture(image: StyleKitName.imageOfBird(frame: CGRect(x: 0, y: 0, width: width/6.4, height: width/7.52), golden: golden, colorInput: CGFloat(randColor), bird_wing_down: false, bird_wing_up: false))
        let texture_wing_up = SKTexture(image: StyleKitName.imageOfBird(frame: CGRect(x: 0, y: 0, width: width/6.4, height: width/7.52), golden: golden, colorInput: CGFloat(randColor), bird_wing_down: false, bird_wing_up: true))
        
        flyFrames.append(texture_wing_down)
        flyFrames.append(texture_wing_mid)
        flyFrames.append(texture_wing_up)
        
        birdAnimFrames = flyFrames
        
        //Draw Bird
        Bird = SKSpriteNode(texture: texture_wing_down)
        Bird.zPosition = 6.0
        Bird.position = CGPoint(x: width*0.5, y: height*0.5)
        Bird.physicsBody = SKPhysicsBody(circleOfRadius: Bird.size.height*0.5)
        Bird.physicsBody?.affectedByGravity = true
        Bird.physicsBody?.mass = 0.02
        Bird.physicsBody?.isDynamic = false
        self.addChild(Bird)
        
        //Draw Score
        lbl_Score = SKLabelNode(fontNamed:"Chalkduster")
        lbl_Score.text = "Score: " + GlobalFunctions().formatNumber(Score)
        lbl_Score.fontSize = width*0.05
        lbl_Score.fontColor = UIColor(white: 0.0, alpha: 1.0)
        lbl_Score.position = CGPoint(x: width*0.5, y: height-PauseButton.size.height*0.5);
        self.addChild(lbl_Score)
        
        //Draw Highscore
        lbl_Highscore = SKLabelNode(fontNamed:"Chalkduster")
        lbl_Highscore.text = "Highscore: " + GlobalFunctions().formatNumber(Highscore)
        lbl_Highscore.fontSize = width*0.05
        lbl_Highscore.fontColor = UIColor(white: 0.0, alpha: 1.0)
        lbl_Highscore.position = CGPoint(x: width*0.5, y: height-PauseButton.size.height*1.2);
        self.addChild(lbl_Highscore)
        
        //Egg Label
        lbl_Eggs = SKLabelNode(fontNamed:"Chalkduster")
        lbl_Eggs.text = "Eggs: " + GlobalFunctions().formatNumber(Eggs)
        lbl_Eggs.fontSize = width*0.04
        lbl_Eggs.fontColor = UIColor(white: 0.0, alpha: 1.0)
        lbl_Eggs.zPosition = 11.0
        lbl_Eggs.position = CGPoint(x: lbl_Eggs.fontSize, y: Guns[0].position.y + lbl_Eggs.fontSize)
        lbl_Eggs.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.addChild(lbl_Eggs)
        
        //Draw Clouds
        var CloudPos = [ CGPoint(x: width*0.3, y: height*0.8), CGPoint(x: width*0.7, y: height*0.6), CGPoint(x: width*0.4, y: height*0.4) ]
        for i in 0 ..< 3 {
            Clouds.append(SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfCloud(frame: CGRect(x: 0, y: 0, width: width/2.5, height: width/5), textInput: "", textSize: 1))))
            Clouds[i].position = CloudPos[i]
            self.addChild(Clouds[i])
        }
        
        //GameOverBox
        GameOverBox = SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfBox(frame: CGRect(x: 0, y: 0, width: width*0.75, height: height*0.25))))
        GameOverBox.zPosition = 10.0
        GameOverBox.position = CGPoint(x: width*0.5, y: height*0.5)
        GameOverBox.alpha = 0.0
        self.addChild(GameOverBox)
        
        //Retry Button
        RetryButton = SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfButton(frame: CGRect(x: 0, y: 0, width: GameOverBox.size.width*0.4, height: GameOverBox.size.height*0.25), textInput: "Retry", textSize: width*0.05)))
        RetryButton.zPosition = 11.0
        RetryButton.position = CGPoint(x: GameOverBox.position.x + GameOverBox.size.width*0.25, y: GameOverBox.position.y - GameOverBox.size.height*0.3)
        RetryButton.alpha = 0.0
        self.addChild(RetryButton)
        
        //Quit Button
        QuitButton = SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfButton(frame: CGRect(x: 0, y: 0, width: GameOverBox.size.width*0.4, height: GameOverBox.size.height*0.25), textInput: "Quit", textSize: width*0.05)))
        QuitButton.zPosition = 11.0
        QuitButton.position = CGPoint(x: GameOverBox.position.x - GameOverBox.size.width*0.25, y: GameOverBox.position.y - GameOverBox.size.height*0.3)
        QuitButton.alpha = 0.0
        self.addChild(QuitButton)
        
        //Revive Button
        ReviveButton = SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfButton(frame: CGRect(x: 0, y: 0, width: GameOverBox.size.width*0.4, height: GameOverBox.size.height*0.15), textInput: "Revive ("+GlobalFunctions().formatNumber(Lifes)+" left)", textSize: width*0.02)))
        ReviveButton.zPosition = 11.0
        ReviveButton.position = CGPoint(x: GameOverBox.position.x - GameOverBox.size.width*0.25, y: GameOverBox.position.y - GameOverBox.size.height*0.075)
        ReviveButton.alpha = 0.0
        self.addChild(ReviveButton)
        
        //GameOver Label
        lbl_GameOver = SKLabelNode(fontNamed:"Chalkduster")
        lbl_GameOver.text = "Game Over!"
        lbl_GameOver.fontSize = width*0.06
        lbl_GameOver.fontColor = UIColor(white: 0.0, alpha: 1.0)
        lbl_GameOver.zPosition = 11.0
        lbl_GameOver.position = CGPoint(x: GameOverBox.position.x, y: GameOverBox.position.y + GameOverBox.size.width*0.15)
        lbl_GameOver.alpha = 0.0
        self.addChild(lbl_GameOver)
        
        //GameOver Label
        lbl_ScoreGameOver = SKLabelNode(fontNamed:"Chalkduster")
        lbl_ScoreGameOver.text = "Score: " + GlobalFunctions().formatNumber(Score)
        lbl_ScoreGameOver.fontSize = width*0.035
        lbl_ScoreGameOver.fontColor = UIColor(white: 0.0, alpha: 1.0)
        lbl_ScoreGameOver.zPosition = 11.0
        lbl_ScoreGameOver.position = CGPoint(x: GameOverBox.position.x - GameOverBox.size.width*0.25, y: GameOverBox.position.y + GameOverBox.size.height*0.03)
        lbl_ScoreGameOver.alpha = 0.0
        self.addChild(lbl_ScoreGameOver)
        
        //GameOver Label
        lbl_XP = SKLabelNode(fontNamed:"Chalkduster")
        lbl_XP.text = "XP: +" + GlobalFunctions().formatNumber(XP)
        lbl_XP.fontSize = width*0.03
        lbl_XP.fontColor = UIColor(white: 0.0, alpha: 1.0)
        lbl_XP.zPosition = 11.0
        lbl_XP.position = CGPoint(x: GameOverBox.position.x + GameOverBox.size.width*0.25, y: GameOverBox.position.y + GameOverBox.size.height*0.03)
        lbl_XP.alpha = 0.0
        self.addChild(lbl_XP)
        
        //GameOver Label
        lbl_Credits = SKLabelNode(fontNamed:"Chalkduster")
        lbl_Credits.text = "Credits: +" + GlobalFunctions().formatNumber(Credits)
        lbl_Credits.fontSize = width*0.03
        lbl_Credits.fontColor = UIColor(white: 0.0, alpha: 1.0)
        lbl_Credits.zPosition = 11.0
        lbl_Credits.position = CGPoint(x: GameOverBox.position.x + GameOverBox.size.width*0.25, y: GameOverBox.position.y - GameOverBox.size.height*0.1)
        lbl_Credits.alpha = 0.0
        self.addChild(lbl_Credits)
        
        //Info Label
        lbl_Info = SKLabelNode(fontNamed:"Chalkduster")
        lbl_Info.text = "Tap to fly, tilt to evade, swipe down to shoot"
        lbl_Info.fontSize = width*0.035
        lbl_Info.fontColor = UIColor(white: 0.0, alpha: 1.0)
        lbl_Info.zPosition = 11.0
        lbl_Info.position = CGPoint(x: width*0.5, y: Bird.position.y + Bird.size.height*2.5)
        lbl_Info.alpha = 1.0
        self.addChild(lbl_Info)
        
        //Motion Manager
        if motionManager.isAccelerometerAvailable == true {
            // 2
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler:{
                data, error in
                
                let currentX = self.Bird.position.x
                
                // 3
                if data!.acceleration.x < 0 {
                    self.destX = currentX + CGFloat(data!.acceleration.x * 250)
                }
                    
                else if data!.acceleration.x > 0 {
                    self.destX = currentX + CGFloat(data!.acceleration.x * 250)
                }
                
                //Move Bird Vertical
                if self.GameRunning {
                    self.Bird.run(SKAction.moveTo(x: self.destX, duration: 0.25))
                }
            })
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        //Touch buttons
        let transition = SKTransition.fade(withDuration: 1.0)
        for touch in (touches) {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if (node == PauseButton || node == ContinueButton || node == RetryButton || node == QuitButton || node == ReviveButton) {
                if node.name != "snow" {
                    node.run(SKAction.scale(to: 1.1, duration: TimeInterval(0.2)), completion: {
                        node.run(SKAction.scale(to: 1.0, duration: TimeInterval(0.2)), completion: {
                            if (node == self.PauseButton || node == self.ContinueButton && self.PauseButton.alpha == 1.0 && self.GameRunning) {
                                self.PauseButton.alpha = 0.0
                                self.ContinueButton.alpha = 1.0
                            
                                //Pause
                                self.Pause = true
                                self.physicsWorld.speed = 0.0
                                self.Bird.removeAllActions()
                            
                                if ((self.ballTimer?.isValid) != nil) {
                                    self.ballTimer!.invalidate()
                                    self.ballTimer = nil
                                    self.timerStarted = false
                                }
                            }
                            else if (node == self.ContinueButton || node == self.PauseButton && self.ContinueButton.alpha == 1.0 && self.GameRunning) {
                                self.PauseButton.alpha = 1.0
                                self.ContinueButton.alpha = 0.0
                            
                                //Unpause
                                self.Pause = false
                                self.physicsWorld.speed = 1.0
                                self.animateBird()
                                self.birdAnimated = true
                            
                                if (self.timerStarted == false) {
                                    self.ballTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameScene.shootBalls(_:)), userInfo: nil, repeats: true)
                                    self.timerStarted = true
                                }
                            }
                            else if (node == self.RetryButton && self.RetryButton.alpha == 1.0) {
                                self.resetGame()
                            }
                            else if (node == self.QuitButton && self.QuitButton.alpha == 1.0) {
                                //Load Main Menu
                                let scene = Menu_Main(size: self.scene!.size)
                                scene.scaleMode = SKSceneScaleMode.aspectFill
                                self.scene!.view!.presentScene(scene, transition: transition)
                            }
                            else if (node == self.ReviveButton && self.ReviveButton.alpha == 1.0) {
                                //Load Main Menu
                                self.reviveBird()
                            }
                        }) 
                    })
                }
            }
            else {
                //Start Timer
                if (self.timerStarted == false) {
                    self.ballTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(GameScene.shootBalls(_:)), userInfo: nil, repeats: true)
                    self.timerStarted = true
                    self.GameRunning = true
                    
                    lbl_Info.alpha = 0.0
                    self.destX = self.Bird.position.x
                }
                if (self.Pause == false) {
                    
                    //Bird start Animation
                    if(!birdAnimated) {
                        animateBird()
                        birdAnimated = true
                    }
                    //Bird enable physics
                    self.Bird.physicsBody?.isDynamic = true
                    
                    //Bird Apply Force
                    if self.Bird.isPaused == false {
                        self.Bird.physicsBody?.applyForce(CGVector(dx: 0, dy: 500))
                    }
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        if (GameRunning && !Pause) {
            //Get Res
            let width = self.size.width
            let height = self.size.height
            
            //Game Over
            if (Bird.position.y > height-Bird.size.height*0.5) {
                gameOver()
            }
            if (Bird.position.y < height/5.48 + Guns[0].size.height*0.5) {
                gameOver()
            }
            if (Bird.position.x > width-Bird.size.width*0.5) {
                gameOver()
            }
            if (Bird.position.x < Bird.size.width*0.5) {
                gameOver()
            }
        }
        
        
        //Check Music loop
        if (Music_Defaults.bool(forKey: "Music")) {
            if (backMusic.isPlaying == false) {
                backMusic.play()
            }
        }
    }
    
    func shootBalls(_ timer:Timer!) {
        if (!Pause) {
            //Get Res
            let width = self.size.width
            let height = self.size.height
            
            let randColor = arc4random_uniform(4)
            let randPos = arc4random_uniform(3)
            let randGold = arc4random_uniform(100000) + 1
            let randVecNegX = arc4random_uniform(2)
            let randVecX = arc4random_uniform(UInt32(height/64)) + 1
            let randVecY = arc4random_uniform(UInt32(height/32)) + 1
            var BallsVectorX = CGFloat()
            var BallsVectorY = CGFloat()
            var golden = false
            var BallsPos = CGPoint()
            
            //Check if Ball is golden
            if (randGold == 1) {
                golden = true
            }
            
            //Set X apply Force Vector
            if (randVecNegX == 0) {
                BallsVectorX = CGFloat(randVecX) * -1
            }
            
            //Set Y apply Force Vector
            BallsVectorY = CGFloat(randVecY) + (height*0.085)
            
            //Set Ball position
            if (randPos == 0) {
                BallsPos = CGPoint(x: width*0.2, y: Guns[0].position.y - width/6.4)
            }
            else if (randPos == 1) {
                BallsPos = CGPoint(x: width*0.5, y: Guns[0].position.y - width/6.4)
            }
            else if (randPos == 2) {
                BallsPos = CGPoint(x: width*0.8, y: Guns[0].position.y - width/6.4)
            }
            
            //Draw Balls
            Balls.append(SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfBall(frame: CGRect(x: 0, y: 0, width: width/6.4, height: width/6.4), golden: golden, colorInput: CGFloat(randColor)))))
            Balls[Balls.count-1].position = BallsPos
            Balls[Balls.count-1].physicsBody = SKPhysicsBody(circleOfRadius: Balls[Balls.count-1].size.width*0.5)
            Balls[Balls.count-1].physicsBody?.mass = 0.05
            Balls[Balls.count-1].zPosition = 1.0
            Balls[Balls.count-1].physicsBody?.affectedByGravity = true
            Balls[Balls.count-1].physicsBody?.isDynamic = true
            
            self.addChild(Balls[Balls.count-1])
            
            //Shoot Balls
            Balls[Balls.count-1].physicsBody?.applyImpulse(CGVector(dx: BallsVectorX, dy: BallsVectorY))
            
            //Add Animation at Cannon
            GlobalFunctions().drawFire(self, pos:Guns[Int(randPos)].position, duration:1.0)
            GlobalFunctions().drawSmoke(self, pos:Guns[Int(randPos)].position, duration:0.5)
            
            //Ball Shot Sound
            if (Sound_Defaults.bool(forKey: "Sound")) {
                run(SKAction.playSoundFileNamed("Ball_Shot.wav", waitForCompletion: false))
            }
            
            //Update Score
            Score += 1
            lbl_Score.text = "Score: " + GlobalFunctions().formatNumber(Score)
            
            if Score >= Highscore {
                lbl_Highscore.text = "New Highscore!"
            }
        }
    }

    
    func gameOver() {
        GameRunning = false
        Pause = false
        birdAnimated = false
        
        destX = Bird.position.x
        
        Bird.physicsBody?.isDynamic = false
        Bird.removeAllActions()
        
        for i in 0 ..< Balls.count {
            Balls[i].physicsBody?.isDynamic = false
            Balls[i].removeAllChildren()
        }
        
        if ((ballTimer?.isValid) != nil) {
            ballTimer!.invalidate()
            ballTimer = nil
        }
        //Effects
        if (effects_executed == false){
            Explosion.position = Bird.position
            addChild(Explosion)
            
            Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(GameScene.removeParticles(_:)), userInfo: nil, repeats: false)

            effects_executed = true
        }
        
        //Remove Bird & Ball
        Bird.removeFromParent()
        
        for i in 0 ..< Balls.count {
            Balls[i].removeFromParent()
        }
        
        //Change Alpha
        GameOverBox.alpha = 1.0
        RetryButton.alpha = 1.0
        QuitButton.alpha = 1.0
        RetryButton.alpha = 1.0
        lbl_ScoreGameOver.alpha = 1.0
        lbl_GameOver.alpha = 1.0
        lbl_Credits.alpha = 1.0
        lbl_XP.alpha = 1.0
        
        if (Revived < 3 && Lifes > 0) {
            ReviveButton.alpha = 1.0
        }
        
        //Reset Eggs
        Eggs = EggNumber_Defaults.integer(forKey: "Eggs")
        
        //Calculate XP & Credits
        if Booster {
            Credits = Score * 10 * 2
        } else {
            Credits = Score * 10
        }
        XP = Int(ceil(CGFloat(Score) * 10 * CGFloat(1.00 + (CGFloat(GlobalFunctions().Level)*0.01))))
        
        //Update Highscore
        if Score > Highscore {
            Highscore = Score
            Highscore_Defaults.set(Highscore, forKey: "Highscore")
        }
        
        //Update Stats
        GamesPlayed += 1
        OverallScore += Score
        GamesPlayed_Defaults.set(GamesPlayed, forKey: "GamesPlayed")
        OverallScore_Defaults.set(OverallScore, forKey: "OverallScore")
        
        //Update Text
        lbl_ScoreGameOver.text = "Score: " + GlobalFunctions().formatNumber(Score)
        lbl_XP.text = "XP: +" + GlobalFunctions().formatNumber(XP)
        lbl_Credits.text = "Credits: +" + GlobalFunctions().formatNumber(Credits)
        
        //Save Credits & XP
        GlobalCredits += Credits
        GlobalXP += XP
        
        Credits_Defaults.set(GlobalCredits, forKey: "Credits")
        XP_Defaults.set(GlobalXP, forKey: "XP")
    }
    
    func reviveBird() {
        if Revived < 3 && Lifes > 0 {
            //Change Alpha
            GameOverBox.alpha = 0.0
            RetryButton.alpha = 0.0
            QuitButton.alpha = 0.0
            RetryButton.alpha = 0.0
            ReviveButton.alpha = 0.0
            lbl_ScoreGameOver.alpha = 0.0
            lbl_GameOver.alpha = 0.0
            lbl_Credits.alpha = 0.0
            lbl_XP.alpha = 0.0
            
            //reset Timer variable
            timerStarted = false
            
            //Reset Bird
            self.addChild(Bird)
            Bird.zRotation = 0.0
            Bird.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
            
            //Reset Effects
            effects_executed = false
            
            //Increase Revived
            Revived += 1
            
            //Decrease Lifes
            Lifes -= 1
            self.Lifes_Defaults.set(Lifes, forKey: "Lifes")
            
            //Update Revive Button
            ReviveButton.removeAllChildren()
            ReviveButton.removeFromParent()
            
            ReviveButton = SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfButton(frame: CGRect(x: 0, y: 0, width: GameOverBox.size.width*0.4, height: GameOverBox.size.height*0.15), textInput: "Revive ("+GlobalFunctions().formatNumber(Lifes)+" left)", textSize: self.size.width*0.02)))
            ReviveButton.zPosition = 11.0
            ReviveButton.position = CGPoint(x: GameOverBox.position.x - GameOverBox.size.width*0.25, y: GameOverBox.position.y - GameOverBox.size.height*0.075)
            ReviveButton.alpha = 0.0
            self.addChild(ReviveButton)
        }
        else {
            resetGame()
        }
    }
    
    func resetGame() {
        //Change Alpha
        GameOverBox.alpha = 0.0
        RetryButton.alpha = 0.0
        QuitButton.alpha = 0.0
        RetryButton.alpha = 0.0
        ReviveButton.alpha = 0.0
        lbl_ScoreGameOver.alpha = 0.0
        lbl_GameOver.alpha = 0.0
        lbl_Credits.alpha = 0.0
        lbl_XP.alpha = 0.0
        
        //Update Text
        Score = 0
        lbl_Score.text = "Score: " + GlobalFunctions().formatNumber(Score)
        lbl_Highscore.text = "Highscore: " + GlobalFunctions().formatNumber(Highscore)
        lbl_Eggs.text = "Eggs: " + GlobalFunctions().formatNumber(Eggs)
        
        //reset Timer variable
        timerStarted = false
        
        //Reset Bird
        self.addChild(Bird)
        Bird.zRotation = 0.0
        Bird.position = CGPoint(x: self.size.width*0.5, y: self.size.height*0.5)
        
        //Reset Effects
        effects_executed = false
        
        //Reset Revived
        Revived = 0
    }
    
    func animateBird() {
        Bird.run(SKAction.repeatForever(SKAction.animate(with: birdAnimFrames, timePerFrame: 0.075)))
    }
    
    func removeParticles(_ timer:Timer!) {
        Explosion.removeFromParent()
    }
    
    func shootEgg(_ Node:SKSpriteNode) {
        if Eggs > 0 {
            let Egg = SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfEgg(frame: CGRect(x: 0, y: 0, width: self.size.width/10.5, height: self.size.width/7.5))))
            Egg.zPosition = 4.0
            Egg.position = CGPoint(x: Bird.position.x, y: Bird.position.y - Egg.size.height*0.25)
            Egg.physicsBody = SKPhysicsBody(circleOfRadius: Egg.size.width*0.5)
            Egg.physicsBody?.affectedByGravity = true
            Egg.physicsBody?.mass = 0.015
            Egg.physicsBody?.isDynamic = true
            self.addChild(Egg)
            
            Eggs -= 1
            lbl_Eggs.text = "Eggs: " + GlobalFunctions().formatNumber(Eggs)
        }
    }
    
    func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if swipeGesture.direction == UISwipeGestureRecognizerDirection.down && GameRunning {
                shootEgg(Bird)
            }
        }
    }
}
