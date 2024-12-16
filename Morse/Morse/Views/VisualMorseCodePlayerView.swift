//
//  VisualMorseCodePlayerView.swift
//  Morse
//
//  Created by Адам Мирзаканов on 14.12.2024.
//

import UIKit

final class VisualMorseCodePlayerView: UIView {
  // MARK: Private Methods
  private func scheduleColorChange(
    for event: MorseCodePlaybackEvent,
    at timeInterval: TimeInterval
  ) {
    let color = colorForEvent(event)
    Timer.scheduledTimer(
      withTimeInterval: timeInterval,
      repeats: false) { _ in
        self.backgroundColor = color
      }
  }
  
  private func colorForEvent(_ event: MorseCodePlaybackEvent) -> UIColor {
    switch event {
    case .off:
      return .black
    case .on:
      return .systemRed
    }
  }
  
  private func scheduleResetColor(at timeInterval: TimeInterval) {
    Timer.scheduledTimer(
      withTimeInterval: timeInterval,
      repeats: false) { _ in
        self.backgroundColor = .black
      }
  }
}

// MARK: - MorseCodePlayer
extension VisualMorseCodePlayerView: MorseCodePlayer {
  func play(message: MorseCodeMessage) throws {
    var startTimeInterval: TimeInterval = .zero
    for event in message.playbackEvents {
      scheduleColorChange(for: event, at: startTimeInterval)
      startTimeInterval += event.duration
      scheduleResetColor(at: startTimeInterval)
    }
  }
}
