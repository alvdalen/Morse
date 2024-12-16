//
//  SceneDelegate.swift
//  Morse
//
//  Created by Адам Мирзаканов on 14.12.2024.
//

import UIKit

final class SceneDelegate: UIResponder {
  var window: UIWindow?
}

// MARK: - UIWindowSceneDelegate
extension SceneDelegate: UIWindowSceneDelegate {
  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    configWindow(with: scene)
  }
}

// MARK: - Config Window
private extension SceneDelegate {
  func configWindow(with scene: UIScene) {
    guard let windowScene = scene as? UIWindowScene else { return }
    let viewController = ViewController()
    window = UIWindow(windowScene: windowScene)
    window?.windowScene = windowScene
    window?.rootViewController = viewController
    window?.makeKeyAndVisible()
  }
}
