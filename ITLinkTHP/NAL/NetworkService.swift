//
//  NetworkService.swift
//  ITLinkTHP
//
//  Created by Виталий Овсянников on 03.05.2025.
//

import OSLog
import SwiftUI

@globalActor
actor NetworkService: Networking {
	
	static let shared = NetworkService()

	private let session: URLSession
	private let logger = Logger.utility()

	// MARK: - Lifecycle
	private init() {
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
	func fetchURLs() async throws -> [URL] {
		let url = URL(string:  "https://it-link.ru/test/images.txt")!

		let data = try await fetchData(from: url)

		guard let fileContents = String(data: data, encoding: .utf8)
		else { throw NetworkError.invalidData }

		return fileContents
			.components(separatedBy: .newlines)
			.compactMap(URL.init(string:))
	}

	func fetchImage(from url: URL) async throws -> Data {
		let urlRegex = #"https://.+"#

		if url.absoluteString.range(of: urlRegex, options: .regularExpression) == nil {
			logger.error("Invalid URL string: \(url)")
			throw URLError(.badURL)
		}

		return try await fetchData(from: url)
	}

	private func fetchData(from url: URL) async throws -> Data {
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
