//
//  SafariView.swift
//  ColorGuesser
//
//  Created by Thomas Braun on 11/17/19.
//  Copyright © 2019 Thomas Braun. All rights reserved.
//
import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    typealias UIViewControllerType = CustomSafariViewController

    var url: URL?

    func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> CustomSafariViewController {
        return CustomSafariViewController()
    }

    func updateUIViewController(_ safariViewController: CustomSafariViewController, context: UIViewControllerRepresentableContext<SafariView>) {
        safariViewController.url = url
    }
}

#if DEBUG
struct SafariView_Previews: PreviewProvider {
    static var previews: some View {
        SafariView(url: URL(string: "https://twitter.com/tbraun1551")!)
    }
}
#endif
