//
//  Menu_Main.swift
//  SaveTheBird
//
//  Created by Daniel Peters on 06.08.15.
//  Copyright (c) 2015 Daniel Peters. All rights reserved.
//

import SpriteKit

class Menu_Main: SKScene {
    
    //Constants
    let NotFirstStart_Defaults = UserDefaults.standard
    let Music_Defaults = UserDefaults.standard
    let Sound_Defaults = UserDefaults.standard
    let Premium_Defaults = UserDefaults.standard
    let CreditsBooster_Defaults = UserDefaults.standard
    let RemovedAds_Defaults = UserDefaults.standard
    let Level_Defaults = UserDefaults.standard
    let Credits_Defaults = UserDefaults.standard
    let XP_Defaults = UserDefaults.standard
    let Highscore_Defaults = UserDefaults.standard
    let GamesPlayed_Defaults = UserDefaults.standard
    let OverallScore_Defaults = UserDefaults.standard
    let EggNumber_Defaults = UserDefaults.standard
    let CreditsBank_Defaults = UserDefaults.standard
    let InterestRate_Defaults = UserDefaults.standard
    let BankEnabled_Defaults = UserDefaults.standard
    let Lifes_Defaults = UserDefaults.standard
    let BankUpgraded_Defaults = UserDefaults.standard
    let StoredDate_Defaults = UserDefaults.standard
    let DailyBonusDate_Defaults = UserDefaults.standard
    let DailyRewardGiven_Defaults = UserDefaults.standard
    let DailyLastDay_Defaults = UserDefaults.standard
    let DailyBonus = [100, 1000, 10000]

    //Global Variables
    var notFirstStart = Bool()
    var Level = 1
    var GlobalCredits = Int()
    var GlobalXP = Int()
    var lbl_Credits = SKLabelNode()
    var DailyBonusBar = SKSpriteNode()
    var DailyBonusIcons = [SKSpriteNode]()
    var Credits = Int()
    var DailyBonusDate = NSDate()
    var DailyCombo = 0
    var DailyRewardGiven = true
    var RewardMsg = String()
    var DailyLastDay = Int()
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        //Check if first start
        notFirstStart = NotFirstStart_Defaults.bool(forKey: "NotFirstStart")
        
        let iCloudKeyStore: NSUbiquitousKeyValueStore? = NSUbiquitousKeyValueStore()
        let notFirstStartCloud = iCloudKeyStore?.bool(forKey: "NotFirstStart")
        
        //Game hasn't been started yet
        if (notFirstStart == false && notFirstStartCloud == false) {
            print("First Start!")
            self.NotFirstStart_Defaults.set(true, forKey: "NotFirstStart")
            
            //Set Default Stuff
            self.Highscore_Defaults.set(0, forKey: "Highscore")
            self.GamesPlayed_Defaults.set(0, forKey: "GamesPlayed")
            self.OverallScore_Defaults.set(0, forKey: "OverallScore")
            self.Level_Defaults.set(1, forKey: "Level")
            self.Credits_Defaults.set(0, forKey: "Credits")
            self.XP_Defaults.set(0, forKey: "XP")
            self.EggNumber_Defaults.set(10, forKey: "Eggs")
            self.Lifes_Defaults.set(0, forKey: "Lifes")
            self.CreditsBank_Defaults.set(0, forKey: "CreditsBank")
            self.InterestRate_Defaults.set(5, forKey: "InterestRate")
            self.BankEnabled_Defaults.set(false, forKey: "BankEnabled")
            self.BankUpgraded_Defaults.set(0, forKey: "BankUpgraded")
            self.StoredDate_Defaults.set(NSDate(), forKey: "StoredDate")
            self.DailyBonusDate_Defaults.set(NSDate(), forKey: "DailyBonus")
            self.DailyRewardGiven_Defaults.set(false, forKey: "DailyRewardGiven")
            self.DailyLastDay_Defaults.set(0, forKey: "DailyLastDay")
            
            //Enable Music & Sound for start
            self.Music_Defaults.set(true, forKey: "Music")
            self.Sound_Defaults.set(true, forKey: "Sound")
            
            //Enable Ads for start
            self.RemovedAds_Defaults.set(false, forKey: "RemoveAds")
            
            //Disable Booster & Premium
            self.Premium_Defaults.set(false, forKey: "Premium")
            self.CreditsBooster_Defaults.set(false, forKey: "Booster")
        }
            
