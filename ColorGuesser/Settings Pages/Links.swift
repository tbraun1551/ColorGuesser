//
//  Links.swift
//  ColorGuesser
//
//  Created by Thomas Braun on 11/17/19.
//  Copyright © 2019 Thomas Braun. All rights reserved.
//

import Foundation

enum LinkPage: CaseIterable, Identifiable {
    case twitter
    case instagram

    var id: String { url.absoluteString }

    var url: URL {
        switch self {
        case .twitter:
            return URL(string: "https://twitter.com/tbraun1551")!
        case .instagram:
            return URL(string: "https://instagram.com/thomasbraun15")!
        }
    }

    var title: String {
        switch self {
        case .twitter:
            return "Twitter"
        case .instagram:
            return "Instagram"
        }
    }

    var value: String {
        switch self {
        case .twitter:
            return "@tbraun1551"
        case .instagram:
            return "thomasbraun15"
        }
    }
}
