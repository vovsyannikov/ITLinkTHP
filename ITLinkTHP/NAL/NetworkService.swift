//
//  NetworkService.swift
//  ITLinkTHP
//
//  Created by Виталий Овсянников on 03.05.2025.
//

import OSLog
import SwiftUI

actor NetworkService: Networking {

	private let session: URLSession
	private let logger = Logger.utility()

	// MARK: - Lifecycle
	fileprivate init() {
		let memoryCapacity = 1_024 * 1_024 * 64
		let diskCapacity = 1_024 * 1_024 * 512
		let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity)

		let sessionConfig = URLSessionConfiguration.default
		sessionConfig.urlCache = cache
		sessionConfig.requestCachePolicy = .useProtocolCachePolicy
		sessionConfig.waitsForConnectivity = true

		self.session = URLSession(configuration: sessionConfig)
	}

	// MARK: - Actions
	func fetchImage(from url: URL) async throws -> Data {
		let urlRegex = #"https://.+"#

		if url.absoluteString.range(of: urlRegex, options: .regularExpression) == nil {
			logger.error("Invalid URL string: \(url)")
			throw URLError(.badURL)
		}

		let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 5)

		let (data, response) = try await session.retryingData(for: request)

		if let httpResponse = response as? HTTPURLResponse,
		   !( (200..<300) ~= httpResponse.statusCode ) {
			logger.error("Server responded with code: \(httpResponse.statusCode)")
			throw URLError(.badServerResponse)
		}

		return data
	}
}

// MARK: - Environment Injection
extension EnvironmentValues {
	@Entry var networkService: Networking = NetworkService()
}
