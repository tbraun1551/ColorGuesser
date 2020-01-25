//
//  SettingsView.swift
//  ColorGuesser
//
//  Created by Thomas Braun on 10/28/19.
//  Copyright © 2019 Thomas Braun. All rights reserved.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    
	let instructions = #"""
    The goal of Iris is to match the color of the block of the two blocks as accurately as possible by using the sliders and the ‘+’ and ‘-‘ buttons. You can take as many guesses as you want, but only your first score will be submitted to Game Center.
        By tapping the game controller icon on the top left of the home screen you can access the Iris leaderboards and see how your high score compares to your friends and the rest of the world.
    """#
	
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var showActionSheet = false
    @State var showAppIconChanger = false
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("Instructions")
                        .fixedSize()
						.font(.title)
                        .multilineTextAlignment(.leading)
                    Text(instructions)
                        .font(.body)
						.padding(.horizontal)
                }
                List{
                    NavigationLink(destination: AppIconChanger()){
                        HStack {
                            Image(systemName: "paintbrush")
                            Text("Change App Icon")
                        }
                    }
                    NavigationLink(destination: PurchasePage()){
                        HStack {
                            Image(systemName: "creditcard")
                            Text("Support Me")
                        }
                    }
                    NavigationLink(destination: AboutMe()){
                        HStack {
                            Image(systemName: "person")
                            Text("About Me")
                        }
                    }
                    NavigationLink(destination: HelpPage()){
                        HStack {
                            Image(systemName: "wrench")
                            Text("Help")
                        }
                    }
                    .navigationBarTitle(Text("Settings"))
                    .navigationBarItems(
                        trailing:
                        Button(action: {
                            print("dismiss settings view")
                            self.presentationMode.wrappedValue.dismiss()
                        } ) {
                            Text("Dismiss")
                        }
                    )
                    Button(action: {
                        print("Take to App Store")
                        SKStoreReviewController.requestReview()
                    }){ //Link to app store
                        HStack {
                            Image(systemName: "heart")
                            Text("Rate Iris")
                        }
                    }
                }
            }
        }
        
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
