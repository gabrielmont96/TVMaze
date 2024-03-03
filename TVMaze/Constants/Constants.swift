//
//  Constants.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import UIKit

extension String {
    static let apiBaseURL = "https://api.tvmaze.com"
}

extension UIColor {
    static let defaultBackgroundColor =  UIColor(red: 0.03, green: 0.07, blue: 0.09, alpha: 1)
}

enum CollectionViewConstants: CGFloat {
    case horizontal = 16
    case minimumLineSpacing = 25
    case headerHeight = 64
    
    var cgFloat: CGFloat { self.rawValue }
}

enum CollectionViewHeaderConstants: CGFloat {
    case horizontal = 16
    case imageHeight = 240
    
    var cgFloat: CGFloat { self.rawValue }
}

enum ShowCollectionViewCellConstants: CGFloat {
    case top = 8
    case fontSize = 13

    var cgFloat: CGFloat { self.rawValue }
}

enum ContentDetailsConstants: CGFloat {
    case imageWidth = 144
    case imageHeight = 171
    case imageLeading = 24
    case textsHorizontal = 23
    
    var cgFloat: CGFloat { self.rawValue }
}
