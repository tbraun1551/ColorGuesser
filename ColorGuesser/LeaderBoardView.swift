//
//  LeaderBoardView.swift
//  ColorGuesser
//
//  Created by Thomas Braun on 10/28/19.
//  Copyright © 2019 Thomas Braun. All rights reserved.
//

import SwiftUI
import GameKit

struct LeaderBoardView: View {
    
    static var leaderboard: [Int] = []
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    
    var body: some View {
        ZStack {
                Button(action: {
                print("dismiss settings view")
                self.presentationMode.wrappedValue.dismiss()
            } ) {
                Text("Dismiss")
            }
            .position(x: 320, y: 35)
            Text("LeaderBoard Functionality Coming Soon")
        }
    }
}
    
public class LeaderBoard {
    
    var leaderboard: [Int] = [0, 0, 0, 0, 0]
    
    func compareScores(_ score: Int) -> Bool {
        for highscores in leaderboard {
            if score > highscores {
                return true;
            }
        }
        return false
    }
    
    func scorePosition(_ score: Int) -> Int{
        return 0
    }
    
    func addScore(score: Int) {
        print("testing leaderboard class")
        print("The score was \(score)")
        let highscore = compareScores(score)
        if(highscore) {
            let position = scorePosition(score)
            leaderboard[position] = score
        }
        
    }
}

struct LeaderBoardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderBoardView()
    }
}

