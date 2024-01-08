//
//  AppDelegate.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 3.01.24.
//

import UIKit
import Resolver

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let vc = SceneFactory.produceTabBarController()
        let navVC = UINavigationController(rootViewController: vc)
        
        window?.backgroundColor = .white
        window?.rootViewController = vc
        window?.makeKeyAndVisible()

        self.startup()

        return true
    }

    func startup() {
        Resolver().registerServices()
    }
}
