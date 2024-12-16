//
//  BaseRootView.swift
//  Morse
//
//  Created by Адам Мирзаканов on 16.12.2024.
//

import UIKit

class BaseRootView: UIView {
  // MARK: Initializers
  init() {
    super.init(frame: .zero)
    initViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError(ErrorMessage.initCoderNotImplementedError)
  }
  
  // MARK: Internal Methods
  /// Подклассы должны переопределять этот метод.
  func initViews() {
//    backgroundColor = .systemBackground
  }
}
