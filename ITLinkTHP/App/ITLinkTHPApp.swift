//
//  ITLinkTHPApp.swift
//  ITLinkTHP
//
//  Created by Виталий Овсянников on 03.05.2025.
//

import SwiftUI

@main
struct ITLinkTHPApp: App {
	@StateObject private var homeViewModel = HomeScreen.ViewModel(networkService: NetworkService.shared)

    var body: some Scene {
        WindowGroup {
			HomeScreen(viewModel: homeViewModel)
        }
    }
}
