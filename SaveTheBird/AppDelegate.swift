//
//  AppDelegate.swift
//  SaveTheBird
//
//  Created by Daniel Peters on 06.08.15.
//  Copyright (c) 2015 Daniel Peters. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //User Defaults
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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Use Firebase library to configure APIs
        FIRApp.configure()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        storeDataToCloud()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        storeDataToCloud()
    }

    func storeDataToCloud() {
        let NotFirstStart = NotFirstStart_Defaults.bool(forKey: "NotFirstStart")
        let Music = Music_Defaults.bool(forKey: "Music")
        let Sound = Sound_Defaults.bool(forKey: "Sound")
        let Premium = Premium_Defaults.bool(forKey: "Premium")
        let Booster = CreditsBooster_Defaults.bool(forKey: "Booster")
        let RemovedAds = RemovedAds_Defaults.bool(forKey: "RemoveAds")
        let Level = Level_Defaults.integer(forKey: "Level")
        let Credits = Credits_Defaults.integer(forKey: "Credits")
        let XP = XP_Defaults.integer(forKey: "XP")
        let Highscore = Highscore_Defaults.integer(forKey: "Highscore")
        let GamesPlayed = GamesPlayed_Defaults.integer(forKey: "GamesPlayed")
        let OverallScore = OverallScore_Defaults.integer(forKey: "OverallScore")
        let Eggs = EggNumber_Defaults.integer(forKey: "Eggs")
        let CreditsBank = CreditsBank_Defaults.integer(forKey: "CreditsBank")
        let InterestRate = InterestRate_Defaults.double(forKey: "InterestRate")
        let BankEnabled = BankEnabled_Defaults.bool(forKey: "BankEnabled")
        let Lifes = Lifes_Defaults.integer(forKey: "Lifes")
        let BankUpgraded = BankUpgraded_Defaults.integer(forKey: "BankUpgraded")
        let StoredDate = StoredDate_Defaults.object(forKey: "StoredDate")
        let DailyBonusDate = DailyBonusDate_Defaults.object(forKey: "DailyBonus")
        let DailyRewardGiven = DailyRewardGiven_Defaults.bool(forKey: "DailyRewardGiven")
        let DailyLastDay = DailyLastDay_Defaults.integer(forKey: "DailyLastDay")
        
        let iCloudKeyStore: NSUbiquitousKeyValueStore? = NSUbiquitousKeyValueStore()
        iCloudKeyStore?.set(NotFirstStart, forKey: "NotFirstStart")
        iCloudKeyStore?.set(Music, forKey: "Music")
        iCloudKeyStore?.set(Sound, forKey: "Sound")
        iCloudKeyStore?.set(Premium, forKey: "Premium")
        iCloudKeyStore?.set(Booster, forKey: "Booster")
        iCloudKeyStore?.set(RemovedAds, forKey: "RemoveAds")
        iCloudKeyStore?.set(Level, forKey: "Level")
        iCloudKeyStore?.set(Credits, forKey: "Credits")
        iCloudKeyStore?.set(XP, forKey: "XP")
        iCloudKeyStore?.set(Highscore, forKey: "Highscore")
        iCloudKeyStore?.set(GamesPlayed, forKey: "GamesPlayed")
        iCloudKeyStore?.set(OverallScore, forKey: "OverallScore")
        iCloudKeyStore?.set(Eggs, forKey: "Eggs")
        iCloudKeyStore?.set(CreditsBank, forKey: "CreditsBank")
        iCloudKeyStore?.set(InterestRate, forKey: "InterestRate")
        iCloudKeyStore?.set(BankEnabled, forKey: "BankEnabled")
        iCloudKeyStore?.set(Lifes, forKey: "Lifes")
        iCloudKeyStore?.set(BankUpgraded, forKey: "BankUpgraded")
        iCloudKeyStore?.set(StoredDate, forKey: "StoredDate")
        iCloudKeyStore?.set(DailyBonusDate, forKey: "DailyBonus")
        iCloudKeyStore?.set(DailyRewardGiven, forKey: "DailyRewardGiven")
        iCloudKeyStore?.set(DailyLastDay, forKey: "DailyLastDay")
        iCloudKeyStore?.synchronize()
        
        print("UserDefaults saved to iCloud")
    }
    
}
