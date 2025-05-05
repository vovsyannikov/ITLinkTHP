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
	@Environment(\.networkService) private var networkService

	@State private var images: [UIImage] = []
	@State private var loadInProgress: Set<Int> = []

	private static let logger = Logger.userInterface()
	private static let unloadedImageID = "INVALID"

	private let items = [
		GridItem(.adaptive(minimum: 100, maximum: 120), spacing: 5)
	]

	let urls: [URL]

	// MARK: - Body
    var body: some View {
		NavigationView {
			ScrollView {
				LazyVGrid(columns: items, spacing: 5) {
					ForEach(0..<images.count, id: \.self) { index in
						let image = images[index]

						if image.accessibilityIdentifier?.hasPrefix(Self.unloadedImageID) == true {
							reloadImageView(for: index)
						} else {
							imageButton(with: image)
						}
					}
				}
			}
			.navigationTitle("Картинки")
		}
		.task {
			await fetchData()
		}
    }

	// MARK: - Subviews
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
		Button(action: {
			Task {
				guard let image = await loadImage(for: imageIndex) else { return }
				images[imageIndex] = image
			}
		}) {
			Group {
				if loadInProgress.contains(imageIndex) {
					ProgressView()
				} else {
					Image(systemName: "photo")
						.imageScale(.large)
				}
			}
			.tint(.white)
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.frame(minHeight: 100)
			.background(.tint, in: .rect(cornerRadius: 15))
		}
	}

	// MARK: - Actions
	private func fetchData() async {

		images = Array(repeating: UIImage(), count: urls.count)

		await withTaskGroup { group in
			for index in urls.indices {
				group.addTask {
					let image = await loadImage(for: index)
					return (index: index, image: image)
				}
			}

			for await (index, image) in group {
				guard let image
				else {
					images[index].accessibilityIdentifier = "\(Self.unloadedImageID)_\(index)"
					continue
				}

				images[index] = image
			}
		}
	}


	private func loadImage(for index: Int) async -> UIImage? {
		let url = urls[index]
		loadInProgress.insert(index)

		defer { loadInProgress.remove(index) }

		do {
			let data = try await networkService.fetchImage(from: url)
			guard let image = UIImage(data: data) else { return nil }

			return image
		} catch {
			Self.logger.error("Image not loaded for \(url): \(error)")
		}

		return nil
	}
}

// MARK: - Previews
#Preview {
	let urls = Bundle.main.loadURLs()

	return HomeScreen(urls: urls)
}
