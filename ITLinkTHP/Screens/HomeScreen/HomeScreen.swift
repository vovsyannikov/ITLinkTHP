//
//  HomeScreen.swift
//  ITLinkTHP
//
//  Created by Виталий Овсянников on 03.05.2025.
//

import OSLog
import SwiftUI

struct HomeScreen: View {

	// MARK: Props
	private static let logger = Logger.userInterface()

	@ObservedObject var viewModel: ViewModel

	private let items = [
		GridItem(.adaptive(minimum: 100, maximum: 120), spacing: 5)
	]

	// MARK: - Body
    var body: some View {
		NavigationView {
			ZStack {
				imagesGridView

				if viewModel.loadStatus != .loaded {
					emptyView
				}

				if viewModel.loadStatus == .loadFailed {
					errorView
				}
			}
			.navigationTitle("Картинки")
			.errorAlert(with: $viewModel.error, actions: {})
		}
		.onAppear(perform: viewModel.loadImages)
    }

	// MARK: - Subviews
	private var emptyView: some View {
		ProgressView(viewModel.loadStatus.rawValue)
	}

	private var errorView: some View {
		VStack(spacing: 20) {
			Image(systemName: "exclamationmark.triangle.fill")
				.foregroundStyle(.orange)
				.imageScale(.large)

			Text(viewModel.loadStatus.rawValue)
				.font(.title2)

			Button(action: viewModel.loadImages) {
				Text("Перезагрузить")
					.font(.headline)
					.padding(.vertical, 5)
					.padding(.horizontal, 10)
					.overlay(.tint, in: .rect(cornerRadius: 5).stroke(lineWidth: 2))
			}
		}
	}

	private var imagesGridView: some View {
		ScrollView {
			LazyVGrid(columns: items, spacing: 5) {
				imagesView
			}
		}
		.refreshable {
			await viewModel.reloadAllImages()
		}
	}

	private var imagesView: some View {
		ForEach(0 ..< viewModel.images.count, id: \.self) { index in
			let image = viewModel.images[index]

			if viewModel.imageIsEmpty(image) {
				reloadImageView(for: index)
			} else {
				imageButton(with: image)
			}
		}
	}

	private func imageButton(with image: UIImage) -> some View {
		NavigationLink(destination: {
			ImageScreen(image: image)
		}) {
			Rectangle()
				.foregroundStyle(.secondary)
				.aspectRatio(1, contentMode: .fill)
				.overlay {
					Image(uiImage: image.scaled(to: CGSize(width: 100, height: 100)))
						.resizable()
						.scaledToFill()
				}
				.clipShape(.rect(cornerRadius: 20, style: .circular))
		}
	}


	private func reloadImageView(for imageIndex: Int) -> some View {
		Button(action: { viewModel.reloadImage(at: imageIndex) }) {
			Group {
				if viewModel.imageIsLoading(at: imageIndex) {
					ProgressView()
				} else {
					Image(systemName: "arrow.counterclockwise")
						.imageScale(.large)
				}
			}
			.tint(.white)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.frame(minHeight: 100)
			.background(.tint, in: .rect(cornerRadius: 15))
		}
	}
}

// MARK: - Previews
#Preview {
	HomeScreen(viewModel: .init(networkService: NetworkService.shared))
}
