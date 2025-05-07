//
//  HomeScreenViewModel.swift
//  ITLinkTHP
//
//  Created by Виталий Овсянников on 07.05.2025.
//

import OSLog
import SwiftUI

extension HomeScreen {

	@MainActor
	final class ViewModel: ObservableObject {
		// MARK: Props
		private static let unloadedImageID = "INVALID"

		@Published var loadStatus = LoadStatus.loaded
		@Published var images: [UIImage] = []
		@Published var error: NetworkError?

		private let networkService: Networking
		private let logger = Logger.viewModel()
		private var urls: [URL] = []
		private var loadInProgress: Set<Int> = []

		// MARK: - Lifecycle
		init(networkService: Networking) {
			self.networkService = networkService
		}

		// MARK: - Actions
		func loadImages() {
			Task { await performImageLoading() }
		}


		func reloadImage(at index: Int) {
			Task {
				guard let image = await loadImage(for: index) else { return }
				images[index] = image
			}
		}


		func reloadAllImages() async {
			urls = []

			await performImageLoading()
		}


		func imageIsLoading(at index: Int) -> Bool {
			loadInProgress.contains(index)
		}


		func imageIsEmpty(_ image: UIImage) -> Bool {
			image.accessibilityIdentifier?.hasPrefix(Self.unloadedImageID) == true
		}

		// MARK: - Helper methods
		private func performImageLoading() async {
			if urls.isEmpty {
				loadStatus = .loadingURLs

				do {
					urls = try await networkService.fetchURLs()
				} catch {
					logger.error("Some error occurred: \(error)")
					loadStatus = .loadFailed

					if let networkError = error as? NetworkError {
						self.error = networkError
					}

					if let urlError = error as? URLError,
					   urlError.code == .timedOut {
						self.error = .networkTimeout
					}

					return
				}
			}

			await fetchData()
		}

		private func fetchData() async {
			loadStatus = .loadingImages
			images = Array(repeating: UIImage(), count: urls.count)

			await withTaskGroup { group in
				for index in urls.indices {
					group.addTask {
						let image = await self.loadImage(for: index)
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

				loadStatus = .loaded
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
				logger.error("Image not loaded for \(url): \(error)")

				if let urlError = error as? URLError,
				   urlError.code == .timedOut {
					self.error = .networkTimeout
				}
			}

			return nil
		}
	}
}

extension HomeScreen.ViewModel {

	enum LoadStatus: String {
		case loaded = "Готово!"
		case loadingURLs = "Загрузка ссылок…"
		case loadingImages = "Загрузка картинок…"
		case loadFailed = "Ошибка"
	}
}
