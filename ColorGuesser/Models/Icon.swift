/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The model for an individual landmark.
*/

import SwiftUI

struct Icon: Hashable, Codable {
    var id: Int
    var name: String
    fileprivate var imageName: String
     
//    enum Category: String, CaseIterable, Codable, Hashable {
//        case featured = "Featured"
//        case lakes = "Lakes"
//        case rivers = "Rivers"
//    }
}

extension Icon {
    var image: Image {
        ImageStore.shared.image(name: imageName)
    }
}
