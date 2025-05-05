//
//  ImageScreen.swift
//  ITLinkTHP
//
//  Created by Виталий Овсянников on 03.05.2025.
//

import SwiftUI

struct ImageScreen: View {

	// MARK: Props
	@State private var isNavBarHidden = false
	@State private var shouldHideNavBar = false

	let image: UIImage

	// MARK: - Body
	var body: some View {
		ZStack {
			Rectangle()
				.foregroundStyle(.black)
				.opacity(isNavBarHidden ? 1 : 0)
				.ignoresSafeArea()

			ZoomableImage(image: image)
				.simultaneousGesture(
					TapGesture()
						.onEnded(updateNavBarVisibility)
				)
		}
		.navigationBarHidden(isNavBarHidden)
	}

	// MARK: - Actions
	private func updateNavBarVisibility() {
		shouldHideNavBar.toggle()

		Task {
			try await Task.sleep(nanoseconds: 300_000_000)

			withAnimation(.default) {
				isNavBarHidden = shouldHideNavBar
			}
		}
	}
}

// MARK: - Previews
#Preview {
	HomeScreen(urls: Bundle.main.loadURLs())
}
