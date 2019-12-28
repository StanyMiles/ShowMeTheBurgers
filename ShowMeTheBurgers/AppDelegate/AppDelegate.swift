//
//  AppDelegate.swift
//  ShowMeTheBurgers
//
//  Created by Stanislav Kobiletski on 26.12.2019.
//  Copyright © 2019 Stanislav Kobiletski. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  // MARK: - UIApplication Lifecycle
  
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
   
    setupAppUI()
    return true
  }

  // MARK: - UISceneSession Lifecycle

  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    
    return UISceneConfiguration(
      name: "Default Configuration",
      sessionRole: connectingSceneSession.role)
  }

  // MARK: - Funcs
  
  private func setupAppUI() {
    let attributes: [NSAttributedString.Key: Any] = [
      .foregroundColor: UIColor.white
    ]
    
    let appearance = UINavigationBar.appearance()
    appearance.titleTextAttributes = attributes
    appearance.largeTitleTextAttributes = attributes
    appearance.tintColor = .white
    appearance.barTintColor = #colorLiteral(red: 0.3490196078, green: 0.3529411765, blue: 0.9058823529, alpha: 1)
  }
}
