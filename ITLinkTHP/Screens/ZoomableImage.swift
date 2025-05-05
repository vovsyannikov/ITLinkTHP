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

	var scale = (1) ... (3.0)
	var currentScale = 1.0

	// MARK: - Lifecycle
	func makeUIView(context: Context) -> PDFView {
		let pdfView = PDFView()

		guard let pdfPage = PDFPage(image: image) else { return pdfView }

		let document = PDFDocument()
		document.insert(pdfPage, at: 0)

		pdfView.autoScales = true
		pdfView.document = document
		pdfView.backgroundColor = .clear

		assert(scale ~= currentScale)
		pdfView.minScaleFactor = scale.lowerBound
		pdfView.scaleFactor = pdfView.scaleFactorForSizeToFit
		pdfView.maxScaleFactor = scale.upperBound

		return pdfView
	}


	func updateUIView(_ pdfView: PDFView, context: Context) { }
}
