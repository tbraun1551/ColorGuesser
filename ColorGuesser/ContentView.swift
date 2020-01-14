//
//  ContentView.swift
//  ColorGuesser
//
//  Created by Thomas Braun on 9/16/19.
//  Copyright © 2019 Thomas Braun. All rights reserved.
//

import SwiftUI
import GoogleMobileAds
import UIKit
import GameKit

struct ContentView: View {
	//Checks whether app stupports haptic feedback
	let supportsHaptics: Bool = {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		return appDelegate.supportsHaptics
	}()
	
	var interstitialAd: Interstitial
	init(){
		self.interstitialAd = Interstitial()
		self.leaderboard = LeaderBoard()
		self.settings = SettingsView()
		self.gameCenter = GameCenterManager()
		self.gameCenter.authenticateLocalPlayer()
		self.gameKit = GameKitHelper.sharedInstance
		self.gameKit.authenticateLocalPlayer()
		self.haptics = Haptics()
		if supportsHaptics {
			self.haptics.createAndStartHapticEngine()   //FIX THIS TO WORK ONLUY IF IT SUPPORTS HAPTICS
		}
	}
	
	//GameCenter Variables
	@State var score = 0
	var gcEnabled = Bool() //Checks if the user had enabled GameCenter
	var gcDefaultLeaderboard = String() //Checks the default leaderboard ID
	let gameCenter: GameCenterManager
	/*End GameCenter Variables */
	
	var leaderboard: LeaderBoard
	var settings: SettingsView
	var haptics: Haptics
	
	//Haptic feedback methods
	let notification = UINotificationFeedbackGenerator()
	
	@State var rTarget = Double.random(in: 0..<1)
	@State var gTarget = Double.random(in: 0..<1)
	@State var bTarget = Double.random(in: 0..<1)
	@State var rGuess: Double = 0.5
	@State var gGuess: Double = 0.5
	@State var bGuess: Double = 0.5
	@State var showAlert = false
	@State var gameCounter = 0
	@State var settingsView = false
	@State var tryCounter = 1
	@State var showLeaderModal = false
	@State var showSettingsModal = false
	@State var showIrisSheet = false
	
	@State var animationAmount: CGFloat = 1
	
	@Environment(\.managedObjectContext) var managedObjectContext
	@EnvironmentObject var gameCenterKit: GameKitHelper
	let gameKit: GameKitHelper
	@State private var isShowingGameCenter = false {
		didSet {
			PopupControllerMessage.GameCenter.postNotification()
		}
	}
	
	
	//MARK: -Functions
	func computeScore() -> Int {
		let rDiff = rGuess - rTarget
		let gDiff = gGuess - gTarget
		let bDiff = bGuess - bTarget
		let diff = sqrt(rDiff * rDiff + gDiff * gDiff + bDiff * bDiff)
		return Int((1.0 - diff) * 100.0 + 0.5)
	}
	func showAdvertisment(){
		let randomAd = Bool.random()
		if (randomAd == true) {
			self.interstitialAd.showAd()
			print("Display Ad")
		} else {
			print("Not displaying Ad this time around")
		}
		self.interstitialAd.LoadInterstitial()
	}
	func submitScore(){
		if(tryCounter == 1){
			self.leaderboard.addScore(score: self.computeScore())
			self.gameCenter.submitScoreToGC(self.computeScore())
			print("score submitted to Game Center")
		}
	}
	func hitNewGame() {
		rGuess = 0.5
		gGuess = 0.5
		bGuess = 0.5
		rTarget = Double.random(in: 0..<1)
		gTarget = Double.random(in: 0..<1)
		bTarget = Double.random(in: 0..<1)
		tryCounter = 1
		self.interstitialAd.LoadInterstitial()
	}
	
