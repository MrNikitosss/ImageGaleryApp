//
//  AppDelegate.swift
//  ImageGalaryApp
//
//  Created by Nikita Moskalenko on 3.01.24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let mainVCSTB = StoryboardScene.MainViewController.storyboard
        let mainVC = mainVCSTB.instantiateViewController(withIdentifier: StoryboardScene.MainViewController.storyboardName) as! MainViewController

        window?.backgroundColor = .white
        window?.rootViewController = mainVC
        window?.makeKeyAndVisible()

        return true
    }

}
