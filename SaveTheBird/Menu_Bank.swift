//
//  Menu_Bank.swift
//  SaveTheBird
//
//  Created by Daniel Peters on 06.08.15.
//  Copyright (c) 2015 Daniel Peters. All rights reserved.
//

import SpriteKit

class Menu_Bank: SKScene {
    
    //Constants
    let BankEnabled_Defaults = UserDefaults.standard
    let Credits_Defaults = UserDefaults.standard
    let CreditsBank_Defaults = UserDefaults.standard
    let InterestRate_Defaults = UserDefaults.standard
    let StoredDate_Defaults = UserDefaults.standard
    
    //Variables
    var btn_add = SKSpriteNode()
    var btn_add_all = SKSpriteNode()
    var btn_sub = SKSpriteNode()
    var btn_sub_all = SKSpriteNode()
    var lbl_credits_stored = SKLabelNode()
    var lbl_interest_rate = SKLabelNode()
    var lbl_timer = SKLabelNode()
    var lbl_Credits = SKLabelNode()
    var Credits_Bank = Int()
    var Interest_Rate = Double()
    var Credits = Int()
    var curDate = NSDate()
    var storedDate = NSDate()
    var TimeLeft = Double()
    var Interval = Double()
    var TimePassed = Double()
    
    override func willMove(from view: SKView) {
        updateCredits()
    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        //Get Res
        let width = self.size.width
        let height = self.size.height
        let btn_scale = width*0.25
        
        GlobalFunctions().drawBackground(self)
        GlobalFunctions().drawMenuOverlay(self, SelectedMenuBar: 2)
        
        //Draw Credits Label
        Credits = Credits_Defaults.integer(forKey: "Credits")
        
        lbl_Credits = SKLabelNode(fontNamed:"Chalkduster")
        lbl_Credits.text = "Credits: " + GlobalFunctions().formatNumber(Credits)
        lbl_Credits.fontSize = width*0.035
        lbl_Credits.fontColor = UIColor(white: 0.0, alpha: 1.0)
        lbl_Credits.position = CGPoint(x:width*0.5, y: height-width*0.075)
        self.addChild(lbl_Credits)
        
        //Check if bank enabled 
        let BankEnabled = BankEnabled_Defaults.bool(forKey: "BankEnabled")
    
        if (BankEnabled) {
            //Get Values
            Credits = Credits_Defaults.integer(forKey: "Credits")
            Credits_Bank = CreditsBank_Defaults.integer(forKey: "CreditsBank")
            Interest_Rate = InterestRate_Defaults.double(forKey: "InterestRate")
        
            //Credits Stored Label
            lbl_credits_stored = SKLabelNode(fontNamed:"Chalkduster")
            lbl_credits_stored.text = "Credits Stored: " + GlobalFunctions().formatNumber(Credits_Bank)
            lbl_credits_stored.fontSize = width*0.04
            lbl_credits_stored.fontColor = UIColor(white: 0.0, alpha: 1.0)
            lbl_credits_stored.position = CGPoint(x: width*0.04, y: height*0.75)
            lbl_credits_stored.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            self.addChild(lbl_credits_stored)
        
            //Interest Rate Label
            lbl_interest_rate = SKLabelNode(fontNamed:"Chalkduster")
            lbl_interest_rate.text = "Interest Rate: " + String(Interest_Rate) + "%"
            lbl_interest_rate.fontSize = width*0.04
            lbl_interest_rate.fontColor = UIColor(white: 0.0, alpha: 1.0)
            lbl_interest_rate.position = CGPoint(x: width*0.04, y: height*0.72)
            lbl_interest_rate.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            self.addChild(lbl_interest_rate)
            
            //Timer Label
            lbl_timer = SKLabelNode(fontNamed:"Chalkduster")
            lbl_timer.text = "Next Interest Income: 00:00:00"
            lbl_timer.fontSize = width*0.04
            lbl_timer.fontColor = UIColor(white: 0.0, alpha: 1.0)
            lbl_timer.position = CGPoint(x: width*0.04, y: height*0.69)
            lbl_timer.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
            self.addChild(lbl_timer)

            //Buttons
            btn_add = SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfBankButton(frame: CGRect(x: 0, y: 0, width: btn_scale, height: btn_scale), addMoney: true, addAll: false)))
            btn_add.position = CGPoint(x: width*0.5 - btn_scale*0.75, y: height*0.5 + btn_scale*0.6)
            self.addChild(btn_add)
        
