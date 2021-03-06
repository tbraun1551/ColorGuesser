//
//  Haptics.swift
//  ColorGuesser
//
//  Created by Thomas Braun on 1/9/20.
//  Copyright © 2020 Thomas Braun. All rights reserved.
//

import Foundation
import CoreHaptics


public class Haptics {
	
	private var engine: CHHapticEngine!
    private var engineNeedsStart = true
//	private lazy var supportsHaptics: Bool = {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        return appDelegate.supportsHaptics
//    }()
	
	private let initialIntensity: Float = 1.0
    private let initialSharpness: Float = 0.5
	
	
	
	
	//Sets up the haptic Engine
	func createAndStartHapticEngine() {
		
		print("Creating and starting the haptic engine")
		
		// Create and configure a haptic engine.
		do {
			engine = try CHHapticEngine()
		} catch let error {
			fatalError("Engine Creation Error: \(error)")
		}
		
		// Mute audio to reduce latency for collision haptics.
		engine.playsHapticsOnly = true
		
		// The stopped handler alerts you of engine stoppage.
		engine.stoppedHandler = { reason in
			print("Stop Handler: The engine stopped for reason: \(reason.rawValue)")
			switch reason {
			case .audioSessionInterrupt: print("Audio session interrupt")
			case .applicationSuspended: print("Application suspended")
			case .idleTimeout: print("Idle timeout")
			case .systemError: print("System error")
			case .notifyWhenFinished: print("Playback finished")
			@unknown default:
				print("Unknown error")
			}
		}
		
		// The reset handler provides an opportunity to restart the engine.
		engine.resetHandler = {
			
			print("Reset Handler: Restarting the engine.")
			
			do {
				// Try restarting the engine.
				try self.engine.start()
				
				// Indicate that the next time the app requires a haptic, the app doesn't need to call engine.start().
				self.engineNeedsStart = false
				
			} catch {
				print("Failed to start the engine")
			}
		}
		
		// Start the haptic engine for the first time.
		do {
			try self.engine.start()
		} catch {
			print("Failed to start the engine: \(error)")
		}
	}
	
	
	// Play a haptic transient pattern at the given time, intensity, and sharpness.
	func playHapticTransient(time: TimeInterval, intensity: Float, sharpness: Float) {
		   
//		   // Abort if the device doesn't support haptics.
//		   if !supportsHaptics {
//			   return
//		   }
		   
		   // Create an event (static) parameter to represent the haptic's intensity.
		   let intensityParameter = CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
		   
		   // Create an event (static) parameter to represent the haptic's sharpness.
		   let sharpnessParameter = CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness)
		   
		   // Create an event to represent the transient haptic pattern.
		   let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensityParameter, sharpnessParameter], relativeTime: 0)
		   
		   // Create a pattern from the haptic event.
		   do {
			   let pattern = try CHHapticPattern(events: [event], parameters: [])
			   
			   // Create a player to play the haptic pattern.
			   let player = try engine.makePlayer(with: pattern)
			   try player.start(atTime: CHHapticTimeImmediate) // Play now.
		   } catch let error {
			   print("Error creating a haptic transient pattern: \(error)")
		   }
	   }
}
