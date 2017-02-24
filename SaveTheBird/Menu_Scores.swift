//
//  Menu_Scores.swift
//  SaveTheBird
//
//  Created by Daniel Peters on 06.08.15.
//  Copyright (c) 2015 Daniel Peters. All rights reserved.
//

import SpriteKit

class Menu_Scores: SKScene {
    
    //Variables
    var lbl_Credits = SKLabelNode()
    var Credits = Int()
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        //Constant Values
        let Highscore_Defaults = UserDefaults.standard
        let GamesPlayed_Defaults = UserDefaults.standard
        let OverallScore_Defaults = UserDefaults.standard
        let Credits_Defaults = UserDefaults.standard
        
        //Variables
        let Highscore = Highscore_Defaults.integer(forKey: "Highscore")
        let GamesPlayed = GamesPlayed_Defaults.integer(forKey: "GamesPlayed")
        let OverallScore = OverallScore_Defaults.integer(forKey: "OverallScore")
        
        //Get Res
        let width = self.size.width
        let height = self.size.height
        
        GlobalFunctions().drawBackground(self)
        GlobalFunctions().drawMenuOverlay(self, SelectedMenuBar: 3)
        
        //Draw Credits Label
        Credits = Credits_Defaults.integer(forKey: "Credits")
        
        lbl_Credits = SKLabelNode(fontNamed:"Chalkduster")
        lbl_Credits.text = "Credits: " + GlobalFunctions().formatNumber(Credits)
        lbl_Credits.fontSize = width*0.035
        lbl_Credits.fontColor = UIColor(white: 0.0, alpha: 1.0)
        lbl_Credits.position = CGPoint(x:width*0.5, y: height-width*0.075)
        self.addChild(lbl_Credits)
        
        /////Draw Singleplayer Stats
        let lbl_SPHead = SKLabelNode(fontNamed:"Chalkduster")
            lbl_SPHead.text = "Singleplayer Stats"
            lbl_SPHead.fontSize = width*0.04
            lbl_SPHead.fontColor = UIColor(white: 0.0, alpha: 1.0)
            lbl_SPHead.position = CGPoint(x: width*0.5, y: height*0.73)
            lbl_SPHead.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        self.addChild(lbl_SPHead)
        
        //Highscore
        let lbl_Highscore = SKLabelNode(fontNamed:"Chalkduster")
            lbl_Highscore.text = "Highscore: " + GlobalFunctions().formatNumber(Highscore)
            lbl_Highscore.fontSize = width*0.035
            lbl_Highscore.fontColor = UIColor(white: 0.0, alpha: 1.0)
            lbl_Highscore.position = CGPoint(x: width*0.05, y: lbl_SPHead.position.y - width*0.1)
            lbl_Highscore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.addChild(lbl_Highscore)
        
        //Games Played
        let lbl_GamesPlayed = SKLabelNode(fontNamed:"Chalkduster")
            lbl_GamesPlayed.text = "Games played: " + GlobalFunctions().formatNumber(GamesPlayed)
            lbl_GamesPlayed.fontSize = width*0.035
            lbl_GamesPlayed.fontColor = UIColor(white: 0.0, alpha: 1.0)
            lbl_GamesPlayed.position = CGPoint(x: width*0.05, y: lbl_Highscore.position.y - width*0.07)
            lbl_GamesPlayed.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.addChild(lbl_GamesPlayed)
        
        //Games Played
        let lbl_OverallScore = SKLabelNode(fontNamed:"Chalkduster")
            lbl_OverallScore.text = "Overall Score: " + GlobalFunctions().formatNumber(OverallScore)
            lbl_OverallScore.fontSize = width*0.035
            lbl_OverallScore.fontColor = UIColor(white: 0.0, alpha: 1.0)
            lbl_OverallScore.position = CGPoint(x: width*0.05, y: lbl_GamesPlayed.position.y - width*0.07)
            lbl_OverallScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.addChild(lbl_OverallScore)
        
        //Average Score
        var AvgText = String()
        if GamesPlayed == 0 {
            AvgText = "No Games played yet"
        }
        else {
            let AvgScore = Double(OverallScore) / Double(GamesPlayed)
            AvgText = String(format: "%.2f", AvgScore)
        }
        let lbl_AvgScore = SKLabelNode(fontNamed:"Chalkduster")
            lbl_AvgScore.text = "Average Score: " + AvgText
            lbl_AvgScore.fontSize = width*0.035
            lbl_AvgScore.fontColor = UIColor(white: 0.0, alpha: 1.0)
            lbl_AvgScore.position = CGPoint(x: width*0.05, y: lbl_OverallScore.position.y - width*0.07)
            lbl_AvgScore.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        self.addChild(lbl_AvgScore)
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
                        else if (node.name == "MenuBar_2") {
                            let scene = Menu_Bank(size: self.scene!.size)
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
                    }) 
                }) 
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
