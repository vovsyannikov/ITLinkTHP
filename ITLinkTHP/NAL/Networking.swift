//
//  Networking.swift
//  ITLinkTHP
//
//  Created by Виталий Овсянников on 03.05.2025.
//

import Foundation

protocol Networking {
	func fetchImage(from url: URL) async throws -> Data
}
