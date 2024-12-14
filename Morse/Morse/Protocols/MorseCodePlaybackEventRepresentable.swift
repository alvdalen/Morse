//
//  MorseCodePlaybackEventRepresentable.swift
//  Morse
//
//  Created by Адам Мирзаканов on 14.12.2024.
//

import Foundation

protocol MorseCodePlaybackEventRepresentable {
  var playbackEvents: [MorseCodePlaybackEvent] { get }
  var components: [MorseCodePlaybackEventRepresentable] { get }
  var componentSeparationDuration: TimeInterval { get }
}

// MARK: - Default Implementation
extension MorseCodePlaybackEventRepresentable {
  var playbackEvents: [MorseCodePlaybackEvent] {
    components.flatMap {
      return $0.playbackEvents + [
        MorseCodePlaybackEvent.off(componentSeparationDuration)
      ]
    }
  }
}