        else if notFirstStart == false && notFirstStartCloud == true {
            print("First Start, but iCloud data exists. Loading data.")
            
            NotFirstStart_Defaults.set(iCloudKeyStore?.bool(forKey: "NotFirstStart"), forKey: "NotFirstStart")
            Music_Defaults.set(iCloudKeyStore?.bool(forKey: "Music"), forKey: "Music")
            Sound_Defaults.set(iCloudKeyStore?.bool(forKey: "Sound"), forKey: "Sound")
            Premium_Defaults.set(iCloudKeyStore?.bool(forKey: "Premium"), forKey: "Premium")
            CreditsBooster_Defaults.set(iCloudKeyStore?.bool(forKey: "Booster"), forKey: "Booster")
            RemovedAds_Defaults.set(iCloudKeyStore?.bool(forKey: "RemoveAds"), forKey: "RemoveAds")
            Level_Defaults.set(iCloudKeyStore?.double(forKey: "Level"), forKey: "Level")
            Credits_Defaults.set(iCloudKeyStore?.double(forKey: "Credits"), forKey: "Credits")
            XP_Defaults.set(iCloudKeyStore?.double(forKey: "XP"), forKey: "XP")
            Highscore_Defaults.set(iCloudKeyStore?.double(forKey: "Highscore"), forKey: "Highscore")
            GamesPlayed_Defaults.set(iCloudKeyStore?.double(forKey: "GamesPlayed"), forKey: "GamesPlayed")
            OverallScore_Defaults.set(iCloudKeyStore?.double(forKey: "OverallScore"), forKey: "OverallScore")
            EggNumber_Defaults.set(iCloudKeyStore?.double(forKey: "Eggs"), forKey: "Eggs")
            CreditsBank_Defaults.set(iCloudKeyStore?.double(forKey: "CreditsBank"), forKey: "CreditsBank")
            InterestRate_Defaults.set(iCloudKeyStore?.double(forKey: "InterestRate"), forKey: "InterestRate")
            BankEnabled_Defaults.set(iCloudKeyStore?.bool(forKey: "BankEnabled"), forKey: "BankEnabled")
            Lifes_Defaults.set(iCloudKeyStore?.double(forKey: "Lifes"), forKey: "Lifes")
            BankUpgraded_Defaults.set(iCloudKeyStore?.double(forKey: "BankUpgraded"), forKey: "BankUpgraded")
            StoredDate_Defaults.set(NSDate(), forKey: "StoredDate")
            DailyBonusDate_Defaults.set(NSDate(), forKey: "DailyBonus")
            DailyRewardGiven_Defaults.set(false, forKey: "DailyRewardGiven")
            DailyLastDay_Defaults.set(0, forKey: "DailyLastDay")
        }
        
