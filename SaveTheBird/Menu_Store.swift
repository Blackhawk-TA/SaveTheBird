//
//  Menu_Store.swift
//  SaveTheBird
//
//  Created by Daniel Peters on 06.08.15.
//  Copyright (c) 2015 Daniel Peters. All rights reserved.


import SpriteKit
import StoreKit

class Menu_Store: SKScene, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    
    //Constants
    let Credits_Defaults = UserDefaults.standard
    let BankEnabled_Defaults = UserDefaults.standard
    let EggNumber_Defaults = UserDefaults.standard
    let Lifes_Defaults = UserDefaults.standard
    let BankUpgraded_Defaults = UserDefaults.standard
    let InterestRate_Defaults = UserDefaults.standard
    
    let Premium_Defaults = UserDefaults.standard
    let CreditsBooster_Defaults = UserDefaults.standard
    let RemovedAds_Defaults = UserDefaults.standard
    
    //Variables
    var Items = [NSArray]()
    var lbl_Credits = SKLabelNode()
    var Credits = Int()
    var ItemBox = [SKSpriteNode]()
    var BuyButton = [SKSpriteNode]()
    var ItemIcon = [SKSpriteNode]()
    var lbl_ItemName = [SKLabelNode]()
    var mlbl_ItemDescription = [SKMultilineLabel]()
    var lbl_ItemPrice = [SKLabelNode]()
    var request : SKProductsRequest!
    var products : [SKProduct] = [] // List of available purchases
    
    weak var scrollView: CustomScrollView!
    let moveableNode = SKNode()
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        //Get Res
        let width = self.size.width
        let height = self.size.height
        
        GlobalFunctions().drawBackground(self)
        GlobalFunctions().drawMenuOverlay(self, SelectedMenuBar: 1)
        
        //Init IAP
        self.initInAppPurchases()
        
        //Draw Credits Label
        Credits = Credits_Defaults.integer(forKey: "Credits")
        
        lbl_Credits = SKLabelNode(fontNamed:"Chalkduster")
        lbl_Credits.text = "Credits: " + GlobalFunctions().formatNumber(Credits)
        lbl_Credits.fontSize = width*0.035
        lbl_Credits.fontColor = UIColor(white: 0.0, alpha: 1.0)
        lbl_Credits.position = CGPoint(x:width*0.5, y: height-width*0.075)
        self.addChild(lbl_Credits)
        
        //Add Skybox to prevent Items to be shown at the top
        let Skybox = SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfSkybox(frame: CGRect(x: 0, y:0, width: width, height: height*0.2))))
        Skybox.position = CGPoint(x: width*0.5, y: height-Skybox.size.height * 0.5)
        Skybox.zPosition = -1.0
        addChild(Skybox)
        
        //Items
        //Index         0                     1                                                                                               2                   3           4
        //              Name                , Description                                                                                   , ID                , RealMoney , Price
        Items.append([ "Premium"            , "Includes 1,000,000 Credits, Credits Booster, Remove Ads, 15 bonus Eggs and 25 extra Lifes."  , "ID_Premium"      , 1         , 1.99    ])
        Items.append([ "Credits Booster"    , "The Credits Booster doubles all Credits you receive through playing."                        , "ID_Booster"      , 1         , 0.99    ])
        Items.append([ "Remove Ads"         , "This purchase will remove all advertisements in the App."                                    , "ID_Ads"          , 1         , 0.99    ])
        Items.append([ "500,000 Credits"    , "Get 500,000 Credits to buy items in the store."                                              , "ID_Credits"      , 1         , 0.99    ])
        Items.append([ "Enable Bank"        , "Enable the bank to earn interest by placing your Credits there."                             , "ID_EnableBank"   , 0         , 10000   ])
        Items.append([ "Upgrade Bank"       , "Increase the rate of interest for you bank to receive more Credits."                         , "ID_UpgradeBank"  , 0         , 100000  ])
        Items.append([ "Bonus Eggs"         , "Buy a bonus egg to have more chances to prevent the balls from hitting you."                 , "ID_Eggs"         , 0         , 100000  ])
        Items.append([ "Extra Lifes"        , "Buy a extra life to keep playing after you died without losing your score."                  , "ID_Lifes"        , 0         , 25000   ])
        Items.append([ "Restore Purchases"  , "Restore all your previously purchased products."                                             , "ID_Restore"      , 1         , 0.00    ])
        
        //Check if Premium
        let Premium = Premium_Defaults.bool(forKey: "Premium")
        if Premium {
            for i in 0 ..< Items.count-1 {
                if Items[i][2] as! String == "ID_Premium" {
                    Items.remove(at: i)
                }
            }
        }
        
        //Check if Booster is active
        let Booster = CreditsBooster_Defaults.bool(forKey: "Booster")
        if Booster {
            for i in 0 ..< Items.count-1 {
                if Items[i][2] as! String == "ID_Booster" {
                    Items.remove(at: i)
                }
            }
        }
        
        //Check if Ads have been removed
        let RemovedAds = RemovedAds_Defaults.bool(forKey: "RemoveAds")
        if RemovedAds {
            for i in 0 ..< Items.count-1 {
                if Items[i][2] as! String == "ID_Ads" {
                    Items.remove(at: i)
                }
            }
        }
        
        //Check if Bank is already enabled
        let BankEnabled = BankEnabled_Defaults.bool(forKey: "BankEnabled")
        if BankEnabled {
            for i in 0 ..< Items.count-1 {
                if Items[i][2] as! String == "ID_EnableBank" {
                    Items.remove(at: i)
                }
            }
        }
        
        //Check how often Bank has been upgraded
        let BankUpgraded = BankEnabled_Defaults.integer(forKey: "BankUpgraded")
        if BankUpgraded >= 8 {
            for i in 0 ..< Items.count-1 {
                if Items[i][2] as! String == "ID_UpgradeBank" {
                    Items.remove(at: i)
                }
            }
        }
        
        //Add scrollView
        let scrollViewMultiplier = 1 + 0.15 * CGFloat(Items.count - 3)
        
        addChild(moveableNode)
        
        scrollView = CustomScrollView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height), moveableNode: moveableNode, scrollDirection: .vertical)
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollView.frame.size.height * scrollViewMultiplier) // makes it 1.45 times the height; CHANGE WHEN NEW ITEMS ADDED => Needs update due to number changing after Premium bought
        view.addSubview(scrollView)
        
        for i in 0 ..< Items.count {
            //Create Item Box
            ItemBox.append(SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfStoreItemBox(frame: CGRect(x: 0, y: 0, width: width*0.9, height: height*0.15)))))
            ItemBox[i].position = CGPoint(x: width*0.5, y: height*0.65 - ItemBox[i].size.height * CGFloat(i))
            ItemBox[i].zPosition = -3.0
            moveableNode.addChild(ItemBox[i])
            
            //Create Buy Button
            BuyButton.append(SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfBuyButton(frame: CGRect(x: 0, y: 0, width: width*0.15, height: width*0.15)))))
            BuyButton[i].position = CGPoint(x: width*0.85, y: height*0.65 - BuyButton[i].size.width*0.4 - ItemBox[i].size.height * CGFloat(i))
            BuyButton[i].zPosition = -2.0
            moveableNode.addChild(BuyButton[i])
            
            //Create Item Icon
            ItemIcon.append(SKSpriteNode(texture: SKTexture(image: StyleKitName.imageOfStoreIcon(frame: CGRect(x: 0, y: 0, width: width*0.15, height: width*0.15), store_icon_id: Items[i][2] as! String))))
            ItemIcon[i].position = CGPoint(x: width*0.15, y: height*0.65 - ItemIcon[i].size.width*0.4 - ItemBox[i].size.height * CGFloat(i))
            ItemIcon[i].zPosition = -2.0
            moveableNode.addChild(ItemIcon[i])
            
            //Draw Item Name 
            lbl_ItemName.append(SKLabelNode(fontNamed:"Chalkduster"))
            lbl_ItemName[i].text = Items[i][0] as? String
            lbl_ItemName[i].fontSize = width*0.035
            lbl_ItemName[i].fontColor = UIColor(white: 0.0, alpha: 1.0)
            lbl_ItemName[i].position = CGPoint(x: width*0.5, y: ItemBox[i].position.y + ItemBox[i].size.height * 0.3)
            lbl_ItemName[i].zPosition = -2.0
            moveableNode.addChild(lbl_ItemName[i])
            
            //Draw Item Price
            var str_price = String()
            
            if (Items[i][3] as! NSObject) as! Int == 1 { //item costs real money
                str_price = "Price: " + String(describing: Items[i][4]) + "€" //Währung und Kosten bekommen
            } else { //item costs ingame money
                str_price = "Price: " + GlobalFunctions().formatNumber(Int(Items[i][4] as! NSNumber)) + " Credits"
            }
            
            lbl_ItemPrice.append(SKLabelNode(fontNamed:"Chalkduster"))
            lbl_ItemPrice[i].text = str_price
            lbl_ItemPrice[i].fontSize = width*0.0275
            lbl_ItemPrice[i].fontColor = UIColor(white: 0.0, alpha: 1.0)
            lbl_ItemPrice[i].position = CGPoint(x: width*0.5, y: ItemBox[i].position.y - ItemBox[i].size.height * 0.45)
            lbl_ItemPrice[i].zPosition = -2.0
            moveableNode.addChild(lbl_ItemPrice[i])
            
            mlbl_ItemDescription.append(SKMultilineLabel(
                text: Items[i][1] as! String,
                labelWidth: Int(width*0.5),
                pos: CGPoint(x: ItemBox[i].position.x , y: ItemBox[i].position.y + ItemBox[i].size.height*0.1),
                fontName: "Chalkduster",
                fontSize: width*0.025,
                fontColor: UIColor(white: 0.0, alpha: 1.0),
                leading: Int(width*0.035),
                alignment: SKLabelHorizontalAlignmentMode.center,
                shouldShowBorder: false))

            moveableNode.addChild(mlbl_ItemDescription[i])
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        //Create transitions
        let menu_transition = SKTransition.reveal(with: SKTransitionDirection.down, duration: 0.5)
        let transition = SKTransition.fade(withDuration: 1.0)

        Credits = Credits_Defaults.integer(forKey: "Credits")
        
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
                        
                        for i in 0 ..< self.Items.count {
                            if node == self.BuyButton[i] {
                                print(self.Items[i][2] as! String, i)
                                if self.Items[i][2] as! String == "ID_Premium" && SKPaymentQueue.canMakePayments() {
                                    for i in 0 ..< self.products.count {
                                        let curProduct = self.products[i]
                                        if curProduct.productIdentifier == "inapp_premium" {
                                            self.buyProduct(curProduct)
                                        }
                                    }
                                }
                                else if self.Items[i][2] as! String == "ID_Booster" && SKPaymentQueue.canMakePayments() {
                                    for i in 0 ..< self.products.count {
                                        let curProduct = self.products[i]
                                        if curProduct.productIdentifier == "inapp_booster" {
                                            self.buyProduct(curProduct)
                                        }
                                    }
                                
                                }
                                else if self.Items[i][2] as! String == "ID_Ads" && SKPaymentQueue.canMakePayments() {
                                    for i in 0 ..< self.products.count {
                                        let curProduct = self.products[i]
                                        if curProduct.productIdentifier == "inapp_ads" {
                                            self.buyProduct(curProduct)
                                        }
                                    }
                                }
                                else if self.Items[i][2] as! String == "ID_Credits" && SKPaymentQueue.canMakePayments() {
                                    for i in 0 ..< self.products.count {
                                        let curProduct = self.products[i]
                                        if curProduct.productIdentifier == "inapp_credits" {
                                            self.buyProduct(curProduct)
                                        }
                                    }
                                }
                                else if self.Items[i][2] as! String == "ID_EnableBank" {
                                    if self.Credits >= Int(self.Items[i][4] as! NSNumber) {
                                        self.updateCredits(i)
                                        
                                        self.BankEnabled_Defaults.set(true, forKey: "BankEnabled")
                                    } else {
                                        self.notEnoughCredits(self.Items[i][0] as! String)
                                    }
                                    self.redrawScene()
                                }
                                else if self.Items[i][2] as! String == "ID_UpgradeBank" {
                                    var BankUpgraded = self.BankEnabled_Defaults.integer(forKey: "BankUpgraded")
                                    var InterestRate = self.InterestRate_Defaults.double(forKey: "InterestRate")
                                    
                                    if BankUpgraded < 8 && self.Credits >= Int(self.Items[i][4] as! NSNumber) {
                                        self.updateCredits(i)
                                        
                                        BankUpgraded = BankUpgraded + 1
                                        self.BankUpgraded_Defaults.set(BankUpgraded, forKey: "BankUpgraded")
                                        
                                        InterestRate = InterestRate + 2.5
                                        self.InterestRate_Defaults.set(InterestRate, forKey: "InterestRate")
                                    }
                                    else if BankUpgraded >= 8 {
                                        self.redrawScene()
                                    } else {
                                        self.notEnoughCredits(self.Items[i][0] as! String)
                                    }
                                }
                                else if self.Items[i][2] as! String == "ID_Eggs" {
                                    if self.Credits >= Int(self.Items[i][4] as! NSNumber) {
                                        self.updateCredits(i)
                                        
                                        var Eggs = self.EggNumber_Defaults.integer(forKey: "Eggs")
                                        Eggs = Eggs + 1
                                        self.EggNumber_Defaults.set(Eggs, forKey: "Eggs")
                                    } else {
                                        self.notEnoughCredits(self.Items[i][0] as! String)
                                    }
                                }
                                else if self.Items[i][2] as! String == "ID_Lifes" {
                                    if self.Credits >= Int(self.Items[i][4] as! NSNumber) {
                                        self.updateCredits(i)
                                        
                                        var Lifes = self.Lifes_Defaults.integer(forKey: "Lifes")
                                        Lifes = Lifes + 1
                                        self.Lifes_Defaults.set(Lifes, forKey: "Lifes")
                                    } else {
                                        self.notEnoughCredits(self.Items[i][0] as! String)
                                    }
                                }
                                else if self.Items[i][2] as! String == "ID_Restore" {
                                    if (SKPaymentQueue.canMakePayments()) {
                                        SKPaymentQueue.default().restoreCompletedTransactions()
                                    }
                                }
                            }
                        }
                    }) 
                })
            }
        }
    }
    
    override func willMove(from view: SKView) {
        scrollView.removeFromSuperview()
    }
    
    func updateCredits(_ Index: Int) {
        self.Credits = self.Credits - Int(self.Items[Index][4] as! NSNumber)
        self.Credits_Defaults.set(self.Credits, forKey: "Credits")
        self.lbl_Credits.text = "Credits: " + GlobalFunctions().formatNumber(self.Credits)
    }
    
    func notEnoughCredits(_ ItemName: String) {
        let alert = UIAlertController(title: "Not Enough Credits!", message: "You don't own enough Credits to buy " + ItemName + ", play more the get more Credits.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default)  { _ in
            })
        
        // Show the alert
        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func redrawScene() {
        self.removeAllChildren()
        let scene = Menu_Store(size: self.scene!.size)
        scene.scaleMode = SKSceneScaleMode.aspectFill
        self.scene!.view!.presentScene(scene, transition: SKTransition.fade(withDuration: 1.0))
    }
    
    // ———————————
    // —- Handle In-App Purchases —-
    // ———————————
    
    // Initialize the App Purchases
    func initInAppPurchases() {
        SKPaymentQueue.default().add(self)
        // Get the list of possible purchases
        if self.request == nil {
            self.request = SKProductsRequest(productIdentifiers: Set(["inapp_premium", "inapp_booster", "inapp_ads", "inapp_credits"]))
            self.request.delegate = self
            self.request.start()
        }
    }
    
    // Request a purchase
    func buyProduct(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // StoreKit protocoll method. Called when the AppStore responds
    func productsRequest (_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
        self.request = nil
    }
    
    // StoreKit protocoll method. Called when an error happens in the communication with the AppStore
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print(error)
        self.request = nil
    }
    
    // StoreKit protocoll method. Called after the purchase
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch (transaction.transactionState) {
            case .purchased:
                if transaction.payment.productIdentifier == "inapp_premium" {
                    self.handlePremium()
                }
                else if transaction.payment.productIdentifier == "inapp_booster" {
                    self.handleBooster()
                }
                else if transaction.payment.productIdentifier == "inapp_ads" {
                    self.handleRemoveAds()
                }
                else if transaction.payment.productIdentifier == "inapp_credits" {
                    self.handleCredits()
                }
                queue.finishTransaction(transaction)
            case .restored:
                if transaction.payment.productIdentifier == "inapp_premium" {
                    self.handlePremium()
                }
                else if transaction.payment.productIdentifier == "inapp_booster" {
                    self.handleBooster()
                }
                else if transaction.payment.productIdentifier == "inapp_ads" {
                    self.handleRemoveAds()
                }
                queue.finishTransaction(transaction)
            case .failed:
                print("Payment Error: %@", transaction.error!)
                queue.finishTransaction(transaction)
            default:
                print("Transaction State: %@", transaction.transactionState)
            }
        }
    }
    
    //Product Purchased
    func handlePremium() {
        Premium_Defaults.set(true, forKey: "Premium")
        RemovedAds_Defaults.set(true, forKey: "RemoveAds")
        CreditsBooster_Defaults.set(true, forKey: "Booster")
        
        //Give Credits
        Credits += 1000000
        self.Credits_Defaults.set(self.Credits, forKey: "Credits")
        self.lbl_Credits.text = "Credits: " + GlobalFunctions().formatNumber(self.Credits)
        
        //Give 15 Bonus Eggs
        var Eggs = self.EggNumber_Defaults.integer(forKey: "Eggs")
        Eggs += 15
        self.EggNumber_Defaults.set(Eggs, forKey: "Eggs")
        
        //Give 25 Extra Lifes
        var Lifes = self.Lifes_Defaults.integer(forKey: "Lifes")
        Lifes += 25
        Lifes_Defaults.set(Lifes, forKey: "Lifes")
        
        let alert = UIAlertController(title: "Success", message: "You are now a Premium user. You received 1,000,000 Credits, 25 extra lifes, 15 bonus eggs and the ads will be removed at the next start.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Thanks", style: UIAlertActionStyle.default)  { _ in
            self.redrawScene()
        })
        
        // Show the alert
        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func handleBooster() {
        CreditsBooster_Defaults.set(true, forKey: "Booster")
        
        let alert = UIAlertController(title: "Success", message: "Your Credits Booster is now active.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Thanks", style: UIAlertActionStyle.default)  { _ in
            self.redrawScene()
        })
        
        // Show the alert
        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func handleRemoveAds() {
        RemovedAds_Defaults.set(true, forKey: "RemoveAds")
        
        let alert = UIAlertController(title: "Success", message: "All ads will be removed after a restart of the app.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Thanks", style: UIAlertActionStyle.default)  { _ in
            self.redrawScene()
        })
        
        // Show the alert
        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func handleCredits() {
        Credits += 500000
        self.Credits_Defaults.set(self.Credits, forKey: "Credits")
        self.lbl_Credits.text = "Credits: " + GlobalFunctions().formatNumber(self.Credits)
        
        let alert = UIAlertController(title: "Success", message: "500,000 Credits have been added to your account.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Thanks", style: UIAlertActionStyle.default)  { _ in
        })
        
        // Show the alert
        self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
