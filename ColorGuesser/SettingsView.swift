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
    
    let instructions = """
        The goal of Iris, is to match the color of the block on the right to the color of the block on the left as accuratly as possible by using the sliders and + and - buttons. You can keep guessing as many times as you want to get the highest score possible, but only your first score will be submitted to Gamecenter.

    """
    //        To do this use the RGB sliders and + and - buttons below the blocks and once you think you got it hit Guess!
    //        If its your first guess, your score will be submitted to GameCenter so you can compare scores and compete against your friends to see who can get the highest score on their first try.
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var showActionSheet = false
    @State var showAppIconChanger = false
    
    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    Text("Instructions")
                        .fixedSize()
                        .font(.headline)
                        .multilineTextAlignment(.leading)
                    Text(instructions)
                        .font(.body)
                        .padding()
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
