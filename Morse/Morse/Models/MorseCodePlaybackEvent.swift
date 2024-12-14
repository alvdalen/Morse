//
//  MorseCodePlaybackEvent.swift
//  Morse
//
//  Created by Адам Мирзаканов on 14.12.2024.
//

import Foundation

enum MorseCodePlaybackEvent {
  case on(TimeInterval)
  case off(TimeInterval)
  
  var duration: TimeInterval {
    switch self {
    case .on(let duration):
      return duration
    case .off(let duration):
      return duration
    }
  }
}
