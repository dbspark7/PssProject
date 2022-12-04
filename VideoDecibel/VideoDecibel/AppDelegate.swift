//
//  AppDelegate.swift
//  VideoDecibel
//
//  Created by iot-parksooseong on 2022/11/28.
//

import UIKit
import PssLogger

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        PssLogger.setupLog()
        
        return true
    }
}

