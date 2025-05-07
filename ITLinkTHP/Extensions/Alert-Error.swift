//
//  Alert-Error.swift
//  ITLinkTHP
//
//  Created by Виталий Овсянников on 07.05.2025.
//

import SwiftUI

extension View {
	func errorAlert<E: LocalizedError, A: View>(
		with error: Binding<E?>,
		@ViewBuilder actions: () -> A
	) -> some View {
		let wrappedError = error.wrappedValue
		let isPresented = Binding(
			get: { return wrappedError != nil },
			set: { _ in error.wrappedValue = nil }
		)

		return alert(
			wrappedError?.failureReason ?? "Something wend wrong",
			isPresented: isPresented,
			actions: actions
		) {
			Text(wrappedError?.errorDescription ?? "")
		}
	}
}