	var body: some View {
		VStack {
			//MARK: -Top Buttons
			HStack {
				Button (action: {
					if self.gameCenterKit.enabled {
						self.isShowingGameCenter.toggle()
						self.hitNewGame()
						print("GameCenter")
					}
				}){
					HStack {
						Image(systemName: "gamecontroller")
							.font(.title)
					}
					.sheet(isPresented: self.$showLeaderModal) {
						LeaderBoardView()
					}
					.padding(15.0)
					.background(Color(red: rGuess, green: gGuess, blue: bGuess, opacity: 0.1))
					.cornerRadius(30.0)
					.shadow(color: .gray, radius: 20.0, x: 20, y: 10)
					.animation(.default)
				}
				.offset(x: -50.0, y: 0.0)
				
				Button(action: {
					self.showIrisSheet = true
				}) {
					Text("Iris")
						.font(.largeTitle)
						.fontWeight(.semibold)
						.multilineTextAlignment(.center)
						.foregroundColor(Color(red:rGuess + 0.2, green: gGuess + 0.2, blue: bGuess + 0.2))
				}.actionSheet(isPresented: $showIrisSheet) {
					ActionSheet(title: Text("How to play"), message: Text(settings.instructions), buttons: [.default(Text("Back To Game"))])
				}
				
				Button(action: {
					self.showSettingsModal = true
				}) {
					HStack {
						Image(systemName: "gear")
							.font(.title)
					} .sheet(isPresented: self.$showSettingsModal) {
						SettingsView()
					}
					.padding(15.0)
					.background(Color(red: rGuess, green: gGuess, blue: bGuess, opacity: 0.1))
					.cornerRadius(30.0)
				}
				.offset(x: 50, y: 0)
			}
			
			// MARK: - Rectangles
			HStack {
				VStack {
					Rectangle()
						.foregroundColor(Color(red: rTarget, green: gTarget, blue: bTarget, opacity: 1.0))
						.cornerRadius(10)
						.offset(x: -5.0, y: 0)
					//Text("Match this color!")
				}
				
				VStack {
					Rectangle()
						.foregroundColor(Color(red: rGuess, green: gGuess, blue: bGuess, opacity: 1.0))
						.cornerRadius(10)
						.offset(x: 5.0, y: 0)
					/* VALUE BELOW BLOCK
					HStack {
					Text("R: \(Int(rGuess * 255.0))")
					Text("G: \(Int(gGuess * 255.0))")
					Text("B: \(Int(bGuess * 255.0))")
					}
					*/
				}
			}
			
			//MARK: - Sliders
			VStack {
				HStack {
					MinusButton(value: $rGuess, haptics: self.haptics)
						.accentColor(Color(red: rGuess + 0.25, green: 0.0, blue: 0.0))
					ColorSlider(value: $rGuess)
						.accentColor(Color(red: rGuess + 0.25, green: 0.0, blue: 0.0))
					PlusButton(value: $rGuess, haptics: self.haptics)
						.accentColor(Color(red: rGuess + 0.25, green: 0.0, blue: 0.0))
				}
				HStack {
					MinusButton(value: $gGuess, haptics: self.haptics)
						.accentColor(Color(red: 0.0, green: gGuess + 0.25, blue: 0.0))
					ColorSlider(value: $gGuess)
						.accentColor(Color(red: 0.0, green: gGuess + 0.25, blue: 0.0))
					PlusButton(value: $gGuess, haptics: self.haptics)
						.accentColor(Color(red: 0.0, green: gGuess + 0.25, blue: 0.0))
					
				}
				HStack {
					MinusButton(value: $bGuess, haptics: self.haptics)
						.accentColor(Color(red: 0.0, green: 0.0, blue: bGuess + 0.25))
					ColorSlider(value: $bGuess)
						.accentColor(Color(red: 0.0, green: 0.0, blue: bGuess + 0.25))
					PlusButton(value: $bGuess, haptics: self.haptics)
						.accentColor(Color(red: 0.0, green: 0.0, blue: bGuess + 0.25))
					
				}
			}
			.padding(.horizontal, 10.0)
			
			//MARK: - Guess Button
			Button(action:{
				self.showAlert = true
				if self.supportsHaptics {
					self.haptics.playHapticTransient(time: 0.0, intensity: 0.98, sharpness: 0.98)
				}
			}) {
				HStack {
					Image(systemName: "eyedropper.halffull")
						.font(.title)
					Text("Guess")
						.font(.title)
						.fontWeight(.semibold)
				}
				.frame(minWidth: 0, maxWidth: 325)
				.padding()
			}
			.font(.title)
			.background(Color(red: rGuess, green: gGuess, blue: bGuess, opacity: 0.1))
			.cornerRadius(17.0)
			.shadow(color: .gray, radius: 20.0, x: 20, y: 10)
			.alert(isPresented: $showAlert) {
				Alert(title: Text("Your Score"), message: Text(" You got a score of \(computeScore())"), primaryButton: .default(Text("Keep Guessing")) {
					self.submitScore()
					print("Keeping Guessing")
					self.tryCounter += 1
					if(self.tryCounter % 3 == 0) {
						self.showAdvertisment()
						print("Potench showing a new ad")
					}
					}, secondaryButton: .cancel(Text("New Game")) {
						print("Final Guess")
						if(self.gameCounter % 2 == 0 || self.gameCounter % 5 == 0) {
							self.showAdvertisment()
							print("Potench showing a new ad")
						}
						self.submitScore()
						self.hitNewGame()
						self.gameCounter += 1;
						print(self.gameCounter)
					})
			}
			
		}
		.statusBar(hidden: true)
	}
}


