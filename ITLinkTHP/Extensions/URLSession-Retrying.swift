//
//  URLSession-Retrying.swift
//  ITLinkTHP
//
//  Created by Виталий Овсянников on 03.05.2025.
//

import Foundation

extension URLSession {

	func retryingData(for urlRequest: URLRequest, maxRetryCount: Int = 3) async throws -> (Data, URLResponse) {
		try await Task.retrying(maxRetryCount: maxRetryCount) {
			return try await self.data(for: urlRequest)
		}.value
	}
}
