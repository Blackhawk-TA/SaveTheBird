//
//  Menu_Settings.swift
//  SaveTheBird
//
//  Created by Daniel Peters on 26.10.15.
//  Copyright © 2015 Daniel Peters. All rights reserved.
//

import SpriteKit
import AVFoundation
import GameKit
import StoreKit

class Menu_Settings: SKScene  {
    
    //Constant Values
    let Music_Defaults = UserDefaults.standard
    let Sound_Defaults = UserDefaults.standard
    let RemovedAds_Defaults = UserDefaults.standard
    let NotFirstStart_Defaults = UserDefaults.standard
    
    //Global Variables
    var request : SKProductsRequest!
    var products : [SKProduct] = [] // List of available purchases
    var removedAds = false
    var Clouds = [SKSpriteNode]()
    var CloudText = ["Music", "Sound", "Reset"]
    var CloudName = ["music_toggle", "sound_toggle", "reset"]
    var Music = Bool()
    var Sound = Bool()
    
    override func didMove(to view: SKView) {
        //Add Back Button
        let width = self.size.width
        let height = self.size.height
        
        
        GlobalFunctions().drawBackground(self)
        GlobalFunctions().drawGuns(self)
        
        //Scale Button
        let ButtonScale = width*0.15
        
        let InfoButton = SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfMenuIcon(frame: CGRect(x: 0, y: 0, width: ButtonScale, height: ButtonScale), toggleVisibility: false)))
        InfoButton.position = CGPoint(x: width-InfoButton.size.width*0.75, y: height-InfoButton.size.height*0.75)
        InfoButton.name = "InfoButton"
        self.addChild(InfoButton)
        
        //Check Music Variable
        Music = Music_Defaults.bool(forKey: "Music")
        Sound = Sound_Defaults.bool(forKey: "Sound")
        
        //Set CloudText for Music
        if (Music) {
            CloudText[0] = "Music (On)"
        }
        else {
            CloudText[0] = "Music (Off)"
        }
        
        if (Sound) {
            CloudText[1] = "Sound (On)"
        }
        else {
            CloudText[1] = "Sound (Off)"
        }
        
        let BackButton = SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfBackButton(frame: CGRect(x: 0, y: 0, width: ButtonScale, height: ButtonScale))))
        BackButton.position = CGPoint(x: BackButton.size.width*0.75, y: height-BackButton.size.height*0.75)
        BackButton.name = "exit"
        self.addChild(BackButton)
        
        drawCloud()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //Create transitions
        let transition = SKTransition.fade(withDuration: 1.0)
        
        for touch in (touches) {
            let location = touch.location(in: self)
            let node = self.atPoint(location)
            
            if node.name != "snow" {
                node.run(SKAction.scale(to: 1.1, duration: TimeInterval(0.1)), completion: {
                    node.run(SKAction.scale(to: 1.0, duration: TimeInterval(0.1)), completion: {
                        if (node.name == "music_toggle") {
                            if (self.Music) {
                                self.Music = false
                                self.CloudText[0] = "Music (Off)"
                            }
                            else {
                                self.Music = true
                                self.CloudText[0] = "Music (On)"
                            }
                            self.Music_Defaults.set(self.Music, forKey: "Music")
                            
                            //Redraw Clouds
                            for i in 0 ..< 3 {
                                self.Clouds[i].removeAllActions()
                                self.Clouds[i].removeFromParent()
                                self.Clouds[i].removeAllChildren()
                            }
                            self.Clouds.removeAll()
                            self.drawCloud()
                        }
                        else if (node.name == "sound_toggle") {
                            if (self.Sound) {
                                self.Sound = false
                                self.CloudText[1] = "Sound (Off)"
                            }
                            else {
                                self.Sound = true
                                self.CloudText[1] = "Sound (On)"
                            }
                            self.Sound_Defaults.set(self.Sound, forKey: "Sound")
                            
                            //Redraw Clouds
                            for i in 0 ..< 3 {
                                self.Clouds[i].removeAllActions()
                                self.Clouds[i].removeFromParent()
                                self.Clouds[i].removeAllChildren()
                            }
                            self.Clouds.removeAll()
                            self.drawCloud()
                        }

                        else if (node.name == "reset") {
                            let alert = UIAlertController(title: "Warning", message: "Are you sure that you want to reset the game? You will lose all your Credits, your Level and your Highscore. After the reset, the app will close itself.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Just do it!", style: UIAlertActionStyle.default)  { _ in
                                
                                self.NotFirstStart_Defaults.set(false, forKey: "NotFirstStart")
                                
                                let iCloudKeyStore: NSUbiquitousKeyValueStore? = NSUbiquitousKeyValueStore()
                                iCloudKeyStore?.set(false, forKey: "NotFirstStart")
                                iCloudKeyStore?.synchronize()

                                exit(0)
                            })
                            
                            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default) { _ in
                            })
                            
                            // Show the alert
                            self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
                        }
                        else if (node.name == "exit") {
                            //Load Menu
                            let scene = Menu_Main(size: self.scene!.size)
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
    
    func redrawScene() {
        self.removeAllChildren()
        let scene = Menu_Main(size: self.scene!.size)
        scene.scaleMode = SKSceneScaleMode.aspectFill
        self.scene!.view!.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))
    }
    
    func drawCloud() {
        
        //Get Res
        let width = self.size.width
        let height = self.size.height
        
        //Draw Clouds
        var CloudPos = [ CGPoint(x: width*0.3, y: height*0.8), CGPoint(x: width*0.7, y: height*0.6), CGPoint(x: width*0.4, y: height*0.4) ]
        for i in 0 ..< 3 {
            Clouds.append(SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfCloud(frame: CGRect(x: 0, y: 0, width: width/2.5, height: width/5), textInput: CloudText[i], textSize: width*0.033))))
            Clouds[i].position = CloudPos[i]
            Clouds[i].name = CloudName[i]
            self.addChild(Clouds[i])
        }
    }
}
