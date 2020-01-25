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
                I am sorry to hear that you have been having trouble with Iris. I have worked hard to try and make it as user friendly and bug free as possible, however as with any program there are bound to be bugs and issues.
            If you find any problems or need help, you can email me using the button below, or you can reach out to me using any of the links on the about page in settings.
            """
            )
                .padding()
			Spacer()
            Button(action: {
                let url = URL(string: "mailto:BraunDevelopment@icloud.com")!
                UIApplication.shared.open(url)
            }) {
                Text("E-Mail Me").fixedSize()
            }
            .padding()
			Spacer()
        }
        .navigationBarTitle(Text(""), displayMode: .inline)
    }
}

struct HelpPage_Previews: PreviewProvider {
    static var previews: some View {
        HelpPage()
    }
}
