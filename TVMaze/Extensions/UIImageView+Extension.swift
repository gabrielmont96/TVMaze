//
//  UIImageView+Extension.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import UIKit
import SDWebImage

extension UIImageView {
    func loadImageAndResize(from url: URL, newSize: CGSize) {
        sd_imageIndicator = SDWebImageActivityIndicator.white
        let imageCache = SDImageCache.shared
        imageCache.queryImage(forKey: url.absoluteString,
                              context: [.imageTransformer: SDImageResizingTransformer(size: newSize, scaleMode: .fill)],
                              cacheType: .all) { [weak self] image, _, _ in
            guard let self else { return }
            if let image {
                self.image = image
                self.sd_imageIndicator = nil
            } else {
                self.sd_setImage(with: url,
                                 placeholderImage: nil,
                                 context: [.imageTransformer: SDImageResizingTransformer(size: newSize, scaleMode: .fill)],
                                 progress: nil) { image, _, _, _ in
                    imageCache.store(image, forKey: url.absoluteString)
                }
            }
        }
    }
    
    func setCornerRadius(_ radius: CGFloat = 15) {
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}
