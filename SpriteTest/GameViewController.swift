//
//  GameViewController.swift
//  SpriteTest
//
//  Created by guominglong on 16/5/30.
//  Copyright (c) 2016年 guominglong. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
//        if let scene = GameScene(fileNamed:"GameScene") {
//            // Configure the view.
//            
//            
//            /* Set the scale mode to scale to fit the window */
//            
//            skView.presentScene(scene)
//        }
        
        if let scene = AniScene(fileNamed: "GameScene"){
            // Configure the view.
            
            
            /* Set the scale mode to scale to fit the window */
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .Landscape
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
