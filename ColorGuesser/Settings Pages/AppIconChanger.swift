//
//  AppIconChanger.swift
//  ColorGuesser
//
//  Created by Thomas Braun on 11/6/19.
//  Copyright © 2019 Thomas Braun. All rights reserved.
//

import SwiftUI

struct AppIconChanger: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    func changeAppIcon(_ iconName: String){
        UIApplication.shared.setAlternateIconName(iconName) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Success! \(iconName)")
            }
        }
    }
    
    var body: some View {
        VStack{
            VStack {
				Spacer()
                Text("Change App Icon Color")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                List{
                    Button(action: {//Original Icon
                        UIApplication.shared.setAlternateIconName(nil) { error in
                            if let error = error {
                                print(error.localizedDescription)
                            } else {
                                print("Success!1")
                            }
                        }
                    }) {
                        HStack {
                            Image("Icon1")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(10.0)
                            Text("Purple")
                        }
                    }
                    
                    Button(action: {//Icon 2
                        self.changeAppIcon("AlternateIcon2")
                    }) {
                        HStack {
                            //                                Image("AlternateIcon2")
                            Image("AlternateIcon2")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(10.0)
                            Text("Ice Blue")
                        }
                    }
                    
                    Button(action: {//Icon 3
                        self.changeAppIcon("AlternateIcon3")
                    }) {
                        HStack {
                            Image("AlternateIcon3")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(10.0)
                            Text("Lime Green")
                        }
                    }
                    
                    Button(action: {//Icon 4
                        self.changeAppIcon("AlternateIcon4")
                    }) {
                        HStack {
                            Image("AlternateIcon4")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(10.0)
                            
                            Text("Red")
                        }
                    }
                    
                    Button(action: {
                        self.changeAppIcon("AlternateIcon5")
                    }) {
                        HStack {
                            Image("AlternateIcon5")
                                .renderingMode(.original)
                                .resizable()
                                .frame(width: 50, height: 50)
                                .cornerRadius(10.0)
                            Text("Navy Blue")
                        }
                    }
                }
//                .navigationBarHidden(true)
                .navigationBarTitle(Text("Change App Icon Color"), displayMode: .inline)
            }
        }
    }
}
struct IconChangerButton: View {
    
    let iconName: String
    //enum and switches
    
    
    var body: some View{
        Text("Hello World")
    }
}
struct AppIconChanger_Previews: PreviewProvider {
    static var previews: some View {
        AppIconChanger()
    }
}
