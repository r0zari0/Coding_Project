//
//  CustomFont.swift
//  Coding_Project
//
//  Created by Max Stovolos on 4/15/23.
//

import UIKit

enum CustomFont: String {
    case bold = "Sk-Modernist-Bold"
    case regular = "Sk-Modernist-Mono"
    case mono = "Sk-Modernist-Regular"

    static func getFont(with size: CGFloat, and font: CustomFont) -> UIFont {
        return UIFont(name: font.rawValue, size: size)!
    }
}
