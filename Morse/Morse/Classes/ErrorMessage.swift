//
//  ErrorMessage.swift
//  Morse
//
//  Created by Адам Мирзаканов on 16.12.2024.
//

/// Перечисление сообщений об ошибках для различных случаев в приложении.
enum ErrorMessage {
  /// Сообщение об ошибке, если ожидаемый тип представления не совпадает с фактическим типом.
  static var errorTemplate: String {
    "Expected view to be of type %@ but got %@ instead"
  }
}
