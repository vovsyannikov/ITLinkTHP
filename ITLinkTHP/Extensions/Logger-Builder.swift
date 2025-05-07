//
//  Logger-Builder.swift
//  ITLinkTHP
//
//  Created by Виталий Овсянников on 05.05.2025.
//

import Foundation
import OSLog

extension Logger {
	static let mainSubsystem = Bundle.main.bundleIdentifier ?? "ITLinkTHP"

	static func userInterface(category: String = #function) -> Logger {
		Logger(subsystem: mainSubsystem, category: "UI: (\(category))")
	}

	static func utility(category: String = #function) -> Logger {
		Logger(subsystem: mainSubsystem, category: "Utility: (\(category))")
	}

	static func viewModel(category: String = #function) -> Logger {
		Logger(subsystem: mainSubsystem, category: "ViewModel: (\(category))")
	}
}
