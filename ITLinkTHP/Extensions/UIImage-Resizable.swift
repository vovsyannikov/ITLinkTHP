//
//  UIImage-Resizable.swift
//  ITLinkTHP
//
//  Created by Виталий Овсянников on 05.05.2025.
//

import UIKit

extension UIImage {

	/// Scales the image to desired size
	///
	/// Use this method to create scaled down version of the image to minimize memory impact from
	/// displaying it in full size
	///
	/// - Parameter targetSize: Size to scale the image to
	/// - Returns: Scaled image to the designated `targetSize`
	func scaled(to targetSize: CGSize) -> UIImage {
		let widthRatio = targetSize.width / size.width
		let heightRatio = targetSize.height / size.height

		let scaleFactor = min(widthRatio, heightRatio)

		let scaledSize = CGSize(
			width: size.width * scaleFactor,
			height: size.height * scaleFactor
		)

		let renderer = UIGraphicsImageRenderer(size: scaledSize)
		let boundsForDrawing = CGRect(origin: .zero, size: scaledSize)

		return renderer.image { _ in
			self.draw(in: boundsForDrawing)
		}
	}
}
