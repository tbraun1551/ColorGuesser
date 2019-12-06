//
//  GameKitHelper.swift
//  GameCenterTest
//
//  Created by Thomas Braun on 11/24/19.
//  Copyright © 2019 Braun. All rights reserved.
//

import Foundation
import GameKit

open class GameKitHelper: NSObject,  ObservableObject,  GKGameCenterControllerDelegate  {
    public var authenticationViewController: UIViewController?
    public var lastError: Error?


private static let _singleton = GameKitHelper()
public class var sharedInstance: GameKitHelper {
    return GameKitHelper._singleton
}

private override init() {
    super.init()
}
@Published public var enabled :Bool = false

public var  gameCenterEnabled : Bool {
                     return GKLocalPlayer.local.isAuthenticated }

    public func authenticateLocalPlayer () {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = {(viewController, error) in

            self.lastError = error as NSError?
             self.enabled = GKLocalPlayer.local.isAuthenticated
            if viewController != nil {
                self.authenticationViewController = viewController
                PopupControllerMessage
                   .PresentAuthentication
                   .postNotification()
            }
        }
    }

    public var gameCenterViewController : GKGameCenterViewController? { get {

         guard gameCenterEnabled else {
                  print("Local player is not authenticated")
                  return nil }

         let gameCenterViewController = GKGameCenterViewController()

         gameCenterViewController.gameCenterDelegate = self

         gameCenterViewController.viewState = .achievements

         return gameCenterViewController
        }}

    open func gameCenterViewControllerDidFinish(_
                gameCenterViewController: GKGameCenterViewController) {

        gameCenterViewController.dismiss(
                      animated: true, completion: nil)
    }

}

// based on code from raywenderlich.com
// helper class to make interacting with the Game Center easier
//open class GameKitHelper: NSObject, ObservableObject, GKGameCenterControllerDelegate {
//
//    public var authenticationViewController: UIViewController?
//    public var lastError: Error?
//
//    @Published public var enabled :Bool = false
//
//    public var gcEnabled = Bool()
//    public var gcDefaultLeaderBoard = String()
//
//    private static let _singleton = GameKitHelper()
//    public class var sharedInstance: GameKitHelper {
//        return GameKitHelper._singleton
//    }
//
//    private override init() {
//        super.init()
//    }
//
//    public var  gameCenterEnabled : Bool {
//        return GKLocalPlayer.local.isAuthenticated
//    }
//    public func gameCenterIsEnabled() -> Bool {
//        print("getting status")
//        return GKLocalPlayer.local.isAuthenticated
//    }
//
//    public func authenticateLocalPlayer () {
//        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
//        localPlayer.authenticateHandler = {(viewController, error) in
//
//            self.lastError = error as NSError?
//            self.enabled = GKLocalPlayer.local.isAuthenticated
//            if viewController != nil {
//                print("User Not logged in")
//                self.authenticationViewController = viewController
//                PopupControllerMessage
//                    .PresentAuthentication
//                    .postNotification()
//            } else if (localPlayer.isAuthenticated) {
//                print("User is logged in")
//                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
//                    if error != nil { print(error ?? "error1")
//                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
//                })
//            } else {
//                print ("Print user could not be authenitcated.")
//            }
//            let testAuth = self.gameCenterIsEnabled()
//            if testAuth {
//                print("authenticatoin worked in log")
//            }
//            if !testAuth {
//                print("Authenticaion did not work in log")
//            }
//            print("End of Handler")
//        }
//    }
//
//    public var gameCenterViewController : GKGameCenterViewController? { get {
//
//        guard gameCenterEnabled else {
//            print("Local player is not authenticated")
//            return nil
//        }
//        let gameCenterViewController = GKGameCenterViewController()
//        gameCenterViewController.gameCenterDelegate = self
//        gameCenterViewController.viewState = .achievements
//        return gameCenterViewController
//        }
//    }
//
//    open func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
//        gameCenterViewController.dismiss(animated: true, completion: nil)
//    }
//}

