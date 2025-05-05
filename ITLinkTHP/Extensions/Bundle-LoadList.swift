//
//  Bundle-LoadList.swift
//  ITLinkTHP
//
//  Created by Виталий Овсянников on 03.05.2025.
//

import Foundation

extension Bundle {

	func loadList(
		forResource resource: String = "Links",
		withExtension aExtension: String = "txt"
	) -> [String] {
		guard let fileURL = url(forResource: resource, withExtension: aExtension),
			  let fileContents = try? String(contentsOf: fileURL, encoding: .utf8)
		else { return [] }

		return fileContents.components(separatedBy: .newlines)
	}


	func loadURLs(
		forResource resource: String = "Links",
		withExtension aExtension: String = "txt"
	) -> [URL] {
		loadList(forResource: resource, withExtension: aExtension)
			.compactMap(URL.init)
	}
}
