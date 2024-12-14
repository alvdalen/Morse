//
//  MorseCodeMessage.swift
//  Morse
//
//  Created by Адам Мирзаканов on 14.12.2024.
//

import Foundation

struct MorseCodeMessage {
  let words: [MorseCodeWord]
  
  // MARK: Initializers
  init?(message: String) {
    
    // получить слова в строке по отдельности в массиве
    // "Karin, Carrie, David" -> ["Karin", "Carrie", "David"]
    let components = message.components(separatedBy: " ")
    
    // передаем каждое слово в MorseCodeWord
    // после чего из экземпляров MorseCodeWord формируется массив
    self.words = components.compactMap { MorseCodeWord(word: $0)! }
    
    guard self.words.count == components.count else { return nil }
  }
}

// MARK: - MorseCodePlaybackEventRepresentable
// . . .   - - -   . . .       . . - .   - - -   . . .
extension MorseCodeMessage: MorseCodePlaybackEventRepresentable {
  var components: [MorseCodePlaybackEventRepresentable] { return words }
  var componentSeparationDuration: TimeInterval { return .morseCodeUnit * 7 }
}
