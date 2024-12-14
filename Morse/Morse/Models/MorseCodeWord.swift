//
//  MorseCodeWord.swift
//  Morse
//
//  Created by Адам Мирзаканов on 14.12.2024.
//

import Foundation

struct MorseCodeWord {
  let characters: [MorseCodeCharacter]
  
  // MARK: Initializers
  init?(word: String) {
    self.characters = word.compactMap { MorseCodeCharacter(character: $0)! }
    guard word.count == self.characters.count else { return nil }
  }
}

// MARK: - MorseCodePlaybackEventRepresentable
// . . .   - - -   . . .
extension MorseCodeWord: MorseCodePlaybackEventRepresentable {
  var components: [MorseCodePlaybackEventRepresentable] { return characters }
  var componentSeparationDuration: TimeInterval { return .morseCodeUnit * 3 }
}
