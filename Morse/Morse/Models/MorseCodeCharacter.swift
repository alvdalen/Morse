//
//  MorseCodeCharacter.swift
//  Morse
//
//  Created by Адам Мирзаканов on 14.12.2024.
//

import Foundation

struct MorseCodeCharacter {
  let signals: [MorseCodeSignal]
  private let character: Character
  
  // MARK: Initializers
  init?(character: Character) {
    self.character = character
    guard
      let pattern = CharacterToPatternDictionary.characterToPatternDictionary[
        character.lowercased()
      ]
    else {
      return nil
    }
    self.signals = pattern.map {
      MorseCodeSignal(rawValue: String($0))!
    }
  }
}

// MARK: - MorseCodePlaybackEventRepresentable
// . . - .
extension MorseCodeCharacter: MorseCodePlaybackEventRepresentable {
  var components: [MorseCodePlaybackEventRepresentable] { return signals }
  var componentSeparationDuration: TimeInterval { return .morseCodeUnit }
}
