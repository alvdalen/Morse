//
//  Const.swift
//  Morse
//
//  Created by Адам Мирзаканов on 16.12.2024.
//

import UIKit

enum Const {
  static let placeholderText: String = "Write..."
  static let playMessageButtonTitleText: String = "Message"
  static let mainFontName: String = "Courier"
  
  static let playMessageButtonFont = UIFont(name: mainFontName, size: 30.0)
  static let placeholderTextViewFont = UIFont(name: mainFontName, size: 40.0)
  
  static let stackViewTopInset: CGFloat = 15.0
  static let stackViewHorizontalInset: CGFloat = 20.0
  static let stackViewWidthAdjustment: CGFloat = -40.0
  static let playMessageButtonCornerRadius: CGFloat = 10.0
  static let duration: CGFloat = 0.08
  static let pressingPlayButtonScale: CGFloat = 0.9
  static let playButtonScale: CGFloat = 1.0
  static let lineHeight: CGFloat = 1.0
  static let anchorImageViewSize: CGFloat = 100.0
  static let textViewStackViewSpacing: CGFloat = 10.0
  static let mainStackViewSpacing: CGFloat = 30.0
  
  static let anchorImage = UIImage(named: "Anchors")
  
  static let lightMainColor: UIColor = .systemGray
  static let darkMainColor: UIColor = .systemGray3
  static let rootViewBackgroundColor: UIColor = .tertiarySystemBackground
  static let playMessageButtonColor: UIColor = .black
}
