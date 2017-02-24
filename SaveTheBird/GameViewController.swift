//
//  GameViewController.swift
//  SaveTheBird
//
//  Created by Daniel Peters on 06.08.15.
//  Copyright (c) 2015 Daniel Peters. All rights reserved.
//

import UIKit
import SpriteKit
import Firebase

class GameViewController: UIViewController {
    
    // Properties for Banner Ad
    let RemovedAds_Defaults = UserDefaults.standard
    var removedAds = Bool()
    var bannerVisible = false
    var googleBannerView: GADBannerView!
    var interstitial: GADInterstitial!
    var adShowed = false
    var adTimer: Timer?
    
    //Full Screen ad
    func createAndLoadAd() -> GADInterstitial {
        let ad = GADInterstitial(adUnitID: "ca-app-pub-4511874521867277/7948615941")
        let request = GADRequest()
        ad.load(request)
        return ad
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set Ads Variable
        removedAds = RemovedAds_Defaults.bool(forKey: "RemoveAds")

        let scene = Menu_Main(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
        
        self.interstitial = self.createAndLoadAd()
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return UIInterfaceOrientationMask.allButUpsideDown
        } else {
            return UIInterfaceOrientationMask.all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!removedAds) {
            //Show Google Ad Banner
            googleBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
            googleBannerView.adUnitID = "ca-app-pub-4511874521867277/6471882744"
            
            googleBannerView.rootViewController = self
            let request: GADRequest = GADRequest()
            googleBannerView.load(request)
            
            googleBannerView.frame = CGRect(x: 0, y: view.bounds.height-googleBannerView.frame.size.height, width: googleBannerView.frame.size.width, height: googleBannerView.frame.size.height)
            
            self.view.addSubview(googleBannerView)
            
            adTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(GameViewController.loadAd(_:)), userInfo: nil, repeats: false)
        }
    }
    
    func loadAd(_ timer:Timer!) {
        if (self.interstitial.isReady && adShowed == false) {
            adShowed = true
            self.interstitial.present(fromRootViewController: self)
            self.interstitial = self.createAndLoadAd()
        }
    }

}
