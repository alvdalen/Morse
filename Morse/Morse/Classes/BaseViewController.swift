//
//  BaseViewController.swift
//  Morse
//
//  Created by Адам Мирзаканов on 16.12.2024.
//

import UIKit

class BaseViewController<ViewType: UIView>: UIViewController {
  
  typealias RootView = ViewType
  
  override func loadView() {
    let customView = RootView()
    view = customView
  }
}
