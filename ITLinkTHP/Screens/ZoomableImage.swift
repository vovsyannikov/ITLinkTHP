//
//  ZoomableImage.swift
//  ITLinkTHP
//
//  Created by Виталий Овсянников on 03.05.2025.
//

import SwiftUI
import PDFKit

struct ZoomableImage: UIViewRepresentable {

	// MARK: Props
	let image: UIImage

	var scale = (0.5) ... (3.0)
	var currentScale = 1.0

	// MARK: - Lifecycle
	func makeUIView(context: Context) -> PDFView {
		let pdfView = PDFView()

		let mainScreenSize = UIScreen.main.bounds.size

		let scaledImage: UIImage

		if image.size.width > mainScreenSize.width {
			scaledImage = image.scaled(to: mainScreenSize)
		} else {
			scaledImage = image
		}

		let scaleFactor = (mainScreenSize.width / scaledImage.size.width) - 0.1

		guard let pdfPage = PDFPage(image: scaledImage) else { return pdfView }

		let document = PDFDocument()
		document.insert(pdfPage, at: 0)

		pdfView.document = document
		pdfView.autoScales = true
		pdfView.backgroundColor = .clear

		assert(scale ~= currentScale)

		pdfView.minScaleFactor = scale.lowerBound
		pdfView.scaleFactor = scaleFactor
		pdfView.maxScaleFactor = scale.upperBound


		return pdfView
	}


	func updateUIView(_ pdfView: PDFView, context: Context) { }
}
