//
//  HelpPage.swift
//  ColorGuesser
//
//  Created by Thomas Braun on 11/10/19.
//  Copyright © 2019 Thomas Braun. All rights reserved.
//

import SwiftUI

struct HelpPage: View {
    var body: some View {
        VStack {
            Text("Help Page")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
                .multilineTextAlignment(.leading)
                .offset(x: -75)
            Text(
                """
                I am really sorry to here that you have been having trouble with my app. I have worked hard to try and make it as user friendly and bug free as possible, however it is my first app so there is bound to be some mistakes.
                If you find any problems or need help, you can email me using the button below, or you can reach out to me using any of the links on the about page in settings. 
            """
            )
                .padding()
            Button(action: {
                let url = URL(string: "mailto:BraunDevelopment@icloud.com")!
                UIApplication.shared.open(url)
            }) {
                Text("E-Mail Me").fixedSize()
            }
            .padding()
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
    }
}

struct HelpPage_Previews: PreviewProvider {
    static var previews: some View {
        HelpPage()
    }
}
