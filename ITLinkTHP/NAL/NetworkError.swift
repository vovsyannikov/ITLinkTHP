//
//  NetworkError.swift
//  ITLinkTHP
//
//  Created by Виталий Овсянников on 07.05.2025.
//

import Foundation

enum NetworkError: LocalizedError {
	case invalidData
	case networkTimeout

	var errorDescription: String? {
		"Попробуйте повторить попытку"
	}

	var failureReason: String? {
		switch self {
		case .invalidData: "Некорректные данные"
		case .networkTimeout: "Истекло время запроса"
		}
	}
}
