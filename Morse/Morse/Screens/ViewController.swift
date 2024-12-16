//
//  ViewController.swift
//  Morse
//
//  Created by Адам Мирзаканов on 14.12.2024.
//

import UIKit

final class ViewController: BaseViewController<ViewControllerRootView> {
  // MARK: Private Enums
  private enum PlayerMode: Int {
    case visual
  }
  
  // MARK: Private Properties
  private var activeMorseCodePlayers: [MorseCodePlayer] = []
  
  private var visualPlayerView: ViewControllerRootView {
    return rootView
  }
  
  // MARK: View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    rootView.delegate = self
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    configurePlayers(mode: .visual)
  }
  
  // MARK: Private Methods
  private func configurePlayers(mode: PlayerMode) {
    switch mode {
    case .visual:
      activeMorseCodePlayers = [visualPlayerView]
    }
  }
}

extension ViewController: RootViewDelegate {
  func playButtonTapped(message: MorseCodeMessage) {
    activeMorseCodePlayers.forEach {
      do {
        try $0.play(message: message)
        print(message)
      } catch {
        print("Ошибка: \(error)")
      }
    }
  }
}