//MARK: - Leftover Structures & Classes
struct ContentView_Previews: PreviewProvider {
	
	static var previews: some View {
		//        ContentView(rGuess: 0.5, gGuess: 0.5, bGuess: 0.5)
		ContentView()
	}
}

struct ColorSlider: View {
	
	@Binding var value: Double
	
	var body: some View {
		Slider(value: $value)
	}
}

struct PlusButton: View {
	
	@Binding var value: Double
	let haptics: Haptics
	
	let supportsHaptics: Bool = {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		return appDelegate.supportsHaptics
	}()
	
	var body: some View {
		Button(action: {
			let floatValue =  Float(self.value)
			self.value += 0.01
			if self.supportsHaptics {
				self.haptics.playHapticTransient(time: 0.0, intensity: floatValue, sharpness: floatValue)
			}
		}) {
			Text("+")
				.font(.title)
				.fontWeight(.bold)
		}
	}
}

struct MinusButton: View {
	
	let supportsHaptics: Bool = {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate
		return appDelegate.supportsHaptics
	}()
	
	@Binding var value: Double
	let haptics: Haptics
	
	var body: some View {
		Button(action: {
			let floatValue =  Float(self.value)
			self.value -= 0.01
			if self.supportsHaptics {
				self.haptics.playHapticTransient(time: 0.0, intensity: floatValue, sharpness: floatValue)
			}
		}) {
			Text("-")
				.font(.title)
				.fontWeight(.bold)
		}
	}
}

final class Interstitial: NSObject, GADInterstitialDelegate {
	
	var interstitial: GADInterstitial = GADInterstitial(adUnitID: "ca-app-pub-9580191478017853/2699461550")
	//    var interstitial:GADInterstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910") //Testing ID
	
	override init() {
		super.init()
		LoadInterstitial()
	}
	
	func LoadInterstitial(){
		let req = GADRequest()
		self.interstitial.load(req)
		self.interstitial.delegate = self
	}
	
	func interstitialWillPresentScreen(_ ad: GADInterstitial) {
		print("interstitialWillPresentScreen")
	}
	
	func showAd(){
		if self.interstitial.isReady{
			let root = UIApplication.shared.windows.first?.rootViewController
			self.interstitial.present(fromRootViewController: root!)
		}
		else{
			print("Not Ready")
		}
	}
	
	func interstitialDidDismissScreen(_ ad: GADInterstitial) {
		self.interstitial = GADInterstitial(adUnitID: "ca-app-pub-9580191478017853/2699461550")
		//        self.interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")//Testing ID
		LoadInterstitial()
	}
}
