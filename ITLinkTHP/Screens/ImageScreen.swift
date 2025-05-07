//
//  ImageScreen.swift
//  ITLinkTHP
//
//  Created by Виталий Овсянников on 03.05.2025.
//

import SwiftUI

struct ImageScreen: View {

	// MARK: Props
	@Environment(\.dismiss) private var dismiss

	@State private var isNavBarHidden = false
	@State private var shouldHideNavBar = false

	let image: UIImage

	// MARK: - Body
	var body: some View {
		ZStack(alignment: .topTrailing) {
			ZStack {
				Rectangle()
					.foregroundStyle(.black)
					.opacity(isNavBarHidden ? 1 : 0)

				ZoomableImage(image: image)
					.simultaneousGesture(
						TapGesture()
							.onEnded(updateNavBarVisibility)
					)
			}
			.ignoresSafeArea()

			if !isNavBarHidden {
				closeButton
			}
		}
		.navigationBarHidden(true)
	}

	// MARK: - Subviews
	private var closeButton: some View {
		Button(action: { dismiss() }) {
			Image(systemName: "xmark")
				.padding(15)
				.background(.ultraThinMaterial, in: .circle)
				.tint(.primary)
				.padding(10)
		}
		.transition(.opacity)
		.zIndex(1)
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
	HomeScreen(viewModel: .init(networkService: NetworkService.shared))
}