        //Check if iPad
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            let alert = UIAlertController(title: "Warning", message: "SaveTheBird doesn't support iPad, you need an iPhone or iPod touch to play it.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Exit", style: UIAlertActionStyle.default)  { _ in
                exit(0)
                })
            
            // Show the alert
            self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
        
        //Get Res
        let width = self.size.width
        let height = self.size.height
        
        GlobalFunctions().drawBackground(self)
        GlobalFunctions().drawMenuOverlay(self, SelectedMenuBar: 0)
        
        //Draw Credits Label
        Credits = Credits_Defaults.integer(forKey: "Credits")
        
        lbl_Credits = SKLabelNode(fontNamed:"Chalkduster")
        lbl_Credits.text = "Credits: " + GlobalFunctions().formatNumber(Credits)
        lbl_Credits.fontSize = width*0.035
        lbl_Credits.fontColor = UIColor(white: 0.0, alpha: 1.0)
        lbl_Credits.position = CGPoint(x:width*0.5, y: height-width*0.075)
        self.addChild(lbl_Credits)
        
        let Singleplayer = SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfCloud(frame: CGRect(x: 0, y: 0, width: width/2.5, height: width/5), textInput: "Play!", textSize: width*0.035)))
        Singleplayer.position = CGPoint(x: width*0.5, y: height*0.5)
        Singleplayer.name = "Singleplayer"
        self.addChild(Singleplayer)
        
        //Get Bonus Date
        DailyBonusDate = DailyBonusDate_Defaults.object(forKey: "DailyBonus") as! NSDate
        DailyLastDay = DailyLastDay_Defaults.integer(forKey: "DailyLastDay") //Get LastDay where Game was open
        DailyRewardGiven = DailyRewardGiven_Defaults.bool(forKey: "DailyRewardGiven")
        
        let oldDay = dateToDay(date: DailyBonusDate)
        let curDay = dateToDay(date: NSDate())
        
        //First Start: init DailyLastDay
        if DailyLastDay == 0 {
            DailyLastDay = curDay
        }
        
        //Calculate DailyCombo
        if curDay - DailyLastDay == 1 && DailyCombo < 4{ //Letzter Besuch: Gestern
            DailyCombo = curDay - oldDay
            DailyRewardGiven = false
        }
        else if curDay - DailyLastDay != 0 { //Letzter Besuch: Länger her und nicht heute -> Combo wird zurückgesetzt
            DailyCombo = 0
            DailyRewardGiven = false
            DailyBonusDate = NSDate()
            DailyBonusDate_Defaults.set(NSDate(), forKey: "DailyBonus")
        }
        
        //Update Last Day
        DailyLastDay = curDay
        DailyLastDay_Defaults.set(DailyLastDay, forKey: "DailyLastDay")
        
        //Give Credits
        var Eggs = EggNumber_Defaults.integer(forKey: "Eggs")
        var Lifes = Lifes_Defaults.integer(forKey: "Lifes")
        
        if !DailyRewardGiven {
            switch DailyCombo {
            case -1:
                break
            case 0:
                Credits += 100
                updateCredits()
                RewardMsg = "100 Credits"
            case 1:
                Credits += 1000
                updateCredits()
                RewardMsg = "1,000 Credits"
            case 2:
                Credits += 10000
                updateCredits()
                RewardMsg = "10,000 Credits"
            case 3:
                let randItem = arc4random_uniform(4)
                if randItem > 0 {
                    RewardMsg = "1 extra life"
                    Lifes += 1
                    Lifes_Defaults.set(Lifes, forKey: "Lifes")
                } else {
                    RewardMsg = "1 bonus egg"
                    Eggs += 1
                    self.EggNumber_Defaults.set(Eggs, forKey: "Eggs")
                }
            default:
                let randItem = arc4random_uniform(4)
                if randItem > 0 {
                    RewardMsg = "1 extra life"
                    Lifes += 1
                    Lifes_Defaults.set(Lifes, forKey: "Lifes")
                } else {
                    RewardMsg = "1 bonus egg"
                    Eggs += 1
                    self.EggNumber_Defaults.set(Eggs, forKey: "Eggs")
                }
            }
            
            DailyRewardGiven = true
            DailyRewardGiven_Defaults.set(DailyRewardGiven, forKey: "DailyRewardGiven")
            
            //Show Daily Combo Msg
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(showDailyMsg(_:)), userInfo: nil, repeats: false)
        }
        
        //Draw Daily Bonus Bar
        for i in 0 ..< 4 {
            var bonus_str = String()
            var bonus_days = String()
            
            if i < 3 {
                bonus_str = GlobalFunctions().formatNumber(DailyBonus[i]) + " Credits"
                bonus_days = "Day: " + String(i+1)
            } else {
                bonus_str = "Secret Item"
                bonus_days = "Day: " + String(i+1) + "+"
            }
            
            //Draw MenuBar
            DailyBonusIcons.append(SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfDailyTab(frame: CGRect(x: 0, y: 0, width: width*0.25, height: height*0.1), isSelected: true, textSize: height*0.015, bonus_str: bonus_str, bonus_days: bonus_days))))
            DailyBonusIcons[i].position = CGPoint(x: width * 0.125 + width * 0.25 * CGFloat(i), y: height*0.75)
            DailyBonusIcons[i].zPosition = 1.0
            self.addChild(DailyBonusIcons[i])
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        //Create transitions
        let menu_transition = SKTransition.reveal(with: SKTransitionDirection.down, duration: 0.5)
        let transition = SKTransition.fade(withDuration: 1.0)
        
        for touch in (touches ) {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if node.name != "snow" {
                node.run(SKAction.scale(to: 1.1, duration: TimeInterval(0.1)), completion: {
                    node.run(SKAction.scale(to: 1.0, duration: TimeInterval(0.1)), completion: {
                        if (node.name == "MenuBar_1") {
                            let scene = Menu_Store(size: self.scene!.size)
                            scene.scaleMode = SKSceneScaleMode.aspectFill
                            //self.scene!.view!.presentScene(scene, transition: menu_transition)
                            self.view?.presentScene(scene, transition: menu_transition)
                        }
                        else if (node.name == "MenuBar_2") {
                            let scene = Menu_Bank(size: self.scene!.size)
                            scene.scaleMode = SKSceneScaleMode.aspectFill
                            self.view?.presentScene(scene, transition: menu_transition)
                        }
                        else if (node.name == "MenuBar_3") {
                            let scene = Menu_Scores(size: self.scene!.size)
                            scene.scaleMode = SKSceneScaleMode.aspectFill
                            self.view?.presentScene(scene, transition: menu_transition)
                        }
                        else if (node.name == "Singleplayer") {
                            let scene = GameScene(size: self.scene!.size)
                            scene.scaleMode = SKSceneScaleMode.aspectFill
                            self.view?.presentScene(scene, transition: transition)
                        }
                        else if (node.name == "SettingsButton") {
                            let scene = Menu_Settings(size: self.scene!.size)
                            scene.scaleMode = SKSceneScaleMode.aspectFill
                            self.view?.presentScene(scene, transition: transition)
                        }
                        else if (node.name == "InfoButton") {
                            let alert = UIAlertController(title: "Info", message: "If you need any help or support, contact me on my website.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)  { _ in
                                })
                            
                            alert.addAction(UIAlertAction(title: "Support", style: UIAlertActionStyle.default) { _ in
                                UIApplication.shared.openURL(URL(string:"http://tapadventures.com/")!)
                                })
                            
                            alert.addAction(UIAlertAction(title: "More Apps", style: UIAlertActionStyle.default) { _ in
                                UIApplication.shared.openURL(URL(string:"https://itunes.apple.com/us/developer/id1031269581")!)
                                })
                            
                            // Show the alert
                            self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
                        }
                    }) 
                }) 
            }
        }
    }
    
    func dateToDay(date: NSDate) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: date as Date)
        let day = components.day
        return Int(day!)
    }
    
    func showDailyMsg(_ timer:Timer!) {
        let alert_msg = "You get rewards for returning daily! Current Combo: " + String(DailyCombo+1) + " Day(s), will reset every month. You received " + RewardMsg + "."
        let alert = UIAlertController(title: "Daily Bonus", message: alert_msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Great!", style: UIAlertActionStyle.default)  { _ in
        })
        
        // Show the alert
        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func updateCredits() {
        self.Credits_Defaults.set(self.Credits, forKey: "Credits")
        self.lbl_Credits.text = "Credits: " + GlobalFunctions().formatNumber(self.Credits)
    }
}
