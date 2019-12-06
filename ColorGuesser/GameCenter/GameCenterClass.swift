//
//  GameCenterClass.swift
//  IrisAnimation
//
//  Created by Thomas Braun on 11/5/19.
//  Copyright © 2019 Braun. All rights reserved.
//

import Foundation
import GameKit


class GameCenterManager {
            var gcEnabled = Bool() // Check if the user has Game Center enabled
            var gcDefaultLeaderBoard = String() // Check the default leaderboardID
            var score = 0
            let LEADERBOARD_ID = "grp.irisLeader2" //Leaderboard ID from Itunes Connect
            
           // MARK: - AUTHENTICATE LOCAL PLAYER
           func authenticateLocalPlayer() {
            let localPlayer: GKLocalPlayer = GKLocalPlayer.local
                    
               localPlayer.authenticateHandler = {(ViewController, error) -> Void in
                   if((ViewController) != nil) {
                       print("User is not logged into game center")
                   } else if (localPlayer.isAuthenticated) {
                       // 2. Player is already authenticated & logged in, load game center
                       self.gcEnabled = true
                            
                       // Get the default leaderboard ID
                       localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                        if error != nil { print(error ?? "error1")
                           } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                       })
                        print("Adding GameCenter user was a success")
                   } else {
                       // 3. Game center is not enabled on the users device
                       self.gcEnabled = false
                       print("Local player could not be authenticated!")
                    print(error ?? "error2")
                   }
               }
           } //authenticateLocalPlayer()
            
            func submitScoreToGC(_ score: Int){
                let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
                bestScoreInt.value = Int64(score)
                GKScore.report([bestScoreInt]) { (error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        print("Best Score submitted to your Leaderboard!")
                    }
                }
            }//submitScoreToGC()
           /*
            //Show GameCenter leaderboard
            func checkGCLeaderboard(_ sender: AnyObject) {
                let gcVC = GKGameCenterViewController()
                gcVC.gameCenterDelegate = self
                gcVC.viewState = .leaderboards
                gcVC.leaderboardIdentifier = LEADERBOARD_ID
                present(gcVC, animated: true, completion: nil)
            }//checkGCLeaderboard()
 */
        }
