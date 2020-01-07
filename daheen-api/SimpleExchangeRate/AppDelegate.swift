//
//  AppDelegate.swift
//  SimpleExchangeRate
//
//  Created by Daheen Lee on 2020/01/02.
//  Copyright © 2020 allwhite. All rights reserved.
//

import UIKit
import RIBs

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //RIBs Root 초기화
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        let launchRouter = RootBuilder(dependency: AppComponent()).build()
        self.launchRouter = launchRouter
        launchRouter.launch(from: window)
        
        return true
    }
    
    // MARK: - Private
    
    private var launchRouter: LaunchRouting?
}

