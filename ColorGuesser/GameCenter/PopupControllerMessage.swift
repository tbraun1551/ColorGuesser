//
//  PopupControllerMessage.swift
//  GameCenterTest
//
//  Created by Thomas Braun on 11/24/19.
//  Copyright © 2019 Braun. All rights reserved.
//

import Foundation
import GameKit
import UIKit

// Messages sent using the Notification Center to trigger
// Game Center's Popup screen
public enum PopupControllerMessage : String {
    case PresentAuthentication = "PresentAuthenticationViewController"
    case GameCenter = "GameCenterViewController"
}

extension PopupControllerMessage {
    public func postNotification() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: self.rawValue), object: self)
    }
    
    public func addHandlerForNotification(_ observer: Any, handler: Selector) {
        NotificationCenter.default.addObserver(observer, selector: handler, name: NSNotification.Name(rawValue: self.rawValue), object: nil)
    }
}
