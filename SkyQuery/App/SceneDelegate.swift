//
//  SceneDelegate.swift
//  SkyQuery
//
//  Created by Angélica Rodrigues on 04/06/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinaor: Coordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        
        let navigationController = UINavigationController()
        self.coordinaor = AppCoordinator(navigationController: navigationController)
        self.coordinaor?.start()
        
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
    }

}

