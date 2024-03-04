//
//  AppThemeConfig.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 01/03/24.
//

import UIKit

// API base url
extension String {
    static let apiBaseURL = "https://api.tvmaze.com"
}

// App theme
extension UIColor {
    static let tabBarBackground = UIColor.lightGray
    
    static let background = UIColor(red: 0.03, green: 0.07, blue: 0.09, alpha: 1)
    static let titleText = UIColor.white
    static let bodyText = UIColor.lightGray
    
    static let searchBarBarTint = UIColor.background
    static let searchBarTint = UIColor.black
    static let searchBarTextFieldText = UIColor.black
    static let searchBarTextFieldBackground = UIColor.lightGray
}

// Default fonts
extension UIFont {
    static let titleText = UIFont.systemFont(ofSize: 20, weight: .bold)
    static let bodyText = UIFont.systemFont(ofSize: 16)
    static let showListCell = UIFont.systemFont(ofSize: 14, weight: .bold)
}
