//
//  UILabel+Extensions.swift
//  TVMaze
//
//  Created by Gabriel Monteiro Camargo da Silva on 02/03/24.
//

import UIKit

extension UILabel {
    func highlight(searchedText: String, color: UIColor = .white, font: UIFont = .systemFont(ofSize: 17, weight: .bold)) {
        guard let txtLabel = self.text else {
            return
        }

        let attributeTxt = NSMutableAttributedString(string: txtLabel)
        let range: NSRange = attributeTxt.mutableString.range(of: searchedText, options: .caseInsensitive)

        attributeTxt.addAttribute(.foregroundColor, value: color, range: range)
        attributeTxt.addAttribute(.font, value: font, range: range)

        self.attributedText = attributeTxt
    }

}
