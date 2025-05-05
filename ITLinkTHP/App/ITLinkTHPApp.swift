//
//  ITLinkTHPApp.swift
//  ITLinkTHP
//
//  Created by Виталий Овсянников on 03.05.2025.
//

import SwiftUI

@main
struct ITLinkTHPApp: App {

	private let urls = Bundle.main.loadURLs()

    var body: some Scene {
        WindowGroup {
			HomeScreen(urls: urls)
        }
    }
}
