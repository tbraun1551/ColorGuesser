//
//  SceneDelegate.swift
//  ColorGuesser
//
//  Created by Thomas Braun on 9/16/19.
//  Copyright © 2019 Thomas Braun. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Get the managed object context from the shared persistent container.
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Create the SwiftUI view that provides the window contents.
        //        let contentView = ContentView(rGuess: 0.5, gGuess: 0.5, bGuess: 0.5)
        //        let contentView = ContentView().environment(\.managedObjectContext, context)
        let contentView = ContentView().environmentObject(GameKitHelper.sharedInstance) // publish enabled state
        
        
        // Use a UIHostingController as window root view controller.
//        if let windowScene = scene as? UIWindowScene {
//            let window = UIWindow(windowScene: windowScene)
//            window.rootViewController = UIHostingController(rootView: contentView)
//            self.window = window
//            window.makeKeyAndVisible()
//        }
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()

            //Mine
            // new code to create listeners for the messages
            // you will be sending later
            PopupControllerMessage.PresentAuthentication.addHandlerForNotification( self, handler: #selector(SceneDelegate.showAuthenticationViewController))
            PopupControllerMessage.GameCenter.addHandlerForNotification(self, handler: #selector(SceneDelegate.showGameCenterViewController))
            
            // now we are back to the standard template
            // generated when your project was created
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    // pop's up the leaderboard and achievement screen
    @objc func showGameCenterViewController() {
        if let gameCenterViewController = GameKitHelper.sharedInstance.gameCenterViewController {
            self.window?.rootViewController?.present(gameCenterViewController, animated: true, completion: nil)
        }
        
    }
    // pop's up the authentication screen
    @objc func showAuthenticationViewController() {
        if let authenticationViewController = GameKitHelper.sharedInstance.authenticationViewController {
            self.window?.rootViewController?.present(authenticationViewController, animated: true, completion: nil)
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

