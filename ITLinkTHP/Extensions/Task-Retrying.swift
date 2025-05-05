//
//  Task-Retrying.swift
//  ITLinkTHP
//
//  Created by Виталий Овсянников on 03.05.2025.
//

import Foundation

extension Task where Failure == Error {

	@discardableResult
	static func retrying(
		priority: TaskPriority? = nil,
		maxRetryCount: Int = 3,
		operation: @Sendable @escaping () async throws -> Success
	) -> Task {
		Task(priority: priority) {
			let checkCancellation = Task<Never, Never>.checkCancellation

			for _ in 0 ..< maxRetryCount {
				try checkCancellation()

				do {
					return try await operation()
				} catch {
					continue
				}
			}

			try checkCancellation()

			return try await operation()
		}
	}
}
