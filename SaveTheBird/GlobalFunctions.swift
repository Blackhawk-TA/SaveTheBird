//
//  GlobalFunctions.swift
//  SaveTheBird
//
//  Created by Daniel Peters on 06.08.15.
//  Copyright (c) 2015 Daniel Peters. All rights reserved.
//

import SpriteKit

open class GlobalFunctions : NSObject {
    //Constant Values
    let Level_Defaults = UserDefaults.standard
    let Credits_Defaults = UserDefaults.standard
    let XP_Defaults = UserDefaults.standard
    
    //Public Variables !!!KÖNNEN NICHT HIER AUSGELAGERT WERDEN USE NSUSERDEFAULTS!!!
    var isWinter = false
    var Credits = 0
    var Level = 1
    var XP = 0
    var Highscore = 0
    var SettingsName = "SettingsButton"
    var InfoName = "InfoButton"
    var MenuName = ["MenuBar_0", "MenuBar_1", "MenuBar_2", "MenuBar_3"]
    var Guns = [SKSpriteNode]()
    var CurMonth = 0
    //var BoostValue = 1.00 + (CGFloat(Level)*0.01)
    
    func setWinterMode() {
        let date = Date()
        CurMonth = (Calendar.current as NSCalendar).component(.month, from: date)
        
        if (CurMonth > 11) || (CurMonth > 0 && CurMonth < 3) {
            isWinter = true
        }
        else {
            isWinter = false
        }
    }
    
    //Format Large Numbers
    func formatNumber(_ Number: Int) -> String {
        var NumString = String(Number)
        
        if (Number >= 1000) {
            var NumLength = NumString.characters.count
            
            while NumLength > 3 {
                NumString.insert(",", at: NumString.characters.index(NumString.startIndex, offsetBy: NumLength-3))
                NumLength = NumLength - 3
            }
        }
        return NumString
    }
    
