//
//  MorseCodeSignal.swift
//  Morse
//
//  Created by Адам Мирзаканов on 14.12.2024.
//

import Foundation

enum MorseCodeSignal: String {
  case short = "."
  case long = "-"
}

// MARK: - MorseCodePlaybackEventRepresentable
extension MorseCodeSignal: MorseCodePlaybackEventRepresentable {
  var components: [MorseCodePlaybackEventRepresentable] { [] }
  var componentSeparationDuration: TimeInterval { return 0.0 }
  var playbackEvents: [MorseCodePlaybackEvent] {
    switch self {
    case .short:
      return [.on(.morseCodeUnit)]     // установить продолжительность [0.2]
    case .long:
      return [.on(.morseCodeUnit * 3)] // установить продолжительность [0.6]
    }
  }
}
