//
//  AboutMe.swift
//  ColorGuesser
//
//  Created by Thomas Braun on 11/10/19.
//  Copyright © 2019 Thomas Braun. All rights reserved.
//

import SwiftUI
import SafariServices

struct AboutMe: View {
	
	@State var iconPicker = Int.random(in: 1...2)
	@State var r = Double.random(in: 0..<1)
	@State var b = Double.random(in: 0..<1)
	@State var g = Double.random(in: 0..<1)
	
	let aboutMe = """
Hey guys, my name is Thomas Braun.
I was born and raised in the city of Chicago, Illinois. I am currently a Computer Science and History major at Amherst College.
"""
	
	var body: some View {
		VStack {
			Text("About Me")
				.font(.largeTitle)
			Group{
				if (iconPicker == 1){
					Image("MeMoji1")
						.renderingMode(.original)
						.resizable()
						.frame(width: 200, height: 200)
						.clipShape(Circle())
						.overlay(Circle().stroke(Color(red: r, green: g, blue: b, opacity: 1.0), lineWidth: 5))
						.shadow(radius: 10)
				}   else {
					Image("MeMoji2")
						.renderingMode(.original)
						.resizable()
						.frame(width: 200, height: 200)
						.clipShape(Circle())
						.overlay(Circle().stroke(Color(red: r, green: g, blue: b, opacity: 1.0), lineWidth: 5))
						.shadow(radius: 10)
				}
				Text(aboutMe)
					.padding(.horizontal, 3.0)
			}
			Spacer()
			VStack {
				Text("Where You can Find Me")
					.font(.headline)
				//MARK: - Social Buttons
				SocialButton(link: "https://twitter.com/tbraun1551", name: "Twitter")
				SocialButton(link: "https://instagram.com/thomasbraun15", name: "Instagram")
				SocialButton(link: "https://www.linkedin.com/in/thomas-braun-7a41a1145/", name: "LinkedIn")
				SocialButton(link: "https://github.com/tbraun1551", name: "GitHub")
				SocialButton(link: "mailto:BraunDevelopment@icloud.com", name: "E-Mail")
			}
			.alignmentGuide(.leading) { dimension in
				5.0
			}
			Spacer()
		}
		.navigationBarTitle(Text(""), displayMode: .inline)
	}
}

struct SocialButton: View {
	
	let link: String
	let name: String
	
	var body: some View {
		Button(action: {
			let url = URL(string: self.link)!
			UIApplication.shared.open(url)
		}) {
			Text(self.name)
				.fixedSize()
				.font(.headline)
				.multilineTextAlignment(.leading)
		}
		.padding(5.0)
	}
}

struct AboutMe_Previews: PreviewProvider {
	static var previews: some View {
		AboutMe()
	}
}