    func formatSeconds(seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, seconds % 60)
    }
    
    func calculateLevel() {
        //Get Variables
        Level = Level_Defaults.integer(forKey: "Level")
        XP = XP_Defaults.integer(forKey: "XP")
        
        //Variables
        let XPNeeded = Level * Level * 100
        
        if Level < 100 {
            if XP == XPNeeded {
                XP = 0
                Level += 1
                Level_Defaults.set(Level, forKey: "Level")
                XP_Defaults.set(XP, forKey: "XP")
            }
            else if XP > XPNeeded {
                XP -= XPNeeded
                Level += 1
                Level_Defaults.set(Level, forKey: "Level")
                XP_Defaults.set(XP, forKey: "XP")
            }
        }
    }
    
    func drawBackground(_ Scene: SKScene) {
        
        //Get Res
        let width = Scene.size.width
        let height = Scene.size.height
        
        //Set Background Color
        Scene.backgroundColor = StyleKitName.sky
        
        //Get Winter Value
        setWinterMode()
        
        //Draw Bottom Image
        let Bottom = SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfBottom(frame: CGRect(x: 0, y: 0, width: width, height: height/5.48), isWinter: isWinter)))
        Bottom.position = CGPoint(x: width*0.5, y: Bottom.size.height*0.5)
        Bottom.zPosition = 5.0
        Scene.addChild(Bottom)
        
        //Add Snow
        if (isWinter) {
            let emitterNode = SKEmitterNode(fileNamed: "Snow.sks")
            emitterNode!.particlePosition = CGPoint(x: width*0.5, y: height+50)
            emitterNode!.name = "snow"
            Scene.addChild(emitterNode!)
        }
        
        //Calculate Level
        calculateLevel()
    }
    
    func drawGuns(_ Scene: SKScene) {
        
        //Get Res
        let width = Scene.size.width
        let height = Scene.size.height
        
        //Draw Balls Cannons
        var Gun_xPos = [ width*0.2, width*0.5, width*0.8 ]
        for i in 0 ..< 3 {
            Guns.append(SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfGun(frame: CGRect(x: 0, y: 0, width: width/4.26, height: width/32)))))
            Guns[i].zPosition = 6.0
            Guns[i].position = CGPoint(x: Gun_xPos[i], y: height/5.48 + Guns[i].size.height*0.5)
            Scene.addChild(Guns[i])
        }
    }
    
    func drawMenuOverlay(_ Scene: SKScene, SelectedMenuBar: Int ) {
        
        //Get Credits & XP
        Level = Level_Defaults.integer(forKey: "Level")
        XP = XP_Defaults.integer(forKey: "XP")
        
        //Get Res
        let width = Scene.size.width
        let height = Scene.size.height
        
        //Scale Button
        let ButtonScale = width*0.15
        
        //Draw Settings Buttons
        let SettingsButton = SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfMenuIcon(frame: CGRect(x: 0, y: 0, width: ButtonScale, height: ButtonScale), toggleVisibility: true)))
        SettingsButton.position = CGPoint(x: SettingsButton.size.width*0.75, y: height-SettingsButton.size.height*0.75)
        SettingsButton.zPosition = 1.0
        SettingsButton.name = SettingsName
        Scene.addChild(SettingsButton)
        
        let InfoButton = SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfMenuIcon(frame: CGRect(x: 0, y: 0, width: ButtonScale, height: ButtonScale), toggleVisibility: false)))
        InfoButton.position = CGPoint(x: width-InfoButton.size.width*0.75, y: height-InfoButton.size.height*0.75)
        InfoButton.zPosition = 1.0
        InfoButton.name = InfoName
        Scene.addChild(InfoButton)
        
        //Draw Bird
        let randBird = arc4random_uniform(10000) + 1
        let randColor = arc4random_uniform(4)
        let randPos = arc4random_uniform(UInt32(width-150)) + 120
        var golden = false
        
        if (randBird == 1) {
            golden = true
        }
        
        let Bird = SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfBird(frame: CGRect(x: 0, y: 0, width: width/6.4, height: width/7.52), golden: golden, colorInput: CGFloat(randColor), bird_wing_down: true, bird_wing_up: false)))
        Bird.zPosition = 6.0
        Bird.position = CGPoint(x: CGFloat(randPos), y: height/5.48 + Bird.size.height*0.4)
        Scene.addChild(Bird)
        
        //MenuBar
        var MenuBar = [SKSpriteNode]()
        
        for i in 0 ..< 4 {
            
            //Check if selected
            var isSelected = false
            if (i==SelectedMenuBar) {
                isSelected = true
            }
            
            //Draw MenuBar
            MenuBar.append(SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfMenuBar(frame: CGRect(x: 0, y: 0, width: width*0.25, height: width/7.11), isSelected: isSelected, menuBarIcon: CGFloat(i)))))
            MenuBar[i].position = CGPoint(x: width * 0.125 + width * 0.25 * CGFloat(i), y: SettingsButton.position.y - SettingsButton.size.height*0.75 - MenuBar[0].size.height*0.5)
            MenuBar[i].zPosition = 10.0
            MenuBar[i].name = MenuName[i]
            Scene.addChild(MenuBar[i])
        }
        
        //Draw Level Progressbar
        let LevelBar = SKSpriteNode(texture: SKTexture(image: XPBarKit.imageOfXPBar(frame: CGRect(x: 0, y: 0, width: width, height: width/29.1), xP: CGFloat(XP), level: CGFloat(Level))))
        LevelBar.position = CGPoint(x: LevelBar.size.width*0.5, y: MenuBar[0].position.y - MenuBar[0].size.height*0.5 - LevelBar.size.height*0.5)
        LevelBar.zPosition = 10
        Scene.addChild(LevelBar)
        
        //Draw XP Boost Label
        let xpboost_str = String(describing: 1.00 + (CGFloat(Level)*0.01))
        let lbl_xpboost = SKLabelNode(fontNamed:"Chalkduster")
        lbl_xpboost.text = "XP-Boost: " + xpboost_str + " (Level " + formatNumber(Level) + ")"
        lbl_xpboost.fontSize = width*0.035
        lbl_xpboost.fontColor = UIColor(white: 0.0, alpha: 1.0)
        lbl_xpboost.position = CGPoint(x: width*0.5, y: height-SettingsButton.size.height);
        Scene.addChild(lbl_xpboost)
    }
    
    func drawSmoke(_ Scene: SKScene, pos: CGPoint, duration: Double) {
        let emitterNode = SKEmitterNode(fileNamed: "Smoke.sks")
        emitterNode!.particlePosition = pos
        emitterNode!.zPosition = 0.0
        Scene.addChild(emitterNode!)
        // Don’t forget to remove the emitter node after the explosion
        Scene.run(SKAction.wait(forDuration: duration), completion: { emitterNode!.removeFromParent() })
    }
    func drawFire(_ Scene: SKScene, pos: CGPoint, duration: Double) {
        let emitterNode = SKEmitterNode(fileNamed: "Fire.sks")
        emitterNode!.particlePosition = pos
        emitterNode!.zPosition = 0.0
        Scene.addChild(emitterNode!)
        // Don’t forget to remove the emitter node after the explosion
        Scene.run(SKAction.wait(forDuration: duration), completion: { emitterNode!.removeFromParent() })
    }
    
    func notifyBar(_ Scene: SKScene, Text: String, FontSize: CGFloat) {
        let notify = SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfNotificationBar(frame: CGRect(x: 0, y:0, width: Scene.size.width, height: Scene.size.height*0.075), textInput: Text, textSize: FontSize)))
        notify.position = CGPoint(x: Scene.size.width*0.5, y: Scene.size.height - Scene.size.height*0.0375)
        notify.zPosition = 1000
        notify.alpha = 1.0
        Scene.addChild(notify)
    }
    
}