            btn_add_all = SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfBankButton(frame: CGRect(x: 0, y: 0, width: btn_scale, height: btn_scale), addMoney: true, addAll: true)))
            btn_add_all.position = CGPoint(x: width*0.5 + btn_scale*0.75, y: height*0.5 + btn_scale*0.6)
            self.addChild(btn_add_all)
        
            btn_sub = SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfBankButton(frame: CGRect(x: 0, y: 0, width: btn_scale, height: btn_scale), addMoney: false, addAll: false)))
            btn_sub.position = CGPoint(x: width*0.5 - btn_scale*0.75, y: height*0.5 - btn_scale*0.6)
            self.addChild(btn_sub)
        
            btn_sub_all = SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfBankButton(frame: CGRect(x: 0, y: 0, width: btn_scale, height: btn_scale), addMoney: false, addAll: true)))
            btn_sub_all.position = CGPoint(x: width*0.5 + btn_scale*0.75, y: height*0.5 - btn_scale*0.6)
            self.addChild(btn_sub_all)
            
            //Init Next Interest
            storedDate = StoredDate_Defaults.object(forKey: "StoredDate") as! NSDate
            
            Interval = 86400 // 1 Tag (86400)
            
            TimePassed = storedDate.timeIntervalSinceNow * -1
            
            if round(TimePassed) >= Interval { //Wenn mehr als ein Tag vergangen ist
                let multiplier = floor(TimePassed/Interval) //Anz der vergangenen Tage
                let InterestMultiplier = 1 + ((Interest_Rate*multiplier)/100)
                if Double(Credits_Bank)*InterestMultiplier < Double(Int.max) {
                    Credits_Bank = Int(round(Double(Credits_Bank)*InterestMultiplier)) //Schon vergangene Tage verrechnen
                    updateCredits()
                } else {
                    Credits_Bank = Int.max
                }
                TimeLeft = (TimePassed / Interval - multiplier) * Interval //Angabe in Sekunden
            }
            else {
                TimeLeft = TimePassed
            }
            
            updateTimer(nil)
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimer(_:)), userInfo: nil, repeats: true)
        }
        else {
            let lbl_bankinfo = SKLabelNode(fontNamed:"Chalkduster")
            lbl_bankinfo.text = "Bank not available!"
            lbl_bankinfo.fontSize = width*0.07
            lbl_bankinfo.fontColor = UIColor(white: 0.0, alpha: 1.0)
            lbl_bankinfo.position = CGPoint(x: width*0.5, y: height*0.5)
            self.addChild(lbl_bankinfo)
            
            
            let lbl_bankinfo_buy = SKLabelNode(fontNamed:"Chalkduster")
            lbl_bankinfo_buy.text = "Enable it by buying it in the store."
            lbl_bankinfo_buy.fontSize = width*0.04
            lbl_bankinfo_buy.fontColor = UIColor(white: 0.0, alpha: 1.0)
            lbl_bankinfo_buy.position = CGPoint(x: width*0.5, y: height*0.45)
            self.addChild(lbl_bankinfo_buy)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        //Create transitions
        let menu_transition = SKTransition.reveal(with: SKTransitionDirection.down, duration: 0.5)
        let transition = SKTransition.fade(withDuration: 1.0)
        let BankEnabled = BankEnabled_Defaults.bool(forKey: "BankEnabled")
        
        for touch in (touches) {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if node.name != "snow" {
                node.run(SKAction.scale(to: 1.1, duration: TimeInterval(0.1)), completion: {
                    node.run(SKAction.scale(to: 1.0, duration: TimeInterval(0.1)), completion: {
                        if (node.name == "MenuBar_0") {
                            let scene = Menu_Main(size: self.scene!.size)
                            scene.scaleMode = SKSceneScaleMode.aspectFill
                            self.view?.presentScene(scene, transition: menu_transition)
                        }
                        else if (node.name == "MenuBar_1") {
                            let scene = Menu_Store(size: self.scene!.size)
                            scene.scaleMode = SKSceneScaleMode.aspectFill
                            self.view?.presentScene(scene, transition: menu_transition)
                        }
                        else if (node.name == "MenuBar_3") {
                            let scene = Menu_Scores(size: self.scene!.size)
                            scene.scaleMode = SKSceneScaleMode.aspectFill
                            self.view?.presentScene(scene, transition: menu_transition)
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
                        else if(node == self.btn_add && BankEnabled) {
                            //Add 10% to Bank
                            self.Credits_Bank += Int(Double(self.Credits)*0.1)
                            self.Credits -= Int(Double(self.Credits)*0.1)
                            
                            self.updateCredits()
                            self.updateDate()
                        }
                        else if(node == self.btn_add_all && BankEnabled) {
                            //Add all to Bank
                            self.Credits_Bank += self.Credits
                            self.Credits = 0
                            
                            self.updateCredits()
                            self.updateDate()
                        }
                        else if(node == self.btn_sub && BankEnabled) {
                            //Sub 10% from Bank
                            self.Credits += Int(Double(self.Credits_Bank)*0.1)
                            self.Credits_Bank -= Int(Double(self.Credits_Bank)*0.1)
                            
                            self.updateCredits()
                            self.updateDate()
                        }
                        else if(node == self.btn_sub_all && BankEnabled) {
                            //Sub all from Bank
                            self.Credits += self.Credits_Bank
                            self.Credits_Bank = 0
                        
                            self.updateCredits()
                            self.updateDate()
                        }
                    })
                })
            }
        }
    }
    
    func updateCredits() {
        //Update Labels
        self.lbl_Credits.text = "Credits: " + GlobalFunctions().formatNumber(Credits)
        self.lbl_credits_stored.text = "Credits Stored: " + GlobalFunctions().formatNumber(Credits_Bank)
        
        //Save Credits
        self.Credits_Defaults.set(self.Credits, forKey: "Credits")
        self.CreditsBank_Defaults.set(self.Credits_Bank, forKey: "CreditsBank")
    }
    
    func updateTimer(_ timer:Timer!) {
        if round(TimeLeft) >= Interval { //Wenn Zeit abgelaufen ->
            let InterestMultiplier = 1 + (Interest_Rate/100)
            Credits_Bank = Int(round(Double(Credits_Bank) * InterestMultiplier))
            TimeLeft = 0
            updateCredits()
            updateDate()
        } else {
            TimeLeft += 1
        }
        
        //Format TimeLeft & Update Label
        let (h,m,s) = GlobalFunctions().formatSeconds(seconds: Int(Interval-TimeLeft))
        let TimeString = String(format:"%02i:%02i:%02i", h, m, s)
        lbl_timer.text = "Next Interest Income: " + TimeString
    }
    
    func updateDate() {
        storedDate = NSDate()
        StoredDate_Defaults.setValue(storedDate, forKey: "StoredDate")
        TimeLeft = storedDate.timeIntervalSinceNow * -1
    }
}
